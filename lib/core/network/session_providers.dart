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
  final campusId = ref.watch(meProvider).valueOrNull?.campusId;
  final page = await ref
      .read(vendorRepositoryProvider)
      .findAllVendors(limit: 50, campusId: campusId);
  return page.data.where((vendor) => vendor.isActive).toList();
});

final myScheduledOrdersProvider =
    FutureProvider<List<ScheduledOrderModel>>((ref) async {
  ref.watch(authProvider);
  final page = await ref
      .read(scheduledOrderRepositoryProvider)
      .findAll(limit: 50, status: 'PENDING');
  return page.data;
});

final vendorDetailProvider = FutureProvider.family<VendorModel, String>((
  ref,
  id,
) {
  return ref.read(vendorRepositoryProvider).getVendorById(id);
});

final vendorMenusProvider =
    FutureProvider.family<List<MenuModel>, String>((ref, vendorId) {
  return ref.read(catalogRepositoryProvider).findMenus(vendorId);
});

final vendorComponentsProvider =
    FutureProvider.family<List<ComponentModel>, String>((ref, vendorId) {
  return ref.read(catalogRepositoryProvider).findComponents(vendorId);
});

final vendorCategoriesProvider =
    FutureProvider.family<List<ComponentCategoryModel>, String>((ref, vendorId) {
  return ref
      .read(catalogRepositoryProvider)
      .findComponentCategories(vendorId);
});

/// Alias utilisé by canteen_detail.
final vendorComponentCategoriesProvider = vendorCategoriesProvider;

final vendorTakeawayOptionsProvider =
    FutureProvider.family<List<TakeawayOptionModel>, String>((ref, vendorId) {
  return ref.read(catalogRepositoryProvider).findTakeawayOptions(vendorId);
});

/// Alias takeaway (cart_page).
final takeawayOptionsProvider = vendorTakeawayOptionsProvider;

/// Alias pour les écrans qui listaient encore « le menu » d’une cantine.
final vendorMenuProvider = vendorMenusProvider;

/// Lookup d’un menu dans le catalogue vendeur (remplace menuItemProvider).
final menuFromVendorProvider =
    FutureProvider.family<MenuModel?, ({String vendorId, String menuId})>((
  ref,
  args,
) async {
  final menus = await ref.watch(vendorMenusProvider(args.vendorId).future);
  for (final menu in menus) {
    if (menu.id == args.menuId) return menu;
  }
  return null;
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

final myReferralProvider = FutureProvider<ReferralMeModel?>((ref) async {
  ref.watch(authProvider);
  try {
    return await ref.read(referralRepositoryProvider).getMine();
  } catch (_) {
    return null;
  }
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
    ref.invalidate(myReferralProvider);
    ref.invalidate(myScheduledOrdersProvider);
  } finally {
    _sessionRefreshBusy = false;
  }
}
