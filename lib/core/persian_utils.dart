import 'package:shamsi_date/shamsi_date.dart';

/// اعداد: ذخیره‌سازی همیشه انگلیسی، نمایش فارسی.
class Fa {
  static const _en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  static const _ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  /// برای نمایش در UI
  static String digits(Object? input) {
    var s = (input ?? '').toString();
    for (var i = 0; i < 10; i++) {
      s = s.replaceAll(_en[i], _fa[i]);
    }
    return s;
  }

  /// برای ذخیره‌سازی: هر نوع رقم فارسی/عربی را به انگلیسی تبدیل می‌کند
  static String toEnglishDigits(String input) {
    var s = input;
    for (var i = 0; i < 10; i++) {
      s = s.replaceAll(_fa[i], _en[i]).replaceAll(_ar[i], _en[i]);
    }
    return s.replaceAll('٫', '.').replaceAll('٬', ',');
  }

  /// DateTime (میلادی) -> متن شمسی مثل 1405/07/27 (ارقام انگلیسی؛ برای اکسل)
  static String jalaliText(DateTime d) {
    final j = Jalali.fromDateTime(d);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${j.year}/${two(j.month)}/${two(j.day)}';
  }

  /// برای نمایش در UI با ارقام فارسی
  static String jalaliDisplay(DateTime d) => digits(jalaliText(d));
}
