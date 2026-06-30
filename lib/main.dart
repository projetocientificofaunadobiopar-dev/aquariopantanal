import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/avaliacao_provider.dart';
import 'providers/conexao_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/text_scale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/visitas_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase não inicializado (modo demo): $e');
  }
  runApp(const BioparqueApp());
}

class BioparqueApp extends StatelessWidget {
  const BioparqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TextScaleProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..carregar()),
        ChangeNotifierProvider(create: (_) => VisitasProvider()..carregar()),
        ChangeNotifierProvider(create: (_) => AvaliacaoProvider()..carregar()),
        ChangeNotifierProvider(create: (_) => ConexaoProvider()),
      ],
      child: Builder(
        builder: (ctx) {
          final router = buildRouter(
            ctx.read<AuthProvider>(),
            ctx.read<OnboardingProvider>(),
          );
          final mode = ctx.watch<ThemeProvider>().mode;
          final scale = ctx.watch<TextScaleProvider>().scale;
          return MaterialApp.router(
            title: 'Bioparque Pantanal',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: mode,
            routerConfig: router,
            builder: (ctx, child) {
              return MediaQuery(
                data: MediaQuery.of(ctx)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: _OfflineBanner(child: child!),
              );
            },
          );
        },
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final Widget child;
  const _OfflineBanner({required this.child});

  @override
  Widget build(BuildContext context) {
    final offline = context.watch<ConexaoProvider>().offline;
    return Stack(
      children: [
        child,
        if (offline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.orange.shade800,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wifi_off_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Sem conexão — você está vendo conteúdo em cache',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
