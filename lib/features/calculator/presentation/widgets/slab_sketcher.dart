import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum SketcherMode { slab, beam }

// --- Models ---
class BeamDefinition {
  final String id;
  final String name;
  final Color color;
  final double width;
  final double depth;

  const BeamDefinition({
    required this.id,
    required this.name,
    required this.color,
    required this.width,
    required this.depth,
  });
}

class BeamSegment {
  final Offset start; // Meters
  final Offset end;   // Meters
  final String typeId;

  const BeamSegment(this.start, this.end, this.typeId);
}

class SketchStateSnapshot {
  final List<Offset> slabPoints;
  final List<BeamSegment> beams;
  SketchStateSnapshot(this.slabPoints, this.beams);
}
// --------------

class SlabSketcher extends StatefulWidget {
  final SketcherMode mode;
  final double snapRes; 
  final double zoomLevel; // Added back
  final List<BeamDefinition> beamDefinitions;
  final String activeBeamId;
  
  final Function(double area) onSlabAreaChanged;
  final Function(List<BeamSegment> segments) onBeamsChanged;
  final SlabSketcherController? controller;

  const SlabSketcher({
    super.key,
    required this.mode,
    required this.snapRes,
    required this.zoomLevel,
    required this.beamDefinitions,
    required this.activeBeamId,
    required this.onSlabAreaChanged,
    required this.onBeamsChanged,
    this.controller,
  });

  @override
  State<SlabSketcher> createState() => _SlabSketcherState();
}

class SlabSketcherController {
  late void Function() undo;
  late void Function() clear;
}

class _SlabSketcherState extends State<SlabSketcher> {
  List<Offset> slabPoints = [];
  List<BeamSegment> beams = [];
  List<SketchStateSnapshot> history = [];

  Offset _panOffset = const Offset(0, 0); 
  final double _basePixelsPerMeter = 40.0;
  
  Offset? _currentDragStart; 
  Offset? _currentDragEnd;   
  bool _isPanning = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.undo = undo;
      widget.controller!.clear = clear;
    }
  }

  void _saveSnapshot() {
    if (history.length > 20) history.removeAt(0); 
    history.add(SketchStateSnapshot(List.from(slabPoints), List.from(beams)));
  }

  void undo() {
    if (history.isEmpty) return;
    final last = history.removeLast();
    setState(() {
      slabPoints = List.from(last.slabPoints);
      beams = List.from(last.beams);
    });
    _recalc();
  }

  void clear() {
    _saveSnapshot();
    setState(() {
      slabPoints.clear();
      beams.clear();
      _panOffset = Offset.zero;
    });
    _recalc();
  }
  
  void _recalc() {
    _calculateSlabArea();
    widget.onBeamsChanged(beams); 
  }

  double get _pixelsPerMeter => _basePixelsPerMeter * widget.zoomLevel;
  
  Offset _toScreen(Offset meters) {
    return (meters * _pixelsPerMeter) + _panOffset;
  }
  
  Offset _toWorld(Offset screen) {
    return (screen - _panOffset) / _pixelsPerMeter;
  }
  
  Offset _snap(Offset world) {
    double res = widget.snapRes;
    double x = (world.dx / res).round() * res;
    double y = (world.dy / res).round() * res;
    return Offset(x, y);
  }

  bool _isSegmentDuplicate(Offset p1, Offset p2) {
    const e = 0.001; 
    for (var b in beams) {
      if (((b.start - p1).distance < e && (b.end - p2).distance < e) ||
          ((b.start - p2).distance < e && (b.end - p1).distance < e)) {
        return true;
      }
    }
    return false;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 2) {
      setState(() => _isPanning = true);
    } else {
      setState(() {
        _isPanning = false;
        final worldPos = _toWorld(details.localFocalPoint);
        final snapped = _snap(worldPos);
        _currentDragStart = snapped;
        _currentDragEnd = snapped;
      });
      
      if (widget.mode == SketcherMode.slab && slabPoints.isEmpty) {
         _saveSnapshot();
         setState(() => slabPoints.add(_currentDragStart!));
      }
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 2) {
      setState(() {
        _panOffset += details.focalPointDelta;
      });
    } else if (!_isPanning && _currentDragStart != null) {
      final worldPos = _toWorld(details.localFocalPoint);
      setState(() {
        _currentDragEnd = _snap(worldPos);
      });
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (!_isPanning && _currentDragStart != null && _currentDragEnd != null) {
      if (widget.mode == SketcherMode.slab) {
         if (slabPoints.isNotEmpty && (_currentDragEnd! - slabPoints.last).distance > 0.001) {
            _saveSnapshot();
            setState(() {
              slabPoints.add(_currentDragEnd!);
            });
            _calculateSlabArea();
         }
      } else {
        if ((_currentDragStart! - _currentDragEnd!).distance > 0.001) {
           if (!_isSegmentDuplicate(_currentDragStart!, _currentDragEnd!)) {
             _saveSnapshot();
             setState(() {
               beams.add(BeamSegment(_currentDragStart!, _currentDragEnd!, widget.activeBeamId));
             });
             widget.onBeamsChanged(beams);
           } else {
             ScaffoldMessenger.of(context).clearSnackBars();
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viga duplicada'), duration: Duration(milliseconds: 500)));
           }
        }
      }
    }
    setState(() {
      _currentDragStart = null;
      _currentDragEnd = null;
      _isPanning = false;
    });
  }
  
  void _calculateSlabArea() {
    if (slabPoints.length < 3) {
      widget.onSlabAreaChanged(0);
      return;
    }
    double area = 0;
    int n = slabPoints.length;
    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;
      area += slabPoints[i].dx * slabPoints[j].dy;
      area -= slabPoints[j].dx * slabPoints[i].dy;
    }
    widget.onSlabAreaChanged(area.abs() / 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        onTapUp: (details) {
           final worldPos = _toWorld(details.localPosition);
           final snapped = _snap(worldPos);
           if (widget.mode == SketcherMode.slab) {
              if (slabPoints.isEmpty || (snapped - slabPoints.last).distance > 0.001) {
                 _saveSnapshot();
                 setState(() => slabPoints.add(snapped));
                 _calculateSlabArea();
              }
           }
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: SketchPainter(
            panOffset: _panOffset,
            pixelsPerMeter: _pixelsPerMeter,
            slabPoints: slabPoints,
            beams: beams,
            beamDefinitions: widget.beamDefinitions,
            currentStart: _currentDragStart,
            currentEnd: _currentDragEnd,
            mode: widget.mode,
            activeBeamColor: widget.beamDefinitions.firstWhere((e) => e.id == widget.activeBeamId, orElse: () => widget.beamDefinitions.first).color,
            snapRes: widget.snapRes,
          ),
        ),
      ),
    );
  }
}

