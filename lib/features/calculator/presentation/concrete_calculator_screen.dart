import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/slab_sketcher.dart';

// --- Constants ---
const List<String> kConcreteTypes = ['H13', 'H17', 'H21', 'H25', 'H30', 'H35'];
const List<String> kBlockHeights = ['10 cm (Losa 15)', '12 cm (Losa 17)', '16 cm (Losa 21)'];
const Map<String, double> kLightweightConsumption = {
  '10 cm (Losa 15)': 0.072, // m3 per m2 (approx for vigueta simple)
  '12 cm (Losa 17)': 0.081,
  '16 cm (Losa 21)': 0.095,
};

enum StructureType {
  losaArmada('Losa Armada', Icons.layers),
  losaAlivianada('Losa Alivianada', Icons.grid_view),
  platea('Platea', Icons.foundation),
  columna('Columna', Icons.view_column),
  tabique('Tabique', Icons.crop_portrait);

  final String label;
  final IconData icon;
  const StructureType(this.label, this.icon);
}
// ----------------

class ConcreteCalculatorScreen extends StatefulWidget {
  const ConcreteCalculatorScreen({super.key});

  @override
  State<ConcreteCalculatorScreen> createState() => _ConcreteCalculatorScreenState();
}

class _ConcreteCalculatorScreenState extends State<ConcreteCalculatorScreen> {
  // Global
  String _selectedConcrete = 'H21';

  // Manual State
  final _manualFormKey = GlobalKey<FormState>();
  StructureType _manualStructure = StructureType.losaArmada;
  final _lCtrl = TextEditingController();
  final _wCtrl = TextEditingController();
  final _hCtrl = TextEditingController(); // Thickness or Height
  String _manualBlockHeight = kBlockHeights[1]; // Default 12cm
  double? _manualResult;

  // Interactive State
  SketcherMode _sketchMode = SketcherMode.slab;
  bool _isLightweightSlab = false;
  double _snapRes = 1.0; 
  double _zoomLevel = 1.0;
  
  double _sketchSlabArea = 0;
  double _sketchSlabThickness = 0.15; // For Solid
  String _sketchBlockHeight = kBlockHeights[1]; // For Lightweight
  
  // Beams Data
  List<BeamSegment> _currentBeamSegments = [];
  final List<BeamDefinition> _beamTypes = [
    BeamDefinition(id: 'v1', name: 'V1', color: AppTheme.industrialOrange, width: 0.20, depth: 0.30),
  ];
  String _activeBeamId = 'v1';

  late SlabSketcherController _sketcherController;

