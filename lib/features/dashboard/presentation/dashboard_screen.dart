import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC1lJydWvn5ZvOMbJuPJr-IMmVapD8ImJroQE2T53LdHmzcpX4MOSEVOBJNJhdi2K0meoJBMLi4qK-Ft61bXb9qV431RaEhT9mxvbmNWzFXf9XtChL3aBB9nAJPWVTjW__AhG2lmh-f50gZjrZCLf_RyAdwYO2j86fa_-nPTrje2Iz-ZpxsFIFqIb1imGABdXe97I01yeXdFTjgv35RYhHCUyL8n7Hd1DVo9x1IrdEo2BAwDfA4MXCyENMuM9c1cDO00TWAn2w14g'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Buenos días', style: TextStyle(color: AppTheme.cementGray, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                          Text('¡Hola, Juan!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.1)),
                        ],
                      ),
                    ),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      child: Stack(
                        children: [
                          const Center(child: Icon(Icons.notifications_outlined, color: AppTheme.primaryCyan)),
                          Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.industrialOrange, shape: BoxShape.circle))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Active Order Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(left: BorderSide(color: AppTheme.industrialOrange, width: 4)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppTheme.industrialOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('EN CAMINO', style: TextStyle(color: AppTheme.industrialOrange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                          const Text('ETA: 11:45 AM', style: TextStyle(color: AppTheme.cementGray, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pedido #4521: Hormigón H21', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                const SizedBox(height: 4),
                                const Text('El camión mezclador llegará en 15 min a la Obra Olivos.', style: TextStyle(color: AppTheme.cementGray, fontSize: 14)),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () => context.push('/tracking'),
                                  icon: const Icon(LucideIcons.truck, size: 16),
                                  label: const Text('Ver Seguimiento'),
                                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAFMLm9dxtR_1q3XOu3M1lW1OsHGU7CgcXkw_6_Nuhr7TldhJ0WhvEiAMawi5fFANdWf9pDtp_lqhhMvWIwOvVIQi2jsqYwMtPh7HoSp4DErXFKJyTn8_iCW-GpGG9bopmVmkJaNEavHZGi3OGYJ6wFywEdArQwMH3cfXEpe5JjVkPdozwtwvF2cRNonzTJy0JuGb1sAx-9fEzh57MRS0S-N6K7GcCe6hJUeYfYC6ZrzJvpln2lY7yqfGJNKpZqTbF0venH9U7Lqg'), fit: BoxFit.cover),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Section Header
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Servicios Centrales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('VER TODO', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Bento Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Large Tile - Buy Concrete
                    GestureDetector(
                      onTap: () => context.push('/store'),
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAXA9d6eRsVPPdgxTAXSvHLPCYxMTtjU1D7mBWnZhwVVebwRLGcQbvoZR-Q8ABch84T4XWK9PZ8E5NqkdprM1gKmdtpWLTwoQDvYXi3icvyhGOpqFuXU6bYkjvXsVVBfnD3EVLwJ45Zw-Dwlk-XUH4xBORcphRxzz0wBz5-a-McVP_DJVNS_Oe2ytvXPHJzwQBt4Y99pS4AXGDgHKTALFhU466nJ4mznHgHRbygL5sRgPXh1L8hSCBfbjtv-u-_Mo4A0fKOYdtpAQ'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                          ),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                              bottom: 16, left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Comprar Hormigón', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('Cotización inmediata y logística', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 16, right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: AppTheme.primaryCyan, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Small Tiles Row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/calculator'),
                            child: Container(
                              height: 160,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: AppTheme.primaryCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.calculate, color: AppTheme.primaryCyan),
                                  ),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Calculadora de Obra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2)),
                                      SizedBox(height: 4),
                                      Text('Cálculo de m³ y materiales', style: TextStyle(color: AppTheme.cementGray, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/professionals'),
                            child: Container(
                              height: 160,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF3F4F6)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: AppTheme.industrialOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.engineering, color: AppTheme.industrialOrange),
                                  ),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Directorio de Albañiles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2)),
                                      SizedBox(height: 4),
                                      Text('Personal verificado cerca', style: TextStyle(color: AppTheme.cementGray, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Club Tile
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.workspace_premium, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Club de Beneficios', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text('Tienes 2.450 puntos acumulados', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Offers Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text('Ofertas de Socios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // Offers List
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildOfferCard(
                      'Maderera Central', 'https://lh3.googleusercontent.com/aida-public/AB6AXuCVzc8se9xxvmO5HW-xjk8reEFxg-7GcLQc2tP-_8UO0JapTu7SlEI9SOr88MCT-OKUIOzmSmiYk56068kugQ19VgTqnHaqDda2bBc4t7DUTT4EUaej4zebuCvQraFRNIemshMqRJiTlSyI4J-vfqTslxiw9RtrELo0oI9z4-4ZO-mwzhSsTpeX0aE_xvJKANk2Y_aR_U_stgprutK8qWCi9xnJM4ulXIwQTuze6-7cacrRW8N5AL_aO13QnpYQ60da_3387B1ycQ',
                      '20% OFF en Vigas', '4.8',
                    ),
                    const SizedBox(width: 16),
                    _buildOfferCard(
                      'Ferretería Pro', 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_sgy99MxgMSlgKKX75E9lDq6iecivNEaLdFwhRnGY3-n_j1ARsVwVZHKcfQwYUAO8uTrvIfNd1FIRJGCqGYAZ5qX0Jq2PhlcDgw8kU-0XeHq-vfg8CAjl9W3X_Hg8JP0DBNxaKLaGhm-Hnw9Re0PnFDwAdJPzNOSXZMJa1P1OGcmSYWjlayMZ8TKtCpN7O2ZbIpPrAgpKSLNnXCCsPMHn0mWhLSIue0p_2vUQoN7jDfzlZFZl-fL8weQ8_iFxtJSVZwhyRb9yXw',
                      '3x2 en Discos', '4.9',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(String shop, String imgUrl, String title, String rating) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shop.toUpperCase(), style: const TextStyle(color: AppTheme.industrialOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppTheme.primaryCyan),
                        Text(rating, style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                const Text('Solo Miembros', style: TextStyle(color: AppTheme.cementGray, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
