import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_provider.dart';
import '../../auth/data/auth_provider.dart';

class CartComponent {
  final String componentId;
  final String name;
  final int unitPriceTickets;
  final int quantity;

  const CartComponent({
    required this.componentId,
    required this.name,
    required this.unitPriceTickets,
    required this.quantity,
  });

  int get lineTotal => unitPriceTickets * quantity;

  Map<String, dynamic> toOrderJson() => {
        'componentId': componentId,
        'quantity': quantity,
      };

  Map<String, dynamic> toJson() => {
        'componentId': componentId,
        'name': name,
        'unitPriceTickets': unitPriceTickets,
        'quantity': quantity,
      };

  factory CartComponent.fromJson(Map<String, dynamic> json) => CartComponent(
        componentId: json['componentId'] as String? ?? '',
        name: json['name'] as String? ?? 'Extra',
        unitPriceTickets: (json['unitPriceTickets'] as num?)?.toInt() ?? 0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      );
}

class CartLine {
  final String vendorId;
  final String vendorName;
  final String menuItemId;
  final String name;
  final int priceTickets;
  final int quantity;
  final String? imageUrl;
  final List<CartComponent> components;

  const CartLine({
    required this.vendorId,
    required this.vendorName,
    required this.menuItemId,
    required this.name,
    required this.priceTickets,
    required this.quantity,
    this.imageUrl,
    this.components = const [],
  });

  String get lineKey {
    final extras = components
        .map((item) => '${item.componentId}:${item.quantity}')
        .join(',');
    return '$menuItemId|$extras';
  }

  int get extrasTickets =>
      components.fold(0, (sum, item) => sum + item.lineTotal);

  int get unitTotal => priceTickets + extrasTickets;

  int get lineTotal => unitTotal * quantity;

  CartLine copyWith({int? quantity}) => CartLine(
        vendorId: vendorId,
        vendorName: vendorName,
        menuItemId: menuItemId,
        name: name,
        priceTickets: priceTickets,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl,
        components: components,
      );

  Map<String, dynamic> toOrderJson() => {
        'menuItemId': menuItemId,
        'quantity': quantity,
        if (components.isNotEmpty)
          'components': [
            for (final item in components) item.toOrderJson(),
          ],
      };

  Map<String, dynamic> toJson() => {
        'vendorId': vendorId,
        'vendorName': vendorName,
        'menuItemId': menuItemId,
        'name': name,
        'priceTickets': priceTickets,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'components': [for (final item in components) item.toJson()],
      };

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        vendorId: json['vendorId'] as String? ?? '',
        vendorName: json['vendorName'] as String? ?? 'Cantine',
        menuItemId: json['menuItemId'] as String? ?? '',
        name: json['name'] as String? ?? 'Plat',
        priceTickets: (json['priceTickets'] as num?)?.toInt() ?? 0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
        imageUrl: json['imageUrl'] as String?,
        components: [
          for (final item in (json['components'] as List? ?? const [])
              .whereType<Map>())
            CartComponent.fromJson(Map<String, dynamic>.from(item)),
        ],
      );
}

class CartState {
  final List<CartLine> lines;
  final String? packagingOptionId;
  final int packagingExtra;

  const CartState({
    this.lines = const [],
    this.packagingOptionId,
    this.packagingExtra = 0,
  });

  String? get vendorId => lines.isEmpty ? null : lines.first.vendorId;

  String get vendorName => lines.isEmpty ? '' : lines.first.vendorName;

  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);

  int get itemsTickets => lines.fold(0, (sum, line) => sum + line.lineTotal);

  int get totalTickets => itemsTickets + packagingExtra;

  bool get isEmpty => lines.isEmpty;

  Map<String, dynamic> toJson() => {
        'packagingOptionId': packagingOptionId,
        'packagingExtra': packagingExtra,
        'lines': [for (final line in lines) line.toJson()],
      };

  factory CartState.fromJson(Map<String, dynamic> json) => CartState(
        packagingOptionId: json['packagingOptionId'] as String?,
        packagingExtra: (json['packagingExtra'] as num?)?.toInt() ?? 0,
        lines: [
          for (final item
              in (json['lines'] as List? ?? const []).whereType<Map>())
            CartLine.fromJson(Map<String, dynamic>.from(item)),
        ],
      );
}

class CartNotifier extends Notifier<CartState> {
  static const _storageKey = 'student_cart_v1';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  CartState build() {
    ref.listen(authProvider, (previous, next) {
      if (next != AuthState.authenticated) {
        clear();
      }
    });
    Future.microtask(_hydrate);
    return const CartState();
  }

  Future<void> _hydrate() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map &&
          ref.read(authProvider) == AuthState.authenticated) {
        state = CartState.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    await _prefs.setString(_storageKey, jsonEncode(state.toJson()));
  }

  bool add(CartLine line) {
    if (state.vendorId != null && state.vendorId != line.vendorId) {
      return false;
    }
    final index = state.lines.indexWhere((item) => item.lineKey == line.lineKey);
    if (index < 0) {
      state = CartState(
        lines: [...state.lines, line],
        packagingOptionId: state.packagingOptionId,
        packagingExtra: state.packagingExtra,
      );
      _persist();
      return true;
    }
    final current = state.lines[index];
    final next = [...state.lines];
    next[index] = current.copyWith(quantity: current.quantity + line.quantity);
    state = CartState(
      lines: next,
      packagingOptionId: state.packagingOptionId,
      packagingExtra: state.packagingExtra,
    );
    _persist();
    return true;
  }

  void replaceWith(CartLine line) {
    state = CartState(lines: [line]);
    _persist();
  }

  void setQuantityByKey(String lineKey, int quantity) {
    if (quantity <= 0) {
      state = CartState(
        lines: state.lines.where((item) => item.lineKey != lineKey).toList(),
        packagingOptionId: state.packagingOptionId,
        packagingExtra: state.packagingExtra,
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
      packagingOptionId: state.packagingOptionId,
      packagingExtra: state.packagingExtra,
    );
    _persist();
  }

  void setQuantity(String menuItemId, int quantity) {
    final match = state.lines.where((item) => item.menuItemId == menuItemId);
    if (match.isEmpty) return;
    setQuantityByKey(match.first.lineKey, quantity);
  }

  void setPackaging({String? optionId, int extra = 0}) {
    state = CartState(
      lines: state.lines,
      packagingOptionId: optionId,
      packagingExtra: extra,
    );
    _persist();
  }

  void clear() {
    state = const CartState();
    _prefs.remove(_storageKey);
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
