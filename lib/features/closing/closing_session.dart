import 'package:flutter/foundation.dart';

class ClosingSession extends ChangeNotifier {
  final shifts = <String>[];
  bool isClosed = false;

  void closeShift({required int stops, required int deliveries}) {
    shifts.add('Jornada ${shifts.length + 1} · $stops paradas · $deliveries entregas');
    isClosed = true;
    notifyListeners();
  }

  void reopen() {
    isClosed = false;
    notifyListeners();
  }

  void reset() {
    shifts.clear();
    isClosed = false;
    notifyListeners();
  }
}
