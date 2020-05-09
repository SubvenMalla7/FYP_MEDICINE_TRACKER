import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test_dasd/model/auth.dart';

import 'package:test_dasd/screens/signupLoginup.dart';

class MockAuth extends Mock implements Auth {}

void main() {
  Widget makeTestableWidget(Widget child, Auth auth) {
    return ChangeNotifierProvider.value(
      value: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('email or password is empty, does not sign in',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();
    LoginSign page = LoginSign();
    await tester.pumpWidget(makeTestableWidget(page, mockAuth));

    await tester.tap(find.byKey(Key('login')));
    var result = verifyNever(mockAuth.login('', ''));
    expect(result.callCount, 0);
  });

  testWidgets(
      'email and password are not empty and donot match with database,fail',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();

    LoginSign page = LoginSign();
    await tester.pumpWidget(makeTestableWidget(page, mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email@email.com');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('login')));
    var result = verify(mockAuth.login('email@email.com', 'password'));
    expect(result.callCount, 1);
  });

  testWidgets('email and password are not empty and  match with database,fails',
      (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();
    LoginSign page = LoginSign();
    await tester.pumpWidget(makeTestableWidget(page, mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'admin@admin.com');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, '12345678');

    await tester.tap(find.byKey(Key('login')));
    var result = verify(mockAuth.login('admin@admin.com', '12345678'));
    expect(result.callCount, 1);
  });
}
