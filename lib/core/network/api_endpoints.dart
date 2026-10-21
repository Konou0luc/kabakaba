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
  static const String usersMeAvatar = '/users/me/avatar';

  static const String vendors = '/vendors';
  static String vendorById(String id) => '/vendors/$id';

  static const String campuses = '/campuses';
  static String campusById(String id) => '/campuses/$id';

  static String menusByVendor(String vendorId) => '/menus/$vendorId';
  static String componentsByVendor(String vendorId) => '/components/$vendorId';
  static String componentCategoriesByVendor(String vendorId) =>
      '/component-categories/$vendorId';
  static String takeawayOptionsByVendor(String vendorId) =>
      '/catalog/takeaway-options/$vendorId';

  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String orderCancel(String id) => '/orders/$id/cancel';

  static const String reports = '/reports';
  static String reportById(String id) => '/reports/$id';

  static const String scheduledOrders = '/scheduled-orders';
  static String scheduledOrderById(String id) => '/scheduled-orders/$id';
  static String scheduledOrderCancel(String id) =>
      '/scheduled-orders/$id/cancel';

  static const String referralsMe = '/referrals/me';

  static const String transactions = '/transactions';
  static String transactionById(String id) => '/transactions/$id';

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
