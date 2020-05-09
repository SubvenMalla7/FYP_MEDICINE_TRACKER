import 'package:flutter_test/flutter_test.dart';
import 'package:test_dasd/screens/signupLoginup.dart';

void main() {
  test('email validate should return error if empty', () {
    var result = EmailValidator.validate('');
    expect(result, 'Email cannot be empty');
  });
  test('email validate should return error if invalid', () {
    var result = EmailValidator.validate('patient');
    expect(result, 'Email Should contain @');
  });
}
