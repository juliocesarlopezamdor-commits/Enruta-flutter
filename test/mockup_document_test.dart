import 'package:flutter_test/flutter_test.dart';
import 'package:enruta_transportistas/core/models/mockup_document.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reads every phone frame directly from the Drawio source', () async {
    final mockups = await MockupDocument.load();

    expect(mockups.screens, hasLength(38));
    expect(mockups.screens.first.id, 'A-01');
    expect(mockups.screens.first.title, 'A-01 · Splash y carga de configuración');
    expect(mockups.screens.firstWhere((screen) => screen.id == 'A-02').elements, isNotEmpty);
  });
}
