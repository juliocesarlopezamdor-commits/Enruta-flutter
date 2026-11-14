import 'package:flutter_test/flutter_test.dart';

import 'package:enruta_transportistas/app/enruta_app.dart';
import 'package:enruta_transportistas/core/models/mockup_document.dart';

void main() {
  testWidgets('renders the Drawio welcome and starts the route empty', (tester) async {
    final document = await tester.runAsync(MockupDocument.load);
    await tester.pumpWidget(EnRutaApp(document: document));
    await tester.pumpAndSettle();

    expect(find.text('Tu ruta, incluso sin señal'), findsOneWidget);
    expect(find.text('distribuidora-norte'), findsNothing);
    await tester.tap(find.text('Ya tengo cuenta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Tu ruta está vacía'), findsOneWidget);
    expect(find.text('Abarrotes Doña Mari'), findsNothing);
  });
}
