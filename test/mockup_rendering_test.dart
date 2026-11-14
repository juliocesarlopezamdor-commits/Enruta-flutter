import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enruta_transportistas/core/models/mockup_document.dart';
import 'package:enruta_transportistas/core/widgets/mockup_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('each of the 38 Drawio screens renders independently', (tester) async {
    final document = await tester.runAsync(MockupDocument.load);
    expect(document, isNotNull);

    for (final screen in document!.screens) {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: FittedBox(
              child: SizedBox(
                width: mockupWidth,
                height: mockupHeight,
                child: MockupDevice(
                  screen: screen,
                  populatedItems: const [],
                  onElementTap: (_) {},
                ),
              ),
            ),
          ),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: screen.id);
    }
  });
}
