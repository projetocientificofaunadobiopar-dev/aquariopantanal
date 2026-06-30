import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/especie.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/especie_form.dart';
import '../screens/fauna_screen.dart';
import '../screens/ficha_screen.dart';
import '../screens/glossario_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/sobre_screen.dart';

CustomTransitionPage<T> _fade<T>(Widget child, GoRouterState st) {
  return CustomTransitionPage<T>(
    key: st.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (ctx, anim, sec, c) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.025),
        end: Offset.zero,
      ).animate(curved);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(position: slide, child: c),
      );
    },
  );
}

GoRouter buildRouter(AuthProvider auth, OnboardingProvider onb) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([auth, onb]),
    redirect: (ctx, state) {
      final logged = auth.isLogged;
      final path = state.uri.path;
      final inAdmin = path.startsWith('/admin');
      if (inAdmin && !logged) return '/login';
      if (path == '/login' && logged) return '/admin';

      // 1ª abertura → onboarding. Não força em /especie/:slug (visitante
      // que escaneou QR direto da placa do aquário entra direto na ficha).
      if (!onb.carregado) return null;
      final exceto = path.startsWith('/onboarding') ||
          path.startsWith('/especie/') ||
          path.startsWith('/ficha/') ||
          inAdmin ||
          path == '/login';
      if (!onb.done && !exceto) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (_, st) => _fade(const HomeScreen(), st),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, st) => _fade(const OnboardingScreen(), st),
      ),
      GoRoute(
        path: '/fauna',
        pageBuilder: (_, st) => _fade(const FaunaScreen(), st),
      ),
      GoRoute(
        path: '/especie/:slug',
        pageBuilder: (ctx, st) => _fade(
          FichaScreen(
            slugOrId: st.pathParameters['slug']!,
            inicial: st.extra is Especie ? st.extra as Especie : null,
          ),
          st,
        ),
      ),
      GoRoute(
        path: '/ficha/:id',
        pageBuilder: (ctx, st) => _fade(
          FichaScreen(
            slugOrId: st.pathParameters['id']!,
            inicial: st.extra is Especie ? st.extra as Especie : null,
          ),
          st,
        ),
      ),
      GoRoute(
        path: '/sobre',
        pageBuilder: (_, st) => _fade(const SobreScreen(), st),
      ),
      GoRoute(
        path: '/glossario',
        pageBuilder: (_, st) => _fade(const GlossarioScreen(), st),
      ),
      GoRoute(
        path: '/scan',
        pageBuilder: (_, st) => _fade(const ScanScreen(), st),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (_, st) => _fade(const LoginScreen(), st),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (_, st) => _fade(const AdminDashboard(), st),
        routes: [
          GoRoute(
            path: 'form',
            pageBuilder: (ctx, st) => _fade(
              EspecieForm(
                editar: st.extra is Especie ? st.extra as Especie : null,
              ),
              st,
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
