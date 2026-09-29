import 'kaba_snack.dart';

class ToastHelper {
  static void showSuccess(String message) => KabaSnack.success(message);

  static void showError(String message) => KabaSnack.error(message);

  static void showInfo(String message) => KabaSnack.info(message);

  static void showWarning(String message) => KabaSnack.warning(message);
}
