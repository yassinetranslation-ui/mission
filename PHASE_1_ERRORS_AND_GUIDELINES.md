# 📘 سجل أخطاء المرحلة الأولى ودليل التوجيهات البرمجية للمراحل القادمة
## (Phase 1 Errors & Preventive Guidelines for Future Phases)

> تم إنشاء هذا الملف ليكون مرجعاً هندسياً يضمن تفادي كافة الأخطاء البرمجية والتعارضات التي ظهرت أثناء تأسيس المرحلة الأولى، وتطبيق أفضل الممارسات في جميع المراحل القادمة.

---

## 1. محرك Flutter ولغة Dart (Flutter 3.44+ & Dart 3.12+)

### أ. تحديثات كائنات الـ ThemeData
* **الخطأ السابق:** استخدام `CardTheme(...)` أو `DialogTheme(...)` مباشرة داخل `ThemeData`.
* **السبب:** في التحديثات الأخيرة لـ Flutter، تم تغيير الأنواع المتوقعة إلى `CardThemeData` و `DialogThemeData`.
* **القاعدة للمراحل القادمة:**
  ```dart
  // ❌ غير صحيح
  cardTheme: CardTheme(...)
  dialogTheme: DialogTheme(...)

  // ✅ صحيح
  cardTheme: CardThemeData(...)
  dialogTheme: DialogThemeData(...)
  ```

### ب. نظام الألوان والشفافية (Color Transparency & Deprecations)
* **الخطأ السابق:** استخدام `color.withOpacity(...)` و `ColorScheme.background`.
* **السبب:** تراجع رسمي في فلاتر لمنع تقريب الألوان الخاطئ وفصل ألوان الخلفية عن الأسطح.
* **القاعدة للمراحل القادمة:**
  ```dart
  // ❌ غير صحيح
  color.withOpacity(0.5);
  ColorScheme.light(background: Colors.white);

  // ✅ صحيح
  color.withValues(alpha: 0.5);
  ColorScheme.light(surface: Colors.white);
  ```

### ج. تضارب أسماء الكلاسات مع الحزم الخارجية (Name Clashes)
* **الخطأ السابق:** استيراد `intl` و `material.dart` معاً مما سبب تضارباً في كائن `TextDirection`.
* **القاعدة للمراحل القادمة:** عند استيراد `intl` للتعامل مع التواريخ والأرقام، يجب إخفاء `TextDirection`:
  ```dart
  import 'package:intl/intl.dart' hide TextDirection;
  ```

### د. معاملات المُنشئ في وراثة الكلاسات (Constructors with Super Parameters)
* **الخطأ السابق:** تمرير معامل اختياري مسمى `{super.code}` في الكلاس الابن بينما هو معرف كمعامل موضعي `[this.code]` في الكلاس الأب `Failure`.
* **القاعدة للمراحل القادمة:** مطابقة نوع المعاملات (Positional vs Named) بدقة بين الكلاس الأب والابن.

### هـ. التعامل مع الحزم الحديثة (مثل connectivity_plus v6+)
* **الخطأ السابق:** فحص نتيجة الاتصال كقيمة مفردة `result != ConnectivityResult.none`.
* **السبب:** الحزمة أصبحت تعيد مصفوفة `List<ConnectivityResult>` لدعم اتصالات متعددة في نفس الوقت.
* **القاعدة للمراحل القادمة:**
  ```dart
  final results = await Connectivity().checkConnectivity();
  final hasConnection = !results.contains(ConnectivityResult.none);
  ```

### و. توليد الشفرات لنماذج البيانات (Code Generation)
* **القاعدة للمراحل القادمة:** عند إنشاء أو تعديل أي نموذج بيانات يحتوي على `@JsonSerializable()` أو `@riverpod`:
  1. التأكد من وجود توجيه `part 'filename.g.dart';`.
  2. تشغيل الأمر فور الانتهاء:
     ```bash
     dart run build_runner build -d
     ```

