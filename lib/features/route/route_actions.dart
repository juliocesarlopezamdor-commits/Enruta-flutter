import '../../core/actions/screen_action_context.dart';
import '../../core/models/mockup_document.dart';

class RouteActions {
  static const _screens = {'M-18', 'M-09', 'M-01', 'M-02', 'M-19', 'M-08', 'A-10'};
  static bool supports(String id) => _screens.contains(id);

  static Future<void> handle(ScreenActionContext action, MockupElement element) async {
    final value = element.value.trim();
    if (action.isEditable(element)) {
      await action.edit(element);
      return;
    }

    if (action.screen.id == 'M-09' && value == 'Iniciar ruta' && action.session.route.stops.isEmpty) {
      action.message('Agrega una parada antes de iniciar la jornada.');
      action.navigateTo('M-01');
      return;
    }
    if (action.screen.id == 'M-02' && value == 'Registrar llegada') {
      final customer = action.session.route.stops.firstOrNull;
      if (customer == null) {
        action.message('Agrega una parada antes de registrar la llegada.');
        action.navigateTo('M-01');
      } else {
        action.session.route.markArrival(customer);
        action.navigateTo('M-19');
      }
      return;
    }
    if (action.screen.id == 'M-08' && value == 'Confirmar pedido') {
      if (action.session.route.orders.isEmpty) {
        action.message('Agrega al menos un producto al pedido.');
      } else {
        action.navigateTo('M-01');
      }
      return;
    }

    const routes = <String, String>{
      'Iniciar ruta': 'M-01',
      'Reportar': 'M-20',
      'Mapa': 'M-02',
      'Ruta': 'M-01',
      'Inventario': 'A-10',
      'Corte': 'M-05',
      'Ir a la siguiente parada': 'M-02',
      'Entregar pedido': 'M-03',
      'Cobrar': 'M-11',
      'No entregar': 'M-10',
      'Pedido programado': 'M-08',
    };
    final target = routes[value];
    if (target != null) action.navigateTo(target);
  }

  static Future<void> handleEmptyAction(ScreenActionContext action) async {
    switch (action.screen.id) {
      case 'M-01':
      case 'M-02':
      case 'M-09':
        final name = await action.ask('Agregar parada', 'Nombre del cliente');
        if (name != null) action.session.route.addStop(name);
      case 'M-18':
      case 'A-10':
        final values = await action.askMany('Registrar producto', ['Nombre del producto', 'Cantidad de piezas']);
        if (values != null) action.session.route.addInventoryItem(values[0], values[1]);
      case 'M-08':
      case 'A-15':
        final values = await action.askMany('Agregar al pedido', ['Producto', 'Cantidad']);
        if (values != null) action.session.route.addOrderItem(values[0], values[1]);
      case 'M-19':
      case 'M-03':
      case 'M-11':
      case 'M-21':
        action.navigateTo('M-01');
    }
  }
}
