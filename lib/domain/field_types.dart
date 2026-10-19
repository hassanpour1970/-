/// انواع فیلد قابل استفاده در قالب چک‌لیست
enum FieldType {
  checkbox, // چک‌مارک
  text, // تکست باکس
  number, // فیلد عددی
  radio, // کلید رادیویی
  combo, // کمبو باکس
  date, // تاریخ شمسی
  location, // موقعیت مکانی (خودکار از GPS)
  image, // تصویر (دوربین/گالری)
  divider, // خط جداکننده (بدون مقدار)
}

extension FieldTypeX on FieldType {
  String get faLabel => switch (this) {
        FieldType.checkbox => 'چک‌مارک',
        FieldType.text => 'متن',
        FieldType.number => 'عدد',
        FieldType.radio => 'انتخاب تکی (رادیویی)',
        FieldType.combo => 'لیست کشویی',
        FieldType.date => 'تاریخ شمسی',
        FieldType.location => 'موقعیت مکانی',
        FieldType.image => 'تصویر',
        FieldType.divider => 'خط جداکننده',
      };

  /// آیا این نوع فیلد مقدار دارد (خط جداکننده ندارد)
  bool get hasValue => this != FieldType.divider;

  /// آیا گزینه‌ها (options) لازم دارد
  bool get hasOptions => this == FieldType.radio || this == FieldType.combo;

  static FieldType parse(String name) =>
      FieldType.values.firstWhere((e) => e.name == name);
}

enum FormStatus { draft, finalized }
