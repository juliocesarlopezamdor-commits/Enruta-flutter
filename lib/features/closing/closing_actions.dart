import '../../core/actions/screen_action_context.dart';
import '../../core/models/mockup_document.dart';

class ClosingActions {
  static const _screens = {'M-05', 'R-114A', 'M-12', 'A-13', 'R-114B', 'A-14'};
  static bool supports(String id) => _screens.contains(id);

  static Future<void> handle(ScreenActionContext action, MockupElement element) async {
    final value = element.value.trim();
    final screenId = action.screen.id;

    if (screenId == 'M-05' && value == 'Enviar a aprobación') {
      _close(action);
      return;
    }
    if (screenId == 'M-12' && value == 'Sincronizar ahora') {
      action.message('No hay operaciones pendientes.');
      return;
    }

    const routes = <String, String>{
      'Ver estado de sincronización': 'M-12',
      'Sincronizar ahora': 'M-12',
      'Ver historial': 'A-14',
      'Terminar': 'M-01',
      'Ver corte': 'M-05',
      'Ir al historial': 'A-14',
      'Ruta': 'M-01',
      'Mapa': 'M-02',
      'Inventario': 'A-10',
      'Corte': 'M-05',
    };
    final target = routes[value];
    if (target != null) action.navigateTo(target);
  }

  static Future<void> handleEmptyAction(ScreenActionContext action) async {
    if (action.screen.id == 'M-05') _close(action);
  }

  static void _close(ScreenActionContext action) {
    action.session.closing.closeShift(
      stops: action.session.route.stops.length,
      deliveries: action.session.delivery.deliveries.length,
    );
    action.navigateTo('A-13');
  }
}
