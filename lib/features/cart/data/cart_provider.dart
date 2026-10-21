import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../shared/models/api_models.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/data/auth_repository.dart';

class CartLine {
  final String vendorId;
  final String vendorName;
  final String? menuId;
  final String? componentId;
  final String name;
  final int priceTickets;
  final int quantity;
  final String? imageUrl;
  final String? unit;

  const CartLine({
    required this.vendorId,
    required this.vendorName,
    this.menuId,
    this.componentId,
    required this.name,
    required this.priceTickets,
    required this.quantity,
    this.imageUrl,
    this.unit,
  });

  String get lineKey => menuId != null ? 'm:$menuId' : 'c:$componentId';

  int get lineTotal => priceTickets * quantity;

  int get unitTotal => priceTickets;

  bool get isMenu => menuId != null && menuId!.isNotEmpty;

  CartLine copyWith({int? quantity}) => CartLine(
        vendorId: vendorId,
        vendorName: vendorName,
        menuId: menuId,
        componentId: componentId,
        name: name,
        priceTickets: priceTickets,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl,
        unit: unit,
      );

  Map<String, dynamic> toOrderJson() => {
        if (menuId != null) 'menuId': menuId,
        if (componentId != null) 'componentId': componentId,
        'quantity': quantity,
      };

  Map<String, dynamic> toJson() => {
        'vendorId': vendorId,
        'vendorName': vendorName,
        'menuId': menuId,
        'componentId': componentId,
        'name': name,
        'priceTickets': priceTickets,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'unit': unit,
      };

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        vendorId: json['vendorId'] as String? ?? '',
        vendorName: json['vendorName'] as String? ?? 'Cantine',
        menuId: json['menuId'] as String? ??
            (json['menuItemId'] as String?), // migrate old carts
        componentId: json['componentId'] as String?,
        name: json['name'] as String? ?? 'Article',
        priceTickets: (json['priceTickets'] as num?)?.toInt() ?? 0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
        imageUrl: json['imageUrl'] as String?,
        unit: json['unit'] as String?,
      );
}

class CartState {
  final List<CartLine> lines;
  final ConsumptionMode consumptionMode;
  final String? takeawayOptionId;
  final int takeawayFeeTickets;

  const CartState({
    this.lines = const [],
    this.consumptionMode = ConsumptionMode.ON_SITE,
    this.takeawayOptionId,
    this.takeawayFeeTickets = 0,
  });

  String? get vendorId => lines.isEmpty ? null : lines.first.vendorId;

