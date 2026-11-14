import 'package:flutter/foundation.dart';

class DeliverySession extends ChangeNotifier {
  final deliveries = <String>[];
  final incidents = <String>[];
  final payments = <String>[];

  void registerDelivery(String customer, String amount) {
    final name = customer.trim();
    final value = amount.trim();
    if (name.isEmpty || value.isEmpty) {
      throw ArgumentError('Completa cliente e importe antes de guardar.');
    }
    deliveries.add('$name · \$$value');
    notifyListeners();
  }

  void registerPayment(String customer, String amount, String method) {
    final name = customer.trim();
    final value = amount.trim();
    if (name.isEmpty || value.isEmpty || method.isEmpty) {
      throw ArgumentError('Completa cliente, importe y forma de pago.');
    }
    payments.add('$name · \$$value · $method');
    notifyListeners();
  }

  void registerIncident(String description) {
    final value = description.trim();
    if (value.isEmpty) throw ArgumentError('Escribe el motivo de la incidencia.');
    incidents.add(value);
    notifyListeners();
  }

  void reset() {
    deliveries.clear();
    incidents.clear();
    payments.clear();
    notifyListeners();
  }
}
