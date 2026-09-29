import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SharedPreferences mock is available for student session', () async {
    SharedPreferences.setMockInitialValues({'student_cart_v1': '[]'});
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('student_cart_v1'), '[]');
  });
}