class SketchPainter extends CustomPainter {
  final Offset panOffset;
  final double pixelsPerMeter;
  final List<Offset> slabPoints;
  final List<BeamSegment> beams;
  final List<BeamDefinition> beamDefinitions;
  final Offset? currentStart;
  final Offset? currentEnd;
  final SketcherMode mode;
  final Color activeBeamColor;
  final double snapRes;

  SketchPainter({
    required this.panOffset,
    required this.pixelsPerMeter,
    required this.slabPoints,
    required this.beams,
    required this.beamDefinitions,
    required this.currentStart,
    required this.currentEnd,
    required this.mode,
    required this.activeBeamColor,
    required this.snapRes,
  });

  Offset _toPx(Offset m) => (m * pixelsPerMeter) + panOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    final tl = (Offset.zero - panOffset) / pixelsPerMeter;
    final br = (Offset(size.width, size.height) - panOffset) / pixelsPerMeter;
    
    // Grid
    paint.color = AppTheme.cementGray.withOpacity(0.4);
    _drawGridLayer(canvas, tl, br, 1.0, 2.0, paint);
    
    if (snapRes <= 0.5) {
       paint.color = AppTheme.cementGray.withOpacity(0.25);
       _drawGridLayer(canvas, tl, br, 0.5, 1.5, paint, skipMod: 1.0);
    }
    
    if (snapRes <= 0.25) {
       paint.color = AppTheme.cementGray.withOpacity(0.15);
       _drawGridLayer(canvas, tl, br, 0.25, 1.0, paint, skipMod: 0.5);
    }
    
    // Slab
    if (slabPoints.isNotEmpty) {
      final path = Path()..moveTo(_toPx(slabPoints.first).dx, _toPx(slabPoints.first).dy);
      for (int i = 1; i < slabPoints.length; i++) {
        path.lineTo(_toPx(slabPoints[i]).dx, _toPx(slabPoints[i]).dy);
      }
      
      if (mode == SketcherMode.slab && currentStart != null && currentEnd != null) {
         path.lineTo(_toPx(currentEnd!).dx, _toPx(currentEnd!).dy);
      } else if (slabPoints.length > 2) {
         path.close();
      }

      paint.style = PaintingStyle.fill;
      paint.color = AppTheme.primaryCyan.withOpacity(0.15);
      canvas.drawPath(path, paint);

      paint.style = PaintingStyle.stroke;
      paint.color = AppTheme.primaryCyan;
      paint.strokeWidth = 3;
      paint.strokeCap = StrokeCap.round;
      paint.strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, paint);
      
      paint.style = PaintingStyle.fill;
      for (var p in slabPoints) {
        canvas.drawCircle(_toPx(p), 4, paint);
      }
    }

    // Beams
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square; 

    for (var beam in beams) {
      final def = beamDefinitions.firstWhere((e) => e.id == beam.typeId, orElse: () => beamDefinitions.first);
      paint.color = def.color;
      paint.strokeWidth = 5; 
      canvas.drawLine(_toPx(beam.start), _toPx(beam.end), paint);
    }
    
    if (mode == SketcherMode.beam && currentStart != null && currentEnd != null) {
      paint.color = activeBeamColor.withOpacity(0.5);
      paint.strokeWidth = 5;
      canvas.drawLine(_toPx(currentStart!), _toPx(currentEnd!), paint);
    }
  }
  
  void _drawGridLayer(Canvas canvas, Offset tl, Offset br, double step, double radius, Paint paint, {double? skipMod}) {
     double startX = (tl.dx / step).floor() * step;
     double startY = (tl.dy / step).floor() * step;
     
     for (double x = startX; x <= br.dx; x += step) {
       for (double y = startY; y <= br.dy; y += step) {
         if (skipMod != null) {
            if ((x.abs() % skipMod) < 0.001 && (y.abs() % skipMod) < 0.001) continue;
         }
         canvas.drawCircle(_toPx(Offset(x, y)), radius, paint);
       }
     }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) => true;
}
