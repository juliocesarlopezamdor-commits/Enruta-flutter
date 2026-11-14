import 'package:flutter/foundation.dart';

import '../../features/account/account_session.dart';
import '../../features/closing/closing_session.dart';
import '../../features/delivery/delivery_session.dart';
import '../../features/route/route_session.dart';

class AppSession extends ChangeNotifier {
  final route = RouteSession();
  final delivery = DeliverySession();
  final closing = ClosingSession();
  final account = AccountSession();

  AppSession() {
    route.addListener(_notify);
    delivery.addListener(_notify);
    closing.addListener(_notify);
    account.addListener(_notify);
  }

  void _notify() => notifyListeners();

  void resetForSignOut() {
    route.reset();
    delivery.reset();
    closing.reset();
    account.reset();
  }

  @override
  void dispose() {
    route.dispose();
    delivery.dispose();
    closing.dispose();
    account.dispose();
    super.dispose();
  }
}
