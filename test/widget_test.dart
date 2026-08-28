import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:password_manager/Login.dart';

void main() {
  testWidgets('Login screen renders email/password fields and actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Login shows a validation error when submitted empty', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter Email'), findsOneWidget);
    expect(find.text('Please enter Password'), findsOneWidget);
  });
}
