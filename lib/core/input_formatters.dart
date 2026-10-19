import 'package:flutter/services.dart';
import 'persian_utils.dart';

/// ورودی فارسی/عربی را هنگام تایپ به انگلیسی تبدیل می‌کند.
class EnglishDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: Fa.toEnglishDigits(newValue.text));
  }
}
