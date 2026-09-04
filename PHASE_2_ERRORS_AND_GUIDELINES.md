# 📘 سجل أخطاء وتحديات المرحلة الثانية ودليل التوجيهات الهندسية للمراحل القادمة
## (Phase 2 Errors, Root Cause Analysis & Preventive Guidelines)

> **الهدف من هذا المستند:** توثيق شامل ودقيق لجميع الأخطاء والتحديات الهندسية التي تم اكتشافها وتصحيحها أثناء مراجعة وتدقيق **المرحلة الثانية (Authentication & Profiles)** لضمان التكامل الكامل بين تطبيق Flutter وخادم FastAPI وقاعدة بيانات MySQL وتفادي تكرارها في المراحل القادمة.

---

## 1. أخطاء الواجهة الخلفية والبيئة (Backend & Environment)

### أ. تعارض مكتبة التشفير `passlib` مع إصدارات `bcrypt 4.0+` في Python 3.14
* **الخطأ:** ظهور استثناء `AttributeError: module 'bcrypt' has no attribute '__about__'` عند استدعاء دالة التشفير أو تسجيل المستخدمين.
* **السبب الجذري:** مكتبة `passlib` لم تعد تُحدث منذ فترة، وتقوم بمحاولة قراءة متغير داخلي تم حذفه في إصدارات `bcrypt` الحديثة، مما يسبب انهيار عملية التشفير بالكامل.
* **التصحيح المطبق:** تم استبدال `passlib` بالاعتماد المباشر على مكتبة `bcrypt` القياسية:
  ```python
  import bcrypt

  def hash_password(password: str) -> str:
      salt = bcrypt.gensalt()
      hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
      return hashed.decode('utf-8')

  def verify_password(plain_password: str, hashed_password: str) -> bool:
      try:
          return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))
      except ValueError:
          return False
  ```

---

### ب. عدم تطابق أنواع الحقول في مخططات Pydantic (`preferred_subjects`)
* **الخطأ:** ظهور خطأ `422 Unprocessable Entity: Input should be a valid dictionary` عند إنشاء أو تعديل ملف الطفل.
* **السبب الجذري:** كان نوع الحقل في مخطط Pydantic معرفاً كـ `Optional[Dict[str, Any]]` بينما تطبيق الهاتف يرسل قائمة أسماء المواد المفضلة كـ `List[str]` مثل `["Math", "Science"]`.
* **التصحيح المطبق:** تم توحيد النوع في `CreateChildRequest`, `UpdateChildRequest`, و `ChildResponse` إلى:
  ```python
  preferred_subjects: Optional[List[str]] = None
  ```

---

### ج. غياب حقل `updated_at` في استجابة المستخدم `UserResponse`
* **الخطأ:** حدوث أخطاء تحويل أثناء تسلسل كائنات المستخدم `User` من SQLAlchemy إلى نماذج Pydantic في نقاط الدخول (`/auth/register`, `/auth/login`, `/auth/me`).
* **التصحيح المطبق:** تم تزويد `UserResponse` بالحقل مع قيمة افتراضية اختيارية وتفعيل خاصية قراءة الكائنات:
  ```python
  class UserResponse(BaseModel):
      id: str
      email: EmailStr
      name: str
      role: str
      preferred_language: str
      created_at: datetime
      updated_at: Optional[datetime] = None
      
      model_config = {"from_attributes": True, "use_enum_values": True}
  ```

---

### د. تحديد أطوال الحقول الصريحة للتوافق مع MySQL
* **الخطأ:** فشل إنشاء الجداول في MySQL عند استخدام نوع `String` العام للمفاتيح الأساسية والفهارس.
* **السبب الجذري:** محرك MySQL يتطلب تحديد طول `VARCHAR` صريح لجميع المفاتيح والفهارس.
* **التصحيح المطبق:** 
  - جميع مفاتيح الـ UUID تم تحديدها كـ `String(36)`.
  - النصوص المفهرسة مثل البريد والأسماء تم تحديدها كـ `String(255)` و `String(100)`.
  - تم تفعيل `pool_recycle=3600` و `pool_pre_ping=True` لضمان ثبات الاتصال.

---

## 2. أخطاء الواجهة الأمامية وربط الـ API (Flutter Frontend)

### أ. تضارب تسمية الحقول في JSON (تضارب `camelCase` مع `snake_case`)
* **الخطأ:** حدوث `TypeError: null is not a subtype of type 'String'` عند فك تشفير JSON الخاص بالمستخدم وملفات الأطفال.
* **السبب الجذري:** خادم FastAPI يرسل الحقول بنمط `snake_case` (مثل `access_token`, `parent_id`, `created_at`) بينما كود Dart كان يقرأ `accessToken`, `parentId`, `createdAt`.
* **التصحيح المطبق:** 
  1. إضافة `@JsonSerializable(fieldRename: FieldRename.snake)` إلى جميع نماذج Dart (`User`, `ChildProfile`).
  2. تحديث `AuthResponse.fromJson` في `auth_service.dart` لدعم كلا الصيغتين:
     ```dart
     accessToken: (json['access_token'] ?? json['accessToken']) as String,
     refreshToken: (json['refresh_token'] ?? json['refreshToken']) as String,
     ```

---

