import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tienda Hormixa', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Hormigón'),
              Tab(text: 'Áridos'),
              Tab(text: 'Premoldeados'),
            ],
            indicatorColor: AppTheme.primaryCyan,
            labelColor: AppTheme.primaryCyan,
            unselectedLabelColor: AppTheme.cementGray,
            labelStyle: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _ProductList(category: 'concrete'),
            _ProductList(category: 'aggregates'),
            _ProductList(category: 'precast'),
          ],
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final String category;
  const _ProductList({required this.category});

  @override
  Widget build(BuildContext context) {
    final products = _getMockProducts(category);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final p = products[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Icon(Icons.image_outlined, size: 48, color: Colors.grey[400]),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(p['desc'], style: const TextStyle(color: AppTheme.cementGray, fontSize: 13)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${p['price']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.industrialOrange)),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text('AGREGAR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getMockProducts(String cat) {
    if (cat == 'concrete') {
      return [
        {'name': 'Hormigón H21', 'desc': 'Ideal para losas y vigas residenciales.', 'price': '120.000 /m3'},
        {'name': 'Hormigón H30', 'desc': 'Alta resistencia para estructuras grandes.', 'price': '145.000 /m3'},
        {'name': 'Relleno Fluido', 'desc': 'Para contrapisos y zanjas.', 'price': '90.000 /m3'},
      ];
    } else if (cat == 'aggregates') {
       return [
        {'name': 'Arena Fina', 'desc': 'Bolsón de 1m3 certficado.', 'price': '45.000'},
        {'name': 'Piedra Partida', 'desc': 'Granulometría 6-20mm.', 'price': '55.000'},
      ];
    } else {
       return [
        {'name': 'Bloque de Hormigón', 'desc': '20x20x40. Pallet x 100u.', 'price': '150.000'},
        {'name': 'Vigueta Pretensada', 'desc': 'Largo 4.5m.', 'price': '12.000 c/u'},
      ];
    }
  }
}
