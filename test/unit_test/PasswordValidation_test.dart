import 'package:flutter_test/flutter_test.dart';
import 'package:test_dasd/screens/signupLoginup.dart';

void main() {
  test('password validate should return error if empty', () {
    var result = PasswordValidator.validate('');
    expect(result, 'Password cannot be empty');
  });
  test('password validate should return error if invalid', () {
    var result = PasswordValidator.validate('pass');
    expect(result, 'Password is too short!');
  });
}
