import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/especie.dart';
import '../providers/auth_provider.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/especie_form.dart';
import '../screens/ficha_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/sobre_screen.dart';

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (ctx, state) {
      final logged = auth.isLogged;
      final path = state.uri.path;
      final inAdmin = path.startsWith('/admin');
      if (inAdmin && !logged) return '/login';
      if (path == '/login' && logged) return '/admin';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/especie/:slug',
        builder: (ctx, st) => FichaScreen(
          slugOrId: st.pathParameters['slug']!,
          inicial: st.extra is Especie ? st.extra as Especie : null,
        ),
      ),
      // Compatibilidade: rota antiga /ficha/:id continua funcionando
      GoRoute(
        path: '/ficha/:id',
        builder: (ctx, st) => FichaScreen(
          slugOrId: st.pathParameters['id']!,
          inicial: st.extra is Especie ? st.extra as Especie : null,
        ),
      ),
      GoRoute(
        path: '/sobre',
        builder: (_, __) => const SobreScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminDashboard(),
        routes: [
          GoRoute(
            path: 'form',
            builder: (ctx, st) => EspecieForm(
              editar: st.extra is Especie ? st.extra as Especie : null,
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (_, st) => Scaffold(
      body: Center(child: Text('404: ${st.uri.path}')),
    ),
  );
}
