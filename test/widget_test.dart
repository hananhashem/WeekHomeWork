import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weekhomework/main.dart';

void main() {
  testWidgets('الصفحة الرئيسية تعرض النموذج', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Form), findsOneWidget);
    expect(find.text('إرسال'), findsOneWidget);
    expect(find.text('إعادة تعيين'), findsOneWidget);
  });
}