### ب. خطأ فك تشفير قائمة الأطفال في `ChildService`
* **الخطأ:** ظهور خطأ `TypeError: _Map<String, dynamic> is not a subtype of type 'List<dynamic>'`.
* **السبب الجذري:** دالة `getChildren` في الواجهة الخلفية تعيد كائن `ChildListResponse` بصيغة `{"children": [...]}` بينما تطبيق فلاتر كان يحاول تحويل `response.data` مباشرة كـ `List`.
* **التصحيح المطبق:** تم تعديل `ChildService.getChildren` لاستخراج المصفوفة بأمان:
  ```dart
  if (response.data is Map && response.data['children'] != null) {
    final list = response.data['children'] as List;
    return list.map((e) => ChildProfile.fromJson(e as Map<String, dynamic>)).toList();
  }
  ```

---

### ج. استخدام نوع طلب HTTP غير مطابق لتحديث بيانات الطفل
* **الخطأ:** تلقي خطأ `405 Method Not Allowed` عند تحديث ملف الطفل.
* **السبب الجذري:** `ChildService` كان يرسل طلب `PATCH` بينما النقطة المعرفة في FastAPI هي `@router.put("/{child_id}")`.
* **التصحيح المطبق:** تعديل الطلب في `child_service.dart` لاستخدام `_dio.put(...)`.

---

### د. قراءة رسائل الأخطاء القادمة من FastAPI في `ErrorInterceptor`
* **الخطأ:** ظهور رسالة عامة وغير مفهومة للمستخدم `Login failed: Server error` عند إدخال كلمة مرور خاطئة أو بريد مسجل مسبقاً.
* **السبب الجذري:** كان معترض الأخطاء `ErrorInterceptor` يبحث عن `data['message']` فقط، في حين أن FastAPI يضع رسائل الخطأ داخل `data['detail']` (كنص أو كمصفوفة أخطاء تحقق).
* **التصحيح المطبق:** بناء دالة استخراج ذكية `_extractErrorMessage` تدعم صيغ FastAPI المختلفة:
  ```dart
  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data['detail'] != null) {
        if (data['detail'] is String) return data['detail'] as String;
        if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
          final first = (data['detail'] as List).first;
          if (first is Map && first['msg'] != null) return first['msg'].toString();
          return first.toString();
        }
      }
      if (data['message'] != null) return data['message'].toString();
    }
    return 'Server error';
  }
  ```

---

### هـ. طباعة نصوص الاستثناءات في كلاسات `exceptions.dart`
* **الخطأ:** طباعة `Instance of 'AuthException'` في شريط التنبيهات (SnackBar) بدلاً من نص الخطأ الفعلي.
* **السبب الجذري:** كلاسات `Exception` لم تكن تعيد تعريف دالة `toString()`.
* **التصحيح المطبق:** إضافة `@override String toString() => message;` لجميع كلاسات الاستثناءات.

---

## 3. الشاشات المكتملة في المرحلة الثانية (Completed Screens)

تم تحويل جميع الشاشات المؤقتة في المرحلة الثانية إلى واجهات تفاعلية كاملة:
1. **`SplashScreen`**: شاشة بداية متحركة بالهوية البصرية وتدرج اللون البنفسجي، مع توجيه ذكي للمستخدم بناءً على حالة تسجيل الدخول.
2. **`ParentShellScreen`**: هيكل التنقل السفلي للأب (NavigationBar) الذي يربط بين الرئيسية، ملفات الأطفال، رفع الدروس، والإعدادات.
3. **`ParentHomeScreen`**: شاشة رئيسية تفاعلية تتضمن بطاقة الدعوة لرفع الدروس (CTA)، بطاقات الأطفال بمستوياتهم وشارات الاستمرارية (Streaks)، والتحويل لوضع الطفل.
4. **`ChildrenListScreen`**: عرض قائمة الأطفال مع بطاقات الـ XP والمستويات، ودعم السحب للتحديث (Pull-to-refresh)، وحالة الشاشة الفارغة (Empty State).
5. **`ChildDetailScreen`**: تفاصيل ملف الطفل مع إمكانية التعديل (Edit Dialog) والحذف مع نافذة تأكيد، وإحصائيات المستوى.
6. **`AddChildScreen`**: نموذج إضافة طفل جديد مع اختيار المراحل الدراسية والشرائح التفاعلية للمواد المفضلة والتحقق من صحة المدخلات.

---

## 4. القواعد الذهبية للمراحل القادمة (Golden Preventive Guidelines)

1. **تناسق نمط التسمية (Snake_case Contract):**
   - كافة نماذج Dart يجب أن تحمل دائماً `@JsonSerializable(fieldRename: FieldRename.snake)`.
   - كافة طلبات `Dio` التي ترسل Body يجب أن تطابق مفاتيح `snake_case` المتوقعة من خادم FastAPI.

2. **قواعد نقاط نهاية FastAPI:**
   - استخدام الـ Type Hints الدقيقة في Pydantic schemas مع تجنب `Dict[str, Any]` عندما تكون البيانات مصفوفة `List[str]`.
   - تضمين `from_attributes = True` دائماً في المخططات التي تقرأ من جداول SQLAlchemy.

3. **قواعد نماذج MySQL:**
   - تحديد أطوال الأعمدة النصية صراحة `String(36)` للـ UUIDs و `String(255)` للنصوص و `Text` للشروحات والمحتوى التعليمي.
