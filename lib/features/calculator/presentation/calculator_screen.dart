import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadoras', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalculatorTile(
            title: 'Encofrados (Madera)',
            subtitle: 'Tablas, tirantes y puntales',
            icon: LucideIcons.hammer,
            color: Colors.brown,
            onTap: () => context.push('/calculator/wood'),
          ),
          const SizedBox(height: 12),
          _CalculatorTile(
            title: 'Armaduras (Hierro)',
            subtitle: 'Despiece de barras y estribos',
            icon: LucideIcons.construction,
            color: AppTheme.cementGray,
            onTap: () => context.push('/calculator/iron'),
          ),
          const SizedBox(height: 12),
          _CalculatorTile(
            title: 'Hormigón',
            subtitle: 'Volumen y dosificación',
            icon: LucideIcons.droplet,
            color: AppTheme.industrialOrange,
            onTap: () => context.push('/calculator/concrete'),
          ),
        ],
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CalculatorTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppTheme.cementGray, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.cementGray),
          ],
        ),
      ),
    );
  }
}
