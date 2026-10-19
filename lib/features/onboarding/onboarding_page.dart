import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../core/input_formatters.dart';
import '../../data/database.dart';

/// مشخصات بازرس در اولین اجرا
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.db, required this.onDone});
  final AppDatabase db;
  final VoidCallback onDone;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _phone = TextEditingController();

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await widget.db.saveInspector(InspectorsCompanion(
      id: Value(newId()),
      fullName: Value(_name.text.trim()),
      personnelCode: Value(_code.text.trim()),
      phone: Value(_phone.text.trim()),
    ));
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشخصات بازرس')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(children: [
            const Text('این اطلاعات در همه‌ی چک‌لیست‌های پرشده درج می‌شود.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration:
                  const InputDecoration(labelText: 'نام و نام خانوادگی'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'الزامی است' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _code,
              keyboardType: TextInputType.number,
              inputFormatters: [EnglishDigitsFormatter()],
              decoration: const InputDecoration(labelText: 'کد پرسنلی'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [EnglishDigitsFormatter()],
              decoration: const InputDecoration(labelText: 'شماره تماس'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('ذخیره و ادامه')),
          ]),
        ),
      ),
    );
  }
}
