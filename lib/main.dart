import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Or Material Icons if lucide fails, but we added it.
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/calculator/presentation/calculator_screen.dart';
import 'features/store/presentation/store_screen.dart';
import 'features/tracking/presentation/tracking_screen.dart';
import 'features/professionals/presentation/professionals_screen.dart';
import 'features/calculator/presentation/wood_calculator_screen.dart';
import 'features/calculator/presentation/iron_calculator_screen.dart';
import 'features/calculator/presentation/concrete_calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Hormixa',
      theme: AppTheme.lightTheme, // Changed to Light
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/calculator',
          builder: (context, state) => const CalculatorScreen(),
          routes: [
            GoRoute(
              path: 'wood',
              builder: (context, state) => const WoodCalculatorScreen(),
            ),
            GoRoute(
              path: 'iron',
              builder: (context, state) => const IronCalculatorScreen(),
            ),
            GoRoute(
              path: 'concrete',
              builder: (context, state) => const ConcreteCalculatorScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/store',
          builder: (context, state) => const StoreScreen(),
        ),
        GoRoute(
          path: '/tracking',
          builder: (context, state) => const TrackingScreen(),
        ),
        GoRoute(
          path: '/professionals',
          builder: (context, state) => const ProfessionalsScreen(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    int getIndex() {
      if (location.startsWith('/calculator')) return 1;
      if (location.startsWith('/store')) return 2;
      if (location.startsWith('/tracking')) return 3;
      if (location.startsWith('/professionals')) return 4;
      return 0;
    }

    void onItemTapped(int index, BuildContext context) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/calculator');
          break;
        case 2:
          context.go('/store');
          break;
        case 3:
          context.go('/tracking');
          break;
        case 4:
          context.go('/professionals');
          break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: getIndex(),
        onDestinationSelected: (index) => onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Cálculos',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Envíos',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Pros',
          ),
        ],
      ),
    );
  }
}
