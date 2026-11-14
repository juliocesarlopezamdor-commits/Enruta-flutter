import 'package:flutter_test/flutter_test.dart';
import 'package:enruta_transportistas/core/session/app_session.dart';

void main() {
  test('an invalid delivery does not damage the route session', () {
    final session = AppSession();
    addTearDown(session.dispose);

    expect(session.route.stops, isEmpty);
    expect(session.route.inventory, isEmpty);
    expect(() => session.delivery.registerDelivery('', ''), throwsArgumentError);
    expect(session.delivery.deliveries, isEmpty);
    expect(session.route.stops, isEmpty);

    session.route.addStop('Cliente de prueba');
    expect(session.route.stops, ['Cliente de prueba']);
    expect(session.delivery.deliveries, isEmpty);
  });

  test('each session starts empty and sign out resets all domains', () {
    final session = AppSession();
    addTearDown(session.dispose);

    session.route.addStop('Cliente de prueba');
    session.route.addInventoryItem('Producto', '2');
    session.delivery.registerDelivery('Cliente de prueba', '120');
    session.closing.closeShift(stops: 1, deliveries: 1);
    session.resetForSignOut();

    expect(session.route.stops, isEmpty);
    expect(session.route.inventory, isEmpty);
    expect(session.delivery.deliveries, isEmpty);
    expect(session.closing.shifts, isEmpty);
    expect(session.account.name, isEmpty);
  });
}
