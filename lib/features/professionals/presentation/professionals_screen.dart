import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data from the HTML template
    final pros = [
      {
        'name': 'Ricardo Sánchez',
        'verified': true,
        'rating': 4.9,
        'reviews': 142,
        'location': 'Zona Norte • Madrid',
        'desc': 'Especialista en estructuras de hormigón armado y mampostería técnica. 15 años liderando proyectos residenciales de alta gama.',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBKooVymQ21IKBvdEWCRMwTKNU-02KiCZyvL6khn4OPq1qBcBaztJOjt-WghIzyyqKk3kTGjDMbAOR__FMpvMn4fXTT7L0NMlMjDY03dRpZnzUwvp-VNElqdHE_cHs4showMam9rRgy8K91OJ_0FDQh_xXENHVhk-B3l1xf4Kaoo3jzpCkSNugMINdXmGUbvyu-WS9cvXb0VbhgnH-EFSlvtufQ0SSTfCNSXcr9tRmec37UX0BLev-V4-QnOgLtADnquPumJGDlxQ',
        'gallery': [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC8GzxW2jo-hyLE0ztoC7h9aPuyrjAgJlIS7_wfNGFqf0dl1cPxMQsTwuosSc5VJ34fWPm16Q0IN9es6v_edaHuv4tHvrwi16_AmzqXrjdQbxSvWCXzwnNfX2l1p06-2CS9h9x38xAJjgepFAv5xmfConcUhzmiMiQjuezgTh3ooh7TMEAGd2RM-hiECpftmjkbxFadG5_1nfWMDjXzX7h5iTwXH11aCbfsJxWrmjfikx_5KgWi4AMQkKu_dVXJ2uxAgBQ9rYfhAg',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBHXkQGkZ1Tr5mLijLdO_W1x78xhJM2yRW56SgbBmrTUU1QulIuLmVzg-17FzN0tCxpFOXcQLDmEAQ1_03MBgAlfzYNeMFpO4rGSurnXqkscc8YWbp_RoN69Q1HGm7PZs3hQHKIoR-ilDLxosWNumIR1cjcSoh9DEGbY_u5PHq5OYh-QBh924fYXVMtDMyKjxaVqL5X0KeI9mgx-nSXd5mx19YWlq5By7Ug8sjmCosoFPYiTwo6ZQ6HWkzZc19Zp4DZHDTVTXOcXw',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAthfsWp7oKIhaCIUy1NNx73A_rzVnyKo0ptNs-D5Umu2kPTv6Fm4bTMesi1yb77qoa-jvLc17-dQGe-BdNYoeVzqN5EE58h2KKCKQulsXi1JyEBvk7f-hnA52swJ1nDfG-yE7O5kRgNqZsFcnbeEcekAAB1c1NS1QlXOA94oVqSBzHwhkAhMZMGKm8k06O3RBJqINXGeRUqLLX6gcr3HNhI0J40Zct_uhh8oeewIJ35U6LNRd_myevmdOh1itgcHwJsy623uBmpg',
        ]
      },
      {
        'name': 'Elena Martínez',
        'verified': true,
        'rating': 4.8,
        'reviews': 89,
        'location': 'Centro • Madrid',
        'desc': 'Experta en rehabilitación de fachadas y trabajos de microcemento decorativo. Enfoque en acabados minimalistas y sostenibles.',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCCgzbHwaJZ8B5njLzNQC7oMdCydWzYG9qWjWetDQ30NCZQhTXm3crwXZVW_ro7ZIqNJvfH-S1iHW5VQDOOacOShrbkzSmw569lx-XFVP8utCcXVTZvkA5Spbchmt7T6Ve_MgW1uQVDR-QMcaCJDhkBtQtYep18_bSIitX0kUiTNETPy33oOOorf9PPsIAqb_uYqLH_7zu0PgZWJSBbfPXy5t0bSRO3nmdPjulccWKpzOoHrAahjqQeTtje5jmSul4afifwdk6Odw',
        'gallery': [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDPwexxwYzU-Ym23BB4EzUhWs82T8S0Gsqs0AXlhCvfzRl8RbQ-ARiu3j4GbiVH9Awvz_TNVDB84f7SLRBoV8-4ODSeh3iYccXkC9FSd4ezsrDEmdZp9TtWknVcXLp7cfHf5NDLn1euLj0-pTSqSm9ZI29pYHo81wAb9UJH1r3n3BC67haHNZiujNN_RoLajewHS3kCqfikDmsPA1W5yFFR7tj8Pjn6p3Lg2Lf4zF-MtdURt5ZiLuygioowEOUomY4VBu3EGgp9bg',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDvQUUJPL9pTtkU7UIFqc3BTw9fboV23zwYAbYhFTAdnlXYrmDKkV7uE8P7KKuqHeF4bJZiwMpkxGyBGAqVXo7MUc-AGP6NIqUkVZgUdCTHsOl3Epycer096uUBy-DCLoVGE1xlfjr_R0nnlTryUyX5DCgctXP1aeK6YdPpUc0NzPSdA3GCFfg_G4km5fYe-pXQPDhoNbcn6_90T2BeIgy8-iEyX0R_Yt6w2YnJoMB_uQnvP5sMsCCe33eR2eqPMab8jBl175VPgQ',
        ]
      },
      {
        'name': 'Javier López',
        'verified': false,
        'rating': 4.5,
        'reviews': 42,
        'location': 'Sur • Getafe',
        'desc': 'Maestro albañil especializado en reformas integrales de baños y cocinas. Rapidez y limpieza garantizada en cada obra.',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuADTrn1yL30nlsuHjD378NwGg-gEgciYrps9ytnG3Zlz_ARf_X53D35SzTSGEJPH93dFrD1lpPap58LICtcSxlr7KNWOtEzl3BKsCM-GRkSRTskox6a20AFLQQRXCD7NTq9RilAx02qVoduPxntEDbgEMgHvZq9Ji_1pmDo8PjFE7d_7OrUcRq35j5Dr2FfbuAAk75xPdauVg5SRO8LIu9P8pKB4egJylHul3PNvtGaVotc2EGw1YRpiEUsCnf-QFAm5KRonh4y0Q',
        'gallery': <String>[] // Empty gallery based on HTML
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // background-light
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFFF9FAFB).withOpacity(0.9), // sticky + blur imitation
            elevation: 0.5,
            toolbarHeight: 70,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.architecture, color: AppTheme.primaryCyan),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Directorio de Albañiles',
                        style: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent, border: Border.all(color: Colors.transparent)), // Hover effect difficult on mobile, keeping clean
                        child: const Icon(Icons.notifications_outlined, color: Colors.grey),
                      ),
                      Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white, width: 1.5)))),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Search & Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar por especialidad o nombre...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filters Horizontal Scroll
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('Filtros', Icons.tune, isActive: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Especialidad', Icons.expand_more, isDropdown: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Zona', Icons.expand_more, isDropdown: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Verificados', null),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Professionals List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pro = pros[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                  child: _buildProfessionalCard(pro),
                );
              },
              childCount: pros.length,
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData? icon, {bool isActive = false, bool isDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryCyan : Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: isActive ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !isDropdown) ...[
            Icon(icon, size: 18, color: isActive ? Colors.white : Colors.grey[700]),
            const SizedBox(width: 6),
          ],
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.grey[700], fontWeight: FontWeight.w500, fontSize: 13)),
          if (icon != null && isDropdown) ...[
             const SizedBox(width: 6),
             Icon(icon, size: 18, color: isActive ? Colors.white : Colors.black54),
          ],
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> pro) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: NetworkImage(pro['avatar'] as String), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(pro['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (pro['verified'] as bool) ...[
                             const SizedBox(width: 6),
                             const Icon(Icons.verified, color: AppTheme.primaryCyan, size: 20),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppTheme.primaryCyan, size: 16), // Design uses primary cyan for star
                          const SizedBox(width: 2),
                          Text('${pro['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryCyan)),
                          const SizedBox(width: 4),
                          Text('(${pro['reviews']} reseñas)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 14),
                          const SizedBox(width: 2),
                          Text(pro['location'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Text(pro['desc'] as String, style: const TextStyle(color: Colors.blueGrey, fontSize: 14, height: 1.5)),
            
            // Gallery
            if ((pro['gallery'] as List).isNotEmpty) ...[
               const SizedBox(height: 16),
               Row(
                 children: [
                    ...((pro['gallery'] as List).take(2).map((url) => Expanded(
                       child: Padding(
                         padding: const EdgeInsets.only(right: 8),
                         child: Container(
                           height: 80,
                           decoration: BoxDecoration( borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
                         ),
                       )
                    ))),
                    if ((pro['gallery'] as List).length > 2)
                     Expanded(
                       child: Container(
                         height: 80,
                         decoration: BoxDecoration( borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage((pro['gallery'] as List)[2]), fit: BoxFit.cover)),
                         child: Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: const Text('+12', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                         ),
                       ),
                     ),
                 ],
               )
            ],

            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCyan,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Ver Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCyan.withOpacity(0.1),
                      foregroundColor: AppTheme.primaryCyan,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Contactar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