---

## 2. الواجهة الخلفية والبيئة (Python FastAPI & Windows Environment)

### أ. معالجة ملفات PDF وتجنب مشاكل الـ C++ DLLs على Windows
* **الخطأ السابق:** استخدام `PyMuPDF (fitz)` الذي يعتمد على مكتبات C++ مبنية مسبقاً وفشل في تحميل DLL على Windows.
* **الحل والقاعدة للمراحل القادمة:** الاعتماد على مكتبات بايثون القياسية النقية مثل `pypdf`:
  ```python
  from pypdf import PdfReader

  def extract_text_from_pdf(file_path: str) -> str:
      reader = PdfReader(file_path)
      return "".join([page.extract_text() or "" for page in reader.pages])
  ```

### ب. التحقق من الحقول في Pydantic (Email Validation)
* **الخطأ السابق:** استخدام نوع `EmailStr` دون تثبيت حزمة `email-validator`.
* **القاعدة للمراحل القادمة:** أي حزمة فرعية من Pydantic يتم تثبيتها صراحة في `requirements.txt` والبيئة:
  ```bash
  pip install "pydantic[email]" email-validator
  ```

### ج. أوامر الطرفية في PowerShell على Windows
* **الخطأ السابق:** استخدام الرمز `&&` لربط الأوامر في PowerShell القديم.
* **القاعدة للمراحل القادمة:** استخدام الفاصلة المنقوطة `;` لربط الأوامر في بيئة Windows PowerShell.

---

## 4. توافقية قواعد البيانات (MySQL & SQLAlchemy Guidelines)

### أ. محرك وقائد الاتصال (MySQL Driver via PyMySQL)
* **القاعدة:** استخدام `PyMySQL` (`mysql+pymysql://`) كقائد اتصال نقي مكتوب بلغة Python لضمان عدم وجود مشاكل تجميع C++ على Windows:
  ```text
  DATABASE_URL=mysql+pymysql://<user>:<password>@<host>:3306/<dbname>?charset=utf8mb4
  ```

### ب. تحديد أطوال الحقول النصية (Explicit String/VARCHAR Lengths)
* **القاعدة في MySQL:** جميع حقول المفاتيح الأساسية (UUID Primary Keys)، والمفاتيح الأجنبية (Foreign Keys)، والحقول المفهرسة (Indexes) أو الفريدة (Unique) يجب تحديد طولها صراحة:
  - للـ UUIDs: `String(36)`
  - للبريد الإلكتروني والأسماء: `String(255)`
  - للنصوص القصيرة والرموز (Flags/Status/Enums): `String(50)` أو `String(20)`
  - للنصوص الطويلة والشروحات: استخدام `Text`
  - للبيانات الهيكلية: استخدام نوع `JSON` (المدعوم في MySQL 5.7.8+)

### ج. استقرار الاتصال وإعادة التدوير (Connection Pooling & Pre-ping)
* **القاعدة:** تفعيل `pool_pre_ping=True` و `pool_recycle=3600` في `create_engine` لتفادي أخطاء انقطاع الاتصال المفاجئ من MySQL (`MySQL server has gone away`).

---

## 5. قائمة التحقق السريع قبل إغلاق أي مرحلة (Quality Gate Checklist)

- [ ] تشغيل `flutter analyze` في مجلد `app` والتأكد من ظهور `No issues found!`.
- [ ] التأكد من عدم وجود أي `deprecated_member_use` في واجهات المستخدم.
- [ ] التأكد من تشغيل `dart run build_runner build -d` لتحديث ملفات `.g.dart`.
- [ ] تشغيل فحص استيراد الواجهة الخلفية:
  ```bash
  python -c "from app.main import app; print('Backend OK')"
  ```
- [ ] التحقق من دعم اتجاه النص العربي (RTL) في كل عنصر جديد يتم بناؤه.

