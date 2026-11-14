import 'package:flutter/foundation.dart';

class RouteSession extends ChangeNotifier {
  final stops = <String>[];
  final inventory = <String>[];
  final orders = <String>[];
  String? lastArrival;

  void addStop(String name) {
    final value = name.trim();
    if (value.isEmpty) throw ArgumentError('Escribe el nombre del cliente.');
    stops.add(value);
    notifyListeners();
  }

  void addInventoryItem(String name, String quantity) {
    final value = name.trim();
    if (value.isEmpty || quantity.trim().isEmpty) {
      throw ArgumentError('Completa el producto y la cantidad.');
    }
    inventory.add('$value · $quantity piezas');
    notifyListeners();
  }

  void addOrderItem(String name, String quantity) {
    final value = name.trim();
    if (value.isEmpty || quantity.trim().isEmpty) {
      throw ArgumentError('Completa el producto y la cantidad.');
    }
    orders.add('$value · $quantity piezas');
    notifyListeners();
  }

  void markArrival(String customer) {
    lastArrival = customer;
    notifyListeners();
  }

  void reset() {
    stops.clear();
    inventory.clear();
    orders.clear();
    lastArrival = null;
    notifyListeners();
  }
}
