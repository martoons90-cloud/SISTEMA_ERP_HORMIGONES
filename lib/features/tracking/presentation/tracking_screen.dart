import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Seguimiento', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Map Placeholder
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFFE5E7EB), // Gray-200
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('Mapa en Tiempo Real', style: TextStyle(color: Colors.grey[600], fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: AppTheme.primaryCyan,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Timeline
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40, height: 4, 
                    margin: const EdgeInsets.only(bottom: 24, left: 150, right: 150), // Center handle
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pedido #2045', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Hormigón H21 - 8m³', style: TextStyle(color: AppTheme.cementGray)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.industrialOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('45 min', style: TextStyle(color: AppTheme.industrialOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _TimelineItem(
                    title: 'Pedido Confirmado',
                    time: '08:30 AM',
                    isActive: true,
                    isFirst: true,
                    color: AppTheme.primaryCyan,
                  ),
                  _TimelineItem(
                    title: 'Carga en Planta',
                    time: '09:15 AM',
                    isActive: true,
                    color: AppTheme.primaryCyan,
                  ),
                  _TimelineItem(
                    title: 'En Camino (Camión #42)',
                    time: '09:45 AM',
                    isActive: true,
                    isCurrent: true,
                    color: AppTheme.industrialOrange,
                  ),
                  const _TimelineItem(
                    title: 'Llegada a Obra',
                    time: 'Est. 10:30 AM',
                    isActive: false,
                    isLast: true,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isActive;
  final bool isCurrent;
  final bool isFirst;
  final bool isLast;
  final Color color;

  const _TimelineItem({
    required this.title,
    required this.time,
    required this.color,
    this.isActive = false,
    this.isCurrent = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst) Expanded(child: Container(width: 2, color: isActive ? color : Colors.grey[200])),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive ? color : Colors.grey[200],
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: Colors.white, width: 2, strokeAlign: BorderSide.strokeAlignOutside) : null,
                    boxShadow: isCurrent ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 0, spreadRadius: 4)] : null,
                  ),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: isActive && !isCurrent ? color : Colors.grey[200])), // Logic simplified
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.black87 : Colors.grey,
                  fontSize: 15,
                )),
                Text(time, style: const TextStyle(color: AppTheme.cementGray, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
