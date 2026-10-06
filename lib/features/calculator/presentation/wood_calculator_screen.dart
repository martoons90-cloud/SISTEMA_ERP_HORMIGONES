import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class WoodCalculatorScreen extends StatefulWidget {
  const WoodCalculatorScreen({super.key});

  @override
  State<WoodCalculatorScreen> createState() => _WoodCalculatorScreenState();
}

class _WoodCalculatorScreenState extends State<WoodCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Columna';
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  Map<String, double>? _results;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final width = double.parse(_widthController.text);
      final depth = double.parse(_depthController.text);
      final length = double.parse(_heightController.text);

      // Re-implementing logic here for simplicity in overwrite
      double surfaceArea = (_type == 'Columna') ? (2 * width + 2 * depth) * length : (width + 2 * depth) * length;
      double linearMeters1x6 = surfaceArea / 0.15;
      double ribs = (length / 0.60).ceilToDouble();
      double ribLength = (_type == 'Columna') ? (2*width + 2*depth) : (width + 2*depth + 0.5);
      double linearMeters2x2 = ribs * ribLength;
      double puntales = (_type == 'Viga') ? (length / 1.0).ceilToDouble() : 4;

      setState(() {
        _results = {
          'm2_superficie': surfaceArea,
          'ml_tablas_1x6': linearMeters1x6,
          'ml_tirantes_2x2': linearMeters2x2,
          'puntales_unit': puntales,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Encofrados (Madera)', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    items: ['Columna', 'Viga'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => _type = v!),
                    decoration: const InputDecoration(labelText: 'Tipo de Estructura', border: InputBorder.none, contentPadding: EdgeInsets.zero),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInput(_widthController, 'Ancho (m)')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInput(_depthController, 'Profundidad (m)')),
                ],
              ),
              const SizedBox(height: 16),
              _buildInput(_heightController, _type == 'Columna' ? 'Altura (m)' : 'Largo (m)'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('CALCULAR MATERIALES'),
              ),
              const SizedBox(height: 32),
              if (_results != null) ...[
                // Results Card style matching "Active Order"
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(left: BorderSide(color: AppTheme.industrialOrange, width: 4)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resultados Estimados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 16),
                      _ResultRow(label: 'Superficie de Contacto', value: '${_results!['m2_superficie']!.toStringAsFixed(2)} m²'),
                      const Divider(height: 24, color: Color(0xFFF3F4F6)),
                      _ResultRow(label: 'Tablas 1"x6" (Lineales)', value: '${_results!['ml_tablas_1x6']!.ceil()} ml'),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Aprox. ${(_results!['ml_tablas_1x6']! / 3.05).toStringAsFixed(1)} tablas de 3.05m', style: const TextStyle(color: AppTheme.cementGray, fontSize: 12)),
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(label: 'Tirantes 2"x2" (Lineales)', value: '${_results!['ml_tirantes_2x2']!.ceil()} ml'),
                      const SizedBox(height: 12),
                      _ResultRow(label: 'Puntales', value: '${_results!['puntales_unit']!.toInt()} u.'),
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryCyan, width: 2)),
      ),
      validator: (v) => v!.isEmpty ? 'Requerido' : null,
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.industrialOrange)),
      ],
    );
  }
}
