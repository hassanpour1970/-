import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'data/database.dart';
import 'features/home/home_page.dart';
import 'features/onboarding/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: DealerAuditApp()));
}

class DealerAuditApp extends StatelessWidget {
  const DealerAuditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ارزیابی نمایندگی‌ها',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const _Root(),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  final db = AppDatabase();
  late Future<bool> _hasInspector = _check();

  Future<bool> _check() async => (await db.getInspector()) != null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasInspector,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data!) return HomePage(db: db);
        return OnboardingPage(
          db: db,
          onDone: () => setState(() => _hasInspector = _check()),
        );
      },
    );
  }
}
