import '../../core/actions/screen_action_context.dart';
import '../../core/models/mockup_document.dart';

class DeliveryActions {
  static const _screens = {'M-03', 'M-04', 'M-10', 'M-11', 'M-21', 'A-11', 'A-12', 'M-20'};
  static bool supports(String id) => _screens.contains(id);

  static Future<void> handle(ScreenActionContext action, MockupElement element) async {
    final value = element.value.trim();
    final screenId = action.screen.id;

    if (screenId == 'M-10' && const {
      'Local cerrado',
      'Cliente rechaza el pedido',
      'Sin efectivo en venta de contado',
      'Dirección no localizada',
    }.contains(value)) {
      action.inputs['selection:M-10'] = value;
      return;
    }
    if (action.isEditable(element)) {
      await action.edit(element);
      return;
    }

    if (screenId == 'M-04' && value == 'Confirmar entrega') {
      final values = await action.askMany('Registrar entrega', ['Cliente', 'Importe recibido']);
      if (values == null) return;
      action.session.delivery.registerDelivery(values[0], values[1]);
      action.navigateTo('A-12');
      return;
    }
    if (screenId == 'M-11' && value == 'Registrar cobro') {
      final values = await action.askMany('Registrar cobro', ['Cliente', 'Importe recibido', 'Forma de pago']);
      if (values == null) return;
      action.session.delivery.registerPayment(values[0], values[1], values[2]);
      action.navigateTo('A-12');
      return;
    }
    if (screenId == 'M-10' && value == 'Registrar no entrega') {
      final reason = action.inputs['selection:M-10'];
      if (reason == null) {
        action.message('Selecciona el motivo de la no entrega.');
        return;
      }
      action.session.delivery.registerIncident('No entrega · $reason');
      action.navigateTo('M-01');
      return;
    }
    if (screenId == 'M-21' && value == 'Guardar auditoría') {
      final note = await action.ask('Guardar auditoría', 'Observaciones');
      if (note == null) return;
      action.session.delivery.registerIncident('Auditoría · $note');
      action.navigateTo('M-01');
      return;
    }
    if (screenId == 'M-20' && value == 'Enviar reporte') {
      final description = await action.ask('Reportar incidencia', 'Describe el problema');
      if (description == null) return;
      action.session.delivery.registerIncident(description);
      action.navigateTo('M-06');
      return;
    }

    const routes = <String, String>{
      'Continuar': 'M-04',
      'Escanear': 'A-11',
      'Atrás': 'M-03',
      'Ingresar clave': 'M-03',
      'Ver comprobante': 'M-04',
      'Siguiente parada': 'M-01',
      'Omitir': 'M-01',
    };
    final target = routes[value];
    if (target != null) action.navigateTo(target);
  }

  static Future<void> handleEmptyAction(ScreenActionContext action) async {
    action.navigateTo('M-01');
  }
}
