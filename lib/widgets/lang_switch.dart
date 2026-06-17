import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

class LangSwitch extends StatelessWidget {
  final Color? foregroundColor;
  const LangSwitch({super.key, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>().locale;
    final fg = foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    return PopupMenuButton<AppLocale>(
      tooltip: 'Idioma',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onSelected: (l) => context.read<LocaleProvider>().set(l),
      itemBuilder: (_) => AppLocale.values
          .map((l) => PopupMenuItem(
                value: l,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Text(
                      l.nativeName,
                      style: TextStyle(
                        fontWeight: l == loc
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    if (l == loc) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.check_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ],
                ),
              ))
          .toList(),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              loc.shortLabel,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.expand_more_rounded,
                color: fg, size: 18),
          ],
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  final Color? foregroundColor;
  const ThemeToggle({super.key, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeProvider>().mode;
    final isDark = mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final fg = foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    return IconButton(
      tooltip: isDark ? 'Modo claro' : 'Modo escuro',
      onPressed: () => context.read<ThemeProvider>().toggle(),
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: fg,
      ),
    );
  }
}
