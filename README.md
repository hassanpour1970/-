# dealer_audit — مرحله‌ی ۱

## راه‌اندازی
1. `flutter create --org ir.ikco --platforms android dealer_audit` در یک پوشه‌ی موقت،
   سپس پوشه‌ی `android/` ساخته‌شده را داخل همین پروژه کپی کنید
   (یا این فایل‌ها را روی پروژه‌ی ساخته‌شده کپی کنید).
2. فونت Vazirmatn را (Regular و Bold) در `assets/fonts/` بگذارید.
3. محتوای `android_notes/AndroidManifest-snippet.xml` را به Manifest اضافه کنید.
   `minSdk` را روی 23 بگذارید.
4. `flutter pub get`
5. `dart run build_runner build --delete-conflicting-outputs`  (تولید `database.g.dart`)
6. `flutter run`
