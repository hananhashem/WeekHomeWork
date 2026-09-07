import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'واجب فلاتر',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  static const List<String> _cities = ['عمّان', 'إربد', 'الزرقاء'];
  static const List<String> _languages = ['العربية', 'الإنجليزية', 'الفرنسية'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _requiredController = TextEditingController();

  bool _agree = false;
  String? _gender;
  bool _notifications = false;
  double _experience = 0;
  RangeValues _ageRange = const RangeValues(20, 40);
  String? _city;
  String? _language;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requiredController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ملخص البيانات المدخلة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('الاسم:', _nameController.text.isEmpty ? '—' : _nameController.text),
              _summaryRow('البريد الإلكتروني:', _emailController.text.isEmpty ? '—' : _emailController.text),
              _summaryRow('الهاتف:', _phoneController.text.isEmpty ? '—' : _phoneController.text),
              _summaryRow('الحقل المطلوب:', _requiredController.text.isEmpty ? '—' : _requiredController.text),
              _summaryRow('الموافقة:', _agree ? 'نعم' : 'لا'),
              _summaryRow('الجنس:', _gender ?? '—'),
              _summaryRow('الإشعارات:', _notifications ? 'مفعّل' : 'مطفأ'),
              _summaryRow('الخبرة:', '${_experience.round()} من 10'),
              _summaryRow('العمر:', '${_ageRange.start.round()} - ${_ageRange.end.round()}'),
              _summaryRow('المدينة:', _city ?? '—'),
              _summaryRow('اللغة:', _language ?? '—'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 6,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _reset() {
    _formKey.currentState?.reset();
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _requiredController.clear();
      _agree = false;
      _gender = null;
      _notifications = false;
      _experience = 0;
      _ageRange = const RangeValues(20, 40);
      _city = null;
      _language = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نموذج التسجيل — واجب فلاتر'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TextField (بدون تحقق)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل (بدون تحقق)',
                    hintText: 'اكتب أي شيء هنا...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني *',
                    hintText: 'example@mail.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    final email = value ?? '';
                    return email.contains('@') ? null : 'بريد غير صحيح';
                  },
                ),
                const SizedBox(height: 16),

                // 3. الهاتف
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف *',
                    hintText: '10 أرقام',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    counterText: '',
                  ),
                  validator: (value) {
                    final phone = value ?? '';
                    return phone.length == 10 ? null : 'رقم غير صحيح';
                  },
                ),
                const SizedBox(height: 16),

                // 4. حقل مطلوب
                TextFormField(
                  controller: _requiredController,
                  decoration: const InputDecoration(
                    labelText: 'حقل مطلوب *',
                    hintText: 'لا يسمح بالقيم الفارغة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.star_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // 5. Checkbox (الموافقة)
                FormField<bool>(
                  initialValue: _agree,
                  validator: (value) => value == true ? null : 'وافق على الشروط',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        value: state.value,
                        title: const Text('الموافقة على الشروط *'),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) {
                          state.didChange(v);
                          setState(() => _agree = v ?? false);
                        },
                      ),
                      _FieldError(state.errorText),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 6. Radio (الجنس)
                FormField<String?>(
                  initialValue: _gender,
                  validator: (value) => value != null ? null : 'اختر الجنس',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: Text('الجنس *', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      RadioGroup<String>(
                        groupValue: state.value,
                        onChanged: (v) {
                          state.didChange(v);
                          setState(() => _gender = v);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                dense: true,
                                title: const Text('ذكر'),
                                value: 'ذكر',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                dense: true,
                                title: const Text('أنثى'),
                                value: 'أنثى',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _FieldError(state.errorText),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // 7. Switch (الإشعارات، بدون تحقق)
                SwitchListTile(
                  value: _notifications,
                  title: const Text('تفعيل الإشعارات'),
                  subtitle: const Text('لا يوجد تحقق — تشغيل/إيقاف'),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                const SizedBox(height: 8),

                // 8. Slider (الخبرة)
                FormField<double>(
                  initialValue: _experience,
                  validator: (value) => value != null && value >= 0 && value <= 10 ? null : 'خارج النطاق',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Row(
                          children: [
                            const Text('الخبرة (0-10) *', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text('${state.value!.round()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Slider(
                        value: state.value!,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: '${state.value!.round()}',
                        onChanged: (v) {
                          state.didChange(v);
                          setState(() => _experience = v);
                        },
                      ),
                      _FieldError(state.errorText),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 9. RangeSlider (العمر)
                FormField<RangeValues>(
                  initialValue: _ageRange,
                  validator: (value) => value != null && value.start < value.end ? null : 'نطاق غير صحيح',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Row(
                          children: [
                            const Text('العمر *', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text('${state.value!.start.round()} - ${state.value!.end.round()}'),
                          ],
                        ),
                      ),
                      RangeSlider(
                        values: state.value!,
                        min: 18,
                        max: 48,
                        divisions: 15,
                        labels: RangeLabels(
                          '${state.value!.start.round()}',
                          '${state.value!.end.round()}',
                        ),
                        onChanged: (v) {
                          state.didChange(v);
                          setState(() => _ageRange = v);
                        },
                      ),
                      _FieldError(state.errorText),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 10. DropdownButton (المدينة)
                DropdownButtonFormField<String>(
                  initialValue: _city,
                  decoration: const InputDecoration(
                    labelText: 'المدينة *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: _cities
                      .map((city) => DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _city = v),
                  validator: (value) => value != null ? null : 'اختر مدينة',
                ),
                const SizedBox(height: 16),

                // 11. PopupMenuButton (اللغة)
                FormField<String?>(
                  initialValue: _language,
                  validator: (value) => value != null ? null : 'اختر لغة',
                  builder: (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 4),
                        child: Text('اللغة *', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        child: PopupMenuButton<String>(
                          initialValue: state.value,
                          tooltip: 'اختر اللغة',
                          child: Row(
                            children: [
                              const Icon(Icons.language),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.value ?? 'اختر اللغة',
                                  style: TextStyle(
                                    color: state.value == null
                                        ? Theme.of(context).hintColor
                                        : null,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          itemBuilder: (menuContext) => _languages.map((language) {
                            return PopupMenuItem<String>(
                              value: language,
                              child: Text(language),
                            );
                          }).toList(),
                          onSelected: (v) {
                            state.didChange(v);
                            setState(() => _language = v);
                          },
                        ),
                      ),
                      _FieldError(state.errorText),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // أزرار الإرسال وإعادة التعيين
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.send),
                        label: const Text('إرسال'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: _reset,
                        child: const Text('إعادة تعيين'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// عنصر مساعد لعرض رسالة الخطأ تحت الحقل.

class _FieldError extends StatelessWidget {
  const _FieldError(this.errorText);

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    if (errorText == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        errorText!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
