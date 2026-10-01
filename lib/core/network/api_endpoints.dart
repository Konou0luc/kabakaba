class ApiEndpoints {
  static const String auth = '/auth';
  static const String authSendOtp = '/auth/send-otp';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authLoginEmail = '/auth/login-email';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authChangePassword = '/auth/change-password';

  static const String users = '/users';
  static const String usersMe = '/users/me';
  static String userById(String id) => '/users/$id';
  static const String usersStaff = '/users/staff';

  static const String vendors = '/vendors';
  static String vendorById(String id) => '/vendors/$id';

  static const String campuses = '/campuses';
  static String campusById(String id) => '/campuses/$id';
  static String campusFaculties(String campusId) =>
      '/campuses/$campusId/faculties';

  static const String catalogMenuItems = '/catalog/menu-items';
  static String catalogMenuItemById(String id) => '/catalog/menu-items/$id';
  static String catalogMenuComponents(String itemId) => '/catalog/menu-components/$itemId';
  static String catalogMenuComponentDetail(String id) => '/catalog/menu-components/detail/$id';
  static String catalogPackagingOptions(String itemId) => '/catalog/packaging-options/$itemId';
  static String catalogPackagingOptionDetail(String id) => '/catalog/packaging-options/detail/$id';

  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String orderCancel(String id) => '/orders/$id/cancel';
  static String orderReceive(String id) => '/orders/$id/receive';
  static String orderDispute(String id) => '/orders/$id/dispute';

  static const String usersMeAvatar = '/users/me/avatar';

  static const String walletSend = '/wallet/send';

  static const String transactions = '/transactions';
  static String transactionById(String id) => '/transactions/$id';

  static const String ambassadors = '/ambassadors';
  static const String ambassadorsMe = '/ambassadors/me';
  static const String ambassadorsApply = '/ambassadors/apply';
  static const String ambassadorsSchoolCard = '/ambassadors/school-card';
  static String ambassadorById(String id) => '/ambassadors/$id';

  static const String payments = '/payments';
  static const String paymentsPreview = '/payments/preview';
  static const String paymentsIntent = '/payments/intent';
  static String paymentInitiate(String id) => '/payments/$id/initiate';
  static String paymentById(String id) => '/payments/$id';

  static const String reviews = '/reviews';

  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';

  static const String devices = '/devices';
}
