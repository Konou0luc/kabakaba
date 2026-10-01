import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_provider.dart';
import '../../features/profile/data/user_repository.dart';
import '../../features/vendors/data/vendor_repository.dart';
import '../../shared/models/api_models.dart';
import '../../shared/models/user_model.dart';
import 'repositories.dart';

final meProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth != AuthState.authenticated) return null;
  final cached = ref.read(authProvider.notifier).currentUser;
  try {
    final user = await ref.read(userRepositoryProvider).getMe();
    ref.read(authProvider.notifier).updateCurrentUser(user);
    return user;
  } catch (_) {
    return cached;
  }
});

final vendorsListProvider = FutureProvider<List<VendorModel>>((ref) async {
  final page = await ref
      .read(vendorRepositoryProvider)
      .findAllVendors(limit: 50);
  return page.data.where((vendor) => vendor.isActive).toList();
});

final vendorDetailProvider = FutureProvider.family<VendorModel, String>((
  ref,
  id,
) {
  return ref.read(vendorRepositoryProvider).getVendorById(id);
});

final vendorMenuProvider = FutureProvider.family<List<MenuItemModel>, String>((
  ref,
  id,
) async {
  final page = await ref
      .read(catalogRepositoryProvider)
      .findAllMenuItems(vendorId: id, limit: 80);
  return page.data;
});

final myOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  ref.watch(authProvider);
  final page = await ref.read(orderRepositoryProvider).findAllOrders(limit: 50);
  return page.data;
});

final myTransactionsProvider = FutureProvider<List<TransactionModel>>((
  ref,
) async {
  ref.watch(authProvider);
  final page = await ref
      .read(transactionRepositoryProvider)
      .findAllTransactions(limit: 50);
  return page.data;
});

final campusesListProvider = FutureProvider<List<CampusModel>>((ref) async {
  final page = await ref
      .read(campusRepositoryProvider)
      .findAllCampuses(limit: 50);
  return page.data.where((campus) => campus.isActive).toList();
});

final myNotificationsProvider = FutureProvider<List<NotificationModel>>((
  ref,
) async {
  ref.watch(authProvider);
  final page = await ref
      .read(notificationRepositoryProvider)
      .findAllNotifications(limit: 50);
  return page.data;
});

final myAmbassadorProvider = FutureProvider<AmbassadorModel?>((ref) async {
  ref.watch(authProvider);
  return ref.read(ambassadorRepositoryProvider).getMyAmbassadorProfile();
});

final facultiesProvider = FutureProvider.family<List<FacultyModel>, String>((
  ref,
  campusId,
) async {
  final faculties = await ref
      .read(campusRepositoryProvider)
      .findFaculties(campusId);
  return faculties.where((faculty) => faculty.active).toList();
});

final menuItemProvider = FutureProvider.family<MenuItemModel, String>((
  ref,
  id,
) {
  return ref.read(catalogRepositoryProvider).getMenuItemById(id);
});

final menuComponentsProvider =
    FutureProvider.family<List<MenuComponentModel>, String>((ref, itemId) {
  return ref.read(catalogRepositoryProvider).findComponents(itemId);
});

final packagingOptionsProvider =
    FutureProvider.family<List<PackagingOptionModel>, String>((ref, itemId) {
  return ref.read(catalogRepositoryProvider).findPackagingOptions(itemId);
});

final orderDetailProvider = FutureProvider.family<OrderModel, String>((
  ref,
  id,
) {
  return ref.read(orderRepositoryProvider).getOrderById(id);
});

bool _sessionRefreshBusy = false;

Future<void> refreshStudentSession(WidgetRef ref) async {
  if (_sessionRefreshBusy) return;
  _sessionRefreshBusy = true;
  try {
    ref.invalidate(meProvider);
    await ref.read(meProvider.future);
    ref.invalidate(myOrdersProvider);
    await ref.read(myOrdersProvider.future);
    ref.invalidate(myTransactionsProvider);
    await ref.read(myTransactionsProvider.future);
    ref.invalidate(myNotificationsProvider);
    await ref.read(myNotificationsProvider.future);
    ref.invalidate(vendorsListProvider);
    await ref.read(vendorsListProvider.future);
    ref.invalidate(myAmbassadorProvider);
  } finally {
    _sessionRefreshBusy = false;
  }
}
