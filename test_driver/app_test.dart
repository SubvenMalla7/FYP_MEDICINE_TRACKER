import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Login in with  new account  ", () {
  //   // finding testfields to enter data
    final nameTextfield = find.byValueKey('name');
    final emailTextfield = find.byValueKey('email');
    final passwordTextfield = find.byValueKey('password');
    final confirmPasswordTextfield = find.byValueKey('confirm_pass');
    final switchButton = find.byValueKey('switch');
    final signupButton = find.byValueKey('signup');
    final loginButton = find.byValueKey('login');
    final textFinder = find.text('Hello');
    final logoutButton = find.byValueKey('logout');

    FlutterDriver driver;

    //connecting to flutter driver before running any tests.

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Signup new account", () async {
      await driver.tap(switchButton);
      await driver.tap(nameTextfield);
      await driver.enterText("flutterdriver");
      await driver.tap(emailTextfield);
      await driver.enterText("flutter@driver.com");
      await driver.tap(passwordTextfield);
      await driver.enterText("flutter_driverPassword");
      await driver.tap(confirmPasswordTextfield);
      await driver.enterText("flutter_driverPassword");
      await driver.tap(signupButton);

      await driver.getText(textFinder);
      await driver.scroll(
          textFinder, 300.0, 0.0, const Duration(milliseconds: 300));
      await driver.tap(logoutButton);
    });

    test("Login existing account", () async {
      await driver.tap(emailTextfield);
      await driver.enterText("flutter@driver.com");
      await driver.tap(passwordTextfield);
      await driver.enterText("flutter_driverPassword");
      await driver.tap(loginButton);
    });
  });

  group("Adding/editing new medicines", () {
    // finding testfields to enter data
    final bottomNav = find.byValueKey('bottomNav');
    final addMedsButton = find.byValueKey('addMedicine');
    final medsNameTextField = find.byValueKey('medicineName');
    final intervalButtonn = find.byValueKey('interval');
    final submitButton = find.byValueKey('done');
    final editButton = find.byValueKey('editMedicine');

    FlutterDriver driver;

    //connecting to flutter driver before running any tests.

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Adding new medicine', () async {
      await driver.waitFor(bottomNav);
      await driver.tap(find.text('Medicines'));
      await driver.tap(addMedsButton);
      await driver.tap(medsNameTextField);
      await driver.enterText('Cetamol');
      await driver.tap(find.text('While eating'));
      await driver.tap(find.byValueKey('instruction'));
      await driver.enterText('Drink lots of water');
      await driver.tap(intervalButtonn);
      await driver.tap(find.text('6'));
      await driver.tap(submitButton);
      print('New medicine added');
      await driver.waitFor(bottomNav);
      await driver.tap(find.text('Dashboard'));
      await driver.getText(find.text('Cetamol'));
    });

    test('Editing medicine', () async {
      await driver.waitFor(bottomNav);
      await driver.tap(find.text('Medicines'));
      await driver.tap(find.text('Cetamol'));
      await driver.tap(editButton);
      await driver.tap(medsNameTextField);
      await driver.enterText('');
      await driver.tap(medsNameTextField);
      await driver.enterText('Linamet');
      await driver.tap(intervalButtonn);
      await driver.tap(find.text('6'));
      await driver.tap(submitButton);
      print('Medicine edited');
      await driver.getText(find.text('Linamet'));
    });
 });

  group("Status changing and snoozing medicine notification", () {
    // finding testfields to enter data

    final medicine = find.text('Linamet');
    final takenButton = find.byValueKey('taken');
    final skipedButton = find.byValueKey('skiped');
    final snoozeButton = find.byValueKey('snooze');
    FlutterDriver driver;

    //connecting to flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test("changing status of medicine to taken", () async {
      await driver.tap(medicine);
      await driver.tap(takenButton);
      await driver.tap(find.byValueKey('onMedicineTime'));
      print('Medicine Taken');
      await driver.getText(find.text('Taken'));
      await driver.tap(medicine);
    });
    test("changing status of medicine to skipped", () async {
      await driver.tap(medicine);
      await driver.tap(skipedButton);
      await driver.tap(find.byValueKey('reason3'));
      print('Medicine Skipped');
      await driver.getText(find.text('Skipped'));
      await driver.tap(medicine);
    });
    test("Snoozing medicine ", () async {
      await driver.tap(medicine);
      await driver.tap(snoozeButton);
      await driver.tap(find.byValueKey('snooze1'));
      print('Medicine snoozed');
      await Future.delayed(Duration(seconds: 6));
      await driver.tap(medicine);
    });
  });
  /////////////////user profile test//////////////
  group("User profile edit/ delete", () {
// finding testfields to enter data
    final textFinder = find.text('Linamet');
    final user = find.byValueKey('userprofile');
    final editButton = find.byValueKey('userEdit');

    final submitButton = find.byValueKey('userSubmit');
    final userNameTextField = find.byValueKey('username');
    final userPhoneTextField = find.byValueKey('userPhone');
    final userAgeTextField = find.byValueKey('userAge');
    FlutterDriver driver;

    //connecting to flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test("Viewing user profile and editing", () async {
      await driver.scroll(
          textFinder, 300.0, 0.0, const Duration(milliseconds: 300));
      await driver.tap(user);
      await driver.tap(editButton);
      await driver.tap(userNameTextField);
      await driver.enterText('');
      await driver.tap(userNameTextField);
      await driver.enterText('New Name');
      await driver.tap(userPhoneTextField);
      await driver.enterText('+977 9849826807');
      await driver.tap(userAgeTextField);
      await driver.enterText('21');
      await driver.tap(submitButton);
    });
  });

  group("Maps and Measurement", () {
// finding testfields to enter data
    final textFinder = find.text('Linamet');
    final maps = find.byValueKey('map');
    final hospitalLocation = find.byValueKey('map1');

    final callButton = find.byValueKey('call');
    final measurement = find.byValueKey('mesurements');
    final addButton = find.byValueKey('add');
    final weightButton = find.byValueKey('weight');
    final saveButton = find.byValueKey('mesurSave');

    FlutterDriver driver;

    //connecting to flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test("Visiting location of hospital in map and calling emergency call.", () async {
      await driver.scroll(
          textFinder, 300.0, 0.0, const Duration(milliseconds: 300));
      await driver.tap(maps);

      await driver.tap(hospitalLocation);
      await Future.delayed(Duration(seconds: 3));
      await driver.tap(callButton);
      await driver.tap(find.byTooltip('Back'));
    });
    test("adding measurements and editing", () async {
      await driver.scroll(
          textFinder, 300.0, 0.0, const Duration(milliseconds: 300));
      await driver.tap(measurement);
      await driver.tap(addButton);
      await driver.tap(weightButton);
      await driver.scroll(
          find.text('0'), 0, -4000, const Duration(milliseconds: 300));
      await driver.tap(find.text('80'));
      await driver.tap(find.text('Ok'));
     await driver.tap(saveButton);
    });
  });

  group("Deleteing medicine and deleting user account", () {
    final bottomNav = find.byValueKey('bottomNav');
    final deleteButton = find.byValueKey('userDelete');
    final medsDeleteButton = find.byValueKey('delete');
    final textFinder = find.text('Add your Medicine to get notify');
    final user = find.byValueKey('userprofile');

    FlutterDriver driver;

    //connecting to flutter driver before running any tests.

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    //closing the conencton to the driver after test have been completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Deleting medicine', () async {
      await driver.waitFor(bottomNav);
      await driver.tap(find.text('Medicines'));
      await driver.tap(find.text('Linamet'));
      await driver.tap(medsDeleteButton);
      await driver.tap(find.text('Yes'));
      print('Medicine deleted');
      await driver.getText(textFinder);
    });
    test("Deleting user profile", () async {
      await driver.scroll(
          textFinder, 300.0, 0.0, const Duration(milliseconds: 300));
      await driver.tap(user);
      await driver.tap(deleteButton);
      await driver.tap(find.text('Yes'));
    });
  });
}
