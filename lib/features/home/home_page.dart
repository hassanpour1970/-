import 'package:flutter/material.dart';
import '../../core/persian_utils.dart';
import '../../data/database.dart';

/// صفحه‌ی اصلی موقت؛ در مراحل بعد به بخش‌های واقعی تبدیل می‌شود.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.db});
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    final today = Fa.jalaliDisplay(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('ارزیابی نمایندگی‌ها')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('امروز: $today'),
          const SizedBox(height: 16),
          const Text('مرحله‌ی ۱ آماده است'),
        ]),
      ),
    );
  }
}