  @override
  void initState() {
    super.initState();
    _sketcherController = SlabSketcherController();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hormigón', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
             // Global Concrete Type Selector
             DropdownButtonHideUnderline(
               child: DropdownButton<String>(
                 value: _selectedConcrete,
                 dropdownColor: Colors.white,
                 icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryCyan),
                 style: const TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold),
                 items: kConcreteTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                 onChanged: (v) => setState(() => _selectedConcrete = v!),
               ),
             ),
             const SizedBox(width: 16),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cálculo Manual'),
              Tab(text: 'Dibujo (Beta)'),
            ],
            indicatorColor: AppTheme.primaryCyan,
            labelColor: AppTheme.primaryCyan,
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), 
          children: [
            _buildManualTab(context),
            _buildInteractiveTab(context),
          ],
        ),
      ),
    );
  }

  // --- MANUAL TAB ---
  Widget _buildManualTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _manualFormKey,
        child: Column(
          children: [
            // Structure Toggle
            DropdownButtonFormField<StructureType>(
              value: _manualStructure,
              decoration: InputDecoration(
                labelText: 'Tipo de Estructura',
                prefixIcon: Icon(_manualStructure.icon, color: AppTheme.primaryCyan),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true, fillColor: Colors.white,
              ),
              items: StructureType.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
              onChanged: (v) {
                setState(() {
                   _manualStructure = v!;
                   _manualResult = null;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Dynamic Fields
            if (_manualStructure == StructureType.columna) ...[
               _buildInput(_lCtrl, 'Lado A (m)'),
               const SizedBox(height: 12),
               _buildInput(_wCtrl, 'Lado B (m)'),
               const SizedBox(height: 12),
               _buildInput(_hCtrl, 'Altura (m)'),
            ] else if (_manualStructure == StructureType.tabique) ...[
               _buildInput(_lCtrl, 'Largo (m)'),
               const SizedBox(height: 12),
               _buildInput(_wCtrl, 'Espesor (m)'),
               const SizedBox(height: 12),
               _buildInput(_hCtrl, 'Altura (m)'),
            ] else if (_manualStructure == StructureType.losaAlivianada) ...[
               _buildInput(_lCtrl, 'Largo (m)'),
               const SizedBox(height: 12),
               _buildInput(_wCtrl, 'Ancho (m)'),
               const SizedBox(height: 12),
               DropdownButtonFormField<String>(
                 value: _manualBlockHeight,
                 decoration: InputDecoration(labelText: 'Altura Bloque', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
                 items: kBlockHeights.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                 onChanged: (v) => setState(() => _manualBlockHeight = v!),
               ),
            ] else ...[ 
               // Losa Armada / Platea
               _buildInput(_lCtrl, 'Largo (m)'),
               const SizedBox(height: 12),
               _buildInput(_wCtrl, 'Ancho (m)'),
               const SizedBox(height: 12),
               _buildInput(_hCtrl, 'Espesor (m) - ej: 0.15'),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateManual,
              child: const Text('CALCULAR'),
            ),
            if (_manualResult != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(12),
                     border: const Border(left: BorderSide(color: AppTheme.industrialOrange, width: 4)),
                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: Column(
                    children: [
                      Text('${_manualStructure.label} ($_selectedConcrete)', style: const TextStyle(color: AppTheme.cementGray)),
                      const SizedBox(height: 4),
                      Text('${_manualResult!.toStringAsFixed(2)} m³', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.industrialOrange)),
                      const Text('Incluye 5% desperdicio', style: TextStyle(fontSize: 10, color: AppTheme.cementGray)),
                    ],
                  ),
                )
            ]
          ],
        ),
      ),
    );
  }

  void _calculateManual() {
     if (!_manualFormKey.currentState!.validate()) return;
     
     double vol = 0;
     final l = double.parse(_lCtrl.text);
     final w = _manualStructure == StructureType.tabique ? double.parse(_wCtrl.text) : 
               (_manualStructure == StructureType.columna ? double.parse(_wCtrl.text) : double.parse(_wCtrl.text)); 
               // Reusing wCtrl for thickness in Tabique logic or Width in others. 
               // Oops variable names are visual logic, let's keep simple.
     
     if (_manualStructure == StructureType.losaAlivianada) {
       final factor = kLightweightConsumption[_manualBlockHeight] ?? 0.085;
       vol = l * w * factor;
     } else {
       final h = double.parse(_hCtrl.text);
       vol = l * w * h;
     }
     
     setState(() {
       _manualResult = vol * 1.05;
     });
  }

  // --- INTERACTIVE TAB ---
  Widget _buildInteractiveTab(BuildContext context) {
    // 1. Calculate Slab Volume
    double slabVol = 0;
    if (_isLightweightSlab) {
       final factor = kLightweightConsumption[_sketchBlockHeight] ?? 0.085;
       slabVol = _sketchSlabArea * factor;
    } else {
       slabVol = _sketchSlabArea * _sketchSlabThickness;
    }
    
    // 2. Calculate Beams Volume
    double beamVol = 0;
    for (var seg in _currentBeamSegments) {
       final def = _beamTypes.firstWhere((b) => b.id == seg.typeId, orElse: () => _beamTypes.first);
       double lengthMeters = (seg.end - seg.start).distance;
       beamVol += (lengthMeters * def.width * def.depth);
    }
    
    final total = (slabVol + beamVol) * 1.05;

    return Column(
      children: [
        // Top Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: Column(
            children: [
              // Row 1: Global Settings
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<double>(
                      value: _snapRes,
                      decoration: InputDecoration(
                        labelText: 'Precisión',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: const [DropdownMenuItem(value: 1.0, child: Text('1 m')), DropdownMenuItem(value: 0.5, child: Text('0.5 m')), DropdownMenuItem(value: 0.25, child: Text('0.25 m'))],
                      onChanged: (v) => setState(() => _snapRes = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove, size: 16), constraints: const BoxConstraints(minWidth: 32, minHeight: 32), onPressed: _zoomLevel > 0.4 ? () => setState(() => _zoomLevel -= 0.2) : null),
                        SizedBox(width: 35, child: Text('${(_zoomLevel * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        IconButton(icon: const Icon(Icons.add, size: 16), constraints: const BoxConstraints(minWidth: 32, minHeight: 32), onPressed: _zoomLevel < 1.4 ? () => setState(() => _zoomLevel += 0.2) : null),
                      ],
                    )
                  )
                ],
              ),
              const SizedBox(height: 8),
              
              // Row 2: Mode & Palette
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    ToggleButtons(
                      constraints: const BoxConstraints(minHeight: 32, minWidth: 40),
                      borderRadius: BorderRadius.circular(8),
                      isSelected: [_sketchMode == SketcherMode.slab, _sketchMode == SketcherMode.beam],
                      onPressed: (idx) => setState(() => _sketchMode = idx == 0 ? SketcherMode.slab : SketcherMode.beam),
                      children: const [
                        Tooltip(message: 'Losa', child: Icon(Icons.grid_4x4, color: AppTheme.primaryCyan)),
                        Tooltip(message: 'Vigas', child: Icon(Icons.view_week, color: AppTheme.industrialOrange)),
                      ],
                    ),
                    const VerticalDivider(width: 20),
                    if (_sketchMode == SketcherMode.beam)
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _beamTypes.length + 1, 
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (ctx, idx) {
                            if (idx == _beamTypes.length) return IconButton(onPressed: _addNewBeamType, icon: const Icon(Icons.add_circle, color: AppTheme.cementGray));
                            final beam = _beamTypes[idx];
                            return GestureDetector(
                              onTap: () => setState(() => _activeBeamId = beam.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: beam.id == _activeBeamId ? beam.color.withOpacity(0.1) : Colors.transparent,
                                  border: Border.all(color: beam.id == _activeBeamId ? beam.color : Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(beam.name, style: TextStyle(color: beam.id == _activeBeamId ? beam.color : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            );
                          },
                        ),
                      )
                    else 
                       // Slab Settings in Toolbar
                       Expanded(
                         child: Row(
                           children: [
                             const Text('Tipo:', style: TextStyle(fontSize: 12)),
                             const SizedBox(width: 8),
                             ChoiceChip(
                               label: const Text('Maciza', style: TextStyle(fontSize: 12)),
                               selected: !_isLightweightSlab,
                               onSelected: (v) => setState(() => _isLightweightSlab = false),
                               visualDensity: VisualDensity.compact,
                             ),
                             const SizedBox(width: 8),
                             ChoiceChip(
                               label: const Text('Alivianada', style: TextStyle(fontSize: 12)),
                               selected: _isLightweightSlab,
                               onSelected: (v) => setState(() => _isLightweightSlab = true),
                               visualDensity: VisualDensity.compact,
                             ),
                           ],
                         ),
                       )
                  ],
                ),
              )
            ],
          ),
        ),
        
        // Canvas (Pass zoomLevel)
        Expanded(
          child: Container(
             color: const Color(0xFFF9FAFB),
             child: SlabSketcher(
               controller: _sketcherController,
               mode: _sketchMode,
               snapRes: _snapRes,
               zoomLevel: _zoomLevel,
               beamDefinitions: _beamTypes,
               activeBeamId: _activeBeamId,
               onSlabAreaChanged: (a) => setState(() => _sketchSlabArea = a),
               onBeamsChanged: (beams) => setState(() => _currentBeamSegments = beams),
             ),
          ),
        ),
        
        // Bottom Controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -2), blurRadius: 4)]),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                      // Active Element Config
                      if (_sketchMode == SketcherMode.slab)
                        Expanded(
                          child: _isLightweightSlab 
                           ? DropdownButtonFormField<String>(
                               value: _sketchBlockHeight,
                               isDense: true,
                               decoration: InputDecoration(labelText: 'Bloque', filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.all(8)),
                               items: kBlockHeights.map((h) => DropdownMenuItem(value: h, child: Text(h, style: const TextStyle(fontSize: 12)))).toList(),
                               onChanged: (v) => setState(() => _sketchBlockHeight = v!),
                             )
                           : _buildMiniInput('Espesor (m)', _sketchSlabThickness.toString(), (v) => setState(() => _sketchSlabThickness = double.tryParse(v) ?? 0.15)),
                        )
                      else 
                        Expanded(child: Row(children: [
                            Text(_beamTypes.firstWhere((b) => b.id == _activeBeamId).name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(icon: const Icon(Icons.edit, size: 16, color: AppTheme.primaryCyan), onPressed: () => _editBeamType(_beamTypes.firstWhere((b) => b.id == _activeBeamId)))
                        ])),
                      
                      const SizedBox(width: 16),
                      // Actions
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.undo, color: AppTheme.cementGray), onPressed: () => _sketcherController.undo()),
                          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _sketcherController.clear()),
                        ],
                      )
                   ],
                ),
                const SizedBox(height: 12),
                // Total
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Vol. Losa: ${slabVol.toStringAsFixed(2)} m³', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        Text('Vol. Vigas: ${beamVol.toStringAsFixed(2)} m³', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Tipo: $_selectedConcrete', style: const TextStyle(color: AppTheme.industrialOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
                         const Text('TOTAL (+5%)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 10)),
                         Text('${total.toStringAsFixed(2)} m³', style: const TextStyle(color: AppTheme.industrialOrange, fontSize: 24, fontWeight: FontWeight.bold)),
                      ])
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _addNewBeamType() { _showBeamDialog(); }
  void _editBeamType(BeamDefinition beam) { _showBeamDialog(isEdit: true, beam: beam); }
  
  void _showBeamDialog({bool isEdit = false, BeamDefinition? beam}) {
     showDialog(
       context: context,
       builder: (ctx) {
         final nameCtrl = TextEditingController(text: isEdit ? beam!.name : 'V${_beamTypes.length + 1}');
         final wCtrl = TextEditingController(text: isEdit ? beam!.width.toString() : '0.20');
         final dCtrl = TextEditingController(text: isEdit ? beam!.depth.toString() : '0.30');
         return AlertDialog(
           title: Text(isEdit ? 'Editar Viga' : 'Nueva Viga'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
               const SizedBox(height: 8),
               Row(children: [
                 Expanded(child: TextField(controller: wCtrl, decoration: const InputDecoration(labelText: 'Ancho (m)'), keyboardType: TextInputType.number)),
                 const SizedBox(width: 8),
                 Expanded(child: TextField(controller: dCtrl, decoration: const InputDecoration(labelText: 'Alto (m)'), keyboardType: TextInputType.number)),
               ]),
             ],
           ),
           actions: [
             TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
             TextButton(
               onPressed: () {
                 final width = double.tryParse(wCtrl.text) ?? 0.20;
                 final depth = double.tryParse(dCtrl.text) ?? 0.30;
                 setState(() {
                   if (isEdit) {
                     final idx = _beamTypes.indexWhere((b) => b.id == beam!.id);
                     if (idx != -1) _beamTypes[idx] = BeamDefinition(id: beam!.id, name: nameCtrl.text, width: width, depth: depth, color: beam.color);
                   } else {
                     final newId = 'v${DateTime.now().millisecondsSinceEpoch}';
                     _beamTypes.add(BeamDefinition(id: newId, name: nameCtrl.text, width: width, depth: depth, color: Colors.primaries[_beamTypes.length % Colors.primaries.length]));
                     _activeBeamId = newId;
                   }
                 });
                 Navigator.pop(ctx);
               }, 
               child: const Text('Guardar')
             ),
           ],
         );
       }
     );
  }

  Widget _buildInput(TextEditingController c, String label) {
    return TextFormField(
      controller: c, keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label, filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? 'Requerido' : null,
    );
  }
  
  Widget _buildMiniInput(String label, String initVal, Function(String) onChanged) {
    return TextFormField(
      initialValue: initVal,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label, isDense: true, filled: true, fillColor: Colors.grey[50], 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}