  String get vendorName => lines.isEmpty ? '' : lines.first.vendorName;

  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);

  int get itemsTickets => lines.fold(0, (sum, line) => sum + line.lineTotal);

  int get totalTickets =>
      itemsTickets +
      (consumptionMode == ConsumptionMode.TAKEAWAY ? takeawayFeeTickets : 0);

  int get packagingExtra => takeawayFeeTickets;

  bool get isEmpty => lines.isEmpty;

  Map<String, dynamic> toJson() => {
        'consumptionMode': consumptionMode.name,
        'takeawayOptionId': takeawayOptionId,
        'takeawayFeeTickets': takeawayFeeTickets,
        'lines': [for (final line in lines) line.toJson()],
      };

  factory CartState.fromJson(Map<String, dynamic> json) {
    final mode = (json['consumptionMode'] as String?)?.toUpperCase() ==
            'TAKEAWAY'
        ? ConsumptionMode.TAKEAWAY
        : ConsumptionMode.ON_SITE;
    return CartState(
      consumptionMode: mode,
      takeawayOptionId: json['takeawayOptionId'] as String? ??
          json['packagingOptionId'] as String?,
      takeawayFeeTickets: (json['takeawayFeeTickets'] as num?)?.toInt() ??
          (json['packagingExtra'] as num?)?.toInt() ??
          0,
      lines: [
        for (final item
            in (json['lines'] as List? ?? const []).whereType<Map>())
          CartLine.fromJson(Map<String, dynamic>.from(item)),
      ].where((line) => line.menuId != null || line.componentId != null).toList(),
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  static const _legacyKey = 'student_cart_v1';
  static const _sharedKey = 'student_cart_v2';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  String get _storageKey {
    final uid = ref.read(authRepositoryProvider).getCurrentUserId();
    if (uid == null || uid.isEmpty) return _sharedKey;
    return '${_sharedKey}_$uid';
  }

  @override
  CartState build() {
    ref.listen(authProvider, (previous, next) {
      if (next == AuthState.authenticated) {
        // Restore from disk after login / session restore (never wipe storage here).
        final stored = _readStored();
        if (stored.lines.isNotEmpty || state.lines.isEmpty) {
          state = stored;
        }
      } else if (previous == AuthState.authenticated) {
        // Hide cart in UI on logout; keep prefs until the user clears or checks out.
        state = const CartState();
      }
    });
    if (ref.read(authProvider) != AuthState.authenticated) {
      return const CartState();
    }
    return _readStored();
  }

  CartState _readStored() {
    final raw = _prefs.getString(_storageKey) ??
        _prefs.getString(_sharedKey) ??
        _prefs.getString(_legacyKey);
    if (raw == null || raw.isEmpty) return const CartState();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return CartState.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return const CartState();
  }

  Future<void> _persist() async {
    await _prefs.setString(_storageKey, jsonEncode(state.toJson()));
    // Drop legacy keys once we have a canonical user-scoped snapshot.
    await _prefs.remove(_legacyKey);
    if (_storageKey != _sharedKey) {
      await _prefs.remove(_sharedKey);
    }
  }

  bool add(CartLine line) {
    if (line.menuId == null && line.componentId == null) return false;
    if (state.vendorId != null && state.vendorId != line.vendorId) {
      return false;
    }
    final index = state.lines.indexWhere((item) => item.lineKey == line.lineKey);
    if (index < 0) {
      state = CartState(
        lines: [...state.lines, line],
        consumptionMode: state.consumptionMode,
        takeawayOptionId: state.takeawayOptionId,
        takeawayFeeTickets: state.takeawayFeeTickets,
      );
      _persist();
      return true;
    }
    final current = state.lines[index];
    final next = [...state.lines];
    next[index] = current.copyWith(quantity: current.quantity + line.quantity);
    state = CartState(
      lines: next,
      consumptionMode: state.consumptionMode,
      takeawayOptionId: state.takeawayOptionId,
      takeawayFeeTickets: state.takeawayFeeTickets,
    );
    _persist();
    return true;
  }

  void replaceWith(CartLine line) {
    state = CartState(
      lines: [line],
      consumptionMode: ConsumptionMode.ON_SITE,
    );
    _persist();
  }

  void setQuantityByKey(String lineKey, int quantity) {
    if (quantity <= 0) {
      state = CartState(
        lines: state.lines.where((item) => item.lineKey != lineKey).toList(),
        consumptionMode: state.consumptionMode,
        takeawayOptionId: state.takeawayOptionId,
        takeawayFeeTickets: state.takeawayFeeTickets,
      );
      _persist();
      return;
    }
    state = CartState(
      lines: state.lines
          .map(
            (item) => item.lineKey == lineKey
                ? item.copyWith(quantity: quantity)
                : item,
          )
          .toList(),
      consumptionMode: state.consumptionMode,
      takeawayOptionId: state.takeawayOptionId,
      takeawayFeeTickets: state.takeawayFeeTickets,
    );
    _persist();
  }

  void setConsumptionMode(ConsumptionMode mode) {
    if (mode == ConsumptionMode.ON_SITE) {
      state = CartState(
        lines: state.lines,
        consumptionMode: ConsumptionMode.ON_SITE,
      );
    } else {
      state = CartState(
        lines: state.lines,
        consumptionMode: ConsumptionMode.TAKEAWAY,
        takeawayOptionId: state.takeawayOptionId,
        takeawayFeeTickets: state.takeawayFeeTickets,
      );
    }
    _persist();
  }

  void setTakeawayOption({String? optionId, int fee = 0}) {
    state = CartState(
      lines: state.lines,
      consumptionMode: ConsumptionMode.TAKEAWAY,
      takeawayOptionId: optionId,
      takeawayFeeTickets: fee,
    );
    _persist();
  }

  /// Clears cart in memory and on disk (checkout success or user-confirmed empty).
  void clear() {
    state = const CartState();
    _prefs.remove(_storageKey);
    _prefs.remove(_sharedKey);
    _prefs.remove(_legacyKey);
  }

  void reorderFrom({
    required String vendorId,
    required String vendorName,
    required List<CartLine> lines,
  }) {
    if (lines.isEmpty) return;
    state = CartState(lines: lines);
    _persist();
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
