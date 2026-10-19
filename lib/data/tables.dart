import 'package:drift/drift.dart';

/// قالب فرم: هویت قالب و اشاره به آخرین نسخه
class FormTemplates extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get name => text()();
  IntColumn get currentVersion => integer().withDefault(const Constant(1))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// هر ذخیره‌ی قالب یک نسخه‌ی تغییرناپذیر می‌سازد (راه‌حل بند ۱۶).
class TemplateVersions extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get templateId => text().references(FormTemplates, #id)();
  IntColumn get version => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {templateId, version},
      ];
}

/// بخش (گروه) داخل یک نسخه از قالب
class TemplateSections extends Table {
  TextColumn get id => text()();
  TextColumn get versionId => text().references(TemplateVersions, #id)();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// فیلد داخل یک بخش.
/// id در هر نسخه یکتاست؛ stableKey بین نسخه‌ها ثابت می‌ماند تا
/// در آنالیز بتوان پاسخ‌ها را بین نسخه‌ها تطبیق داد.
class TemplateFields extends Table {
  TextColumn get id => text()();
  TextColumn get stableKey => text()();
  TextColumn get sectionId => text().references(TemplateSections, #id)();
  TextColumn get type => text()(); // FieldType.name
  TextColumn get label => text().withDefault(const Constant(''))();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  /// گزینه‌ها برای رادیویی/کمبو: JSON آرایه‌ی رشته‌ها
  TextColumn get optionsJson => text().withDefault(const Constant('[]'))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Dealerships extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// مشخصات بازرس (اولین اجرا) - فقط یک ردیف
class Inspectors extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get personnelCode => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// چک‌لیست پرشده. به یک «نسخه‌ی» مشخص از قالب وصل است.
class FilledForms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // نامی که کاربر انتخاب می‌کند
  TextColumn get templateVersionId =>
      text().references(TemplateVersions, #id)();
  TextColumn get templateName => text()(); // کپی نام قالب برای فیلتر/اکسل
  TextColumn get dealershipId =>
      text().nullable().references(Dealerships, #id)();
  TextColumn get dealershipName => text().withDefault(const Constant(''))();

  /// اسنپ‌شات مشخصات بازرس در لحظه‌ی ایجاد
  TextColumn get inspectorName => text()();
  TextColumn get inspectorCode => text().withDefault(const Constant(''))();

  /// 'draft' | 'finalized'
  TextColumn get status => text().withDefault(const Constant('draft'))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();

  /// امضاها: مسیر نسبی فایل PNG
  TextColumn get inspectorSignaturePath => text().nullable()();
  TextColumn get dealerSignaturePath => text().nullable()();
  TextColumn get dealerSignerName => text().withDefault(const Constant(''))();

  /// هش محتوا در زمان نهایی‌سازی برای تشخیص دستکاری
  TextColumn get contentHash => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get finalizedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// پاسخ هر فیلد. مقدار همیشه رشته (JSON برای مقادیر پیچیده).
/// عدد: ارقام انگلیسی | تاریخ: ISO میلادی | موقعیت: {"lat":..,"lng":..,"acc":..}
/// تصویر: آرایه‌ی مسیرهای نسبی | چک‌مارک: "true"/"false"
class FieldAnswers extends Table {
  TextColumn get formId => text().references(FilledForms, #id)();
  TextColumn get fieldId => text().references(TemplateFields, #id)();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {formId, fieldId};
}
