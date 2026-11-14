import 'package:flutter/foundation.dart';

class AccountSession extends ChangeNotifier {
  String name = '';
  String email = '';
  String phone = '';
  bool syncOnOpen = true;
  bool photosOnWifi = true;
  bool locationEnabled = false;
  bool cameraEnabled = false;
  bool notificationsEnabled = false;
  final notifications = <String>[];

  void updatePreference(String key, bool value) {
    switch (key) {
      case 'syncOnOpen':
        syncOnOpen = value;
      case 'photosOnWifi':
        photosOnWifi = value;
      case 'locationEnabled':
        locationEnabled = value;
      case 'cameraEnabled':
        cameraEnabled = value;
      case 'notificationsEnabled':
        notificationsEnabled = value;
      default:
        throw ArgumentError.value(key, 'key', 'Preferencia desconocida');
    }
    notifyListeners();
  }

  void updateProfile({required String name, required String email, required String phone}) {
    this.name = name.trim();
    this.email = email.trim();
    this.phone = phone.trim();
    notifyListeners();
  }

  void reset() {
    name = '';
    email = '';
    phone = '';
    syncOnOpen = true;
    photosOnWifi = true;
    locationEnabled = false;
    cameraEnabled = false;
    notificationsEnabled = false;
    notifications.clear();
    notifyListeners();
  }
}
