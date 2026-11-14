import '../../core/actions/screen_action_context.dart';
import '../../core/models/mockup_document.dart';

class BusinessActions {
  static const _screens = {'M-06', 'A-15', 'A-16', 'A-17', 'A-18', 'A-19', 'A-20'};
  static bool supports(String id) => _screens.contains(id);

  static Future<void> handleEmptyAction(ScreenActionContext action) async {
    if (action.screen.id != 'A-15') return;
    final values = await action.askMany('Agregar al reabasto', ['Producto', 'Cantidad']);
    if (values != null) action.session.route.addOrderItem(values[0], values[1]);
  }

  static Future<void> handle(ScreenActionContext action, MockupElement element) async {
    final value = element.value.trim();
    final screenId = action.screen.id;

    if (action.isEditable(element)) {
      await action.edit(element);
      return;
    }
    if (screenId == 'A-18' && _togglePreference(action, value)) return;
    if (screenId == 'A-17' && value == 'Guardar cambios') {
      final values = action.inputs.values.where((item) => item.isNotEmpty).toList();
      if (values.isEmpty) {
        action.message('Completa tu perfil antes de guardar.');
      } else {
        action.session.account.updateProfile(
          name: values.first,
          email: values.length > 1 ? values[1] : '',
          phone: values.length > 2 ? values[2] : '',
        );
        action.message('Perfil guardado en este dispositivo.');
      }
      return;
    }
    if (screenId == 'A-20' && value == 'Contactar a mi supervisor') {
      action.message('Solicitud de contacto registrada.');
      return;
    }
    if (screenId == 'A-20' && value == 'Reportar un problema técnico') {
      action.navigateTo('M-20');
      return;
    }
    if (screenId == 'A-18' && value == 'Buscar') {
      action.message('No se encontraron impresoras disponibles.');
      return;
    }

    const routes = <String, String>{
      'Entregas': 'M-06',
      'Pedir': 'A-15',
      'Mi cuenta': 'A-16',
      'Ruta': 'M-01',
      'Mapa': 'M-02',
      'Inventario': 'A-10',
      'Corte': 'M-05',
      'Cambiar PIN': 'A-05',
      'Cerrar sesión': 'A-23',
    };
    final target = routes[value];
    if (target != null) action.navigateTo(target);
  }

  static bool _togglePreference(ScreenActionContext action, String label) {
    final key = switch (label) {
      'Sincronizar al abrir la app' => 'syncOnOpen',
      'Fotos solo con buena señal' => 'photosOnWifi',
      'Rastreo de posición' => 'locationEnabled',
      _ => null,
    };
    if (key == null) return false;
    final current = switch (key) {
      'syncOnOpen' => action.session.account.syncOnOpen,
      'photosOnWifi' => action.session.account.photosOnWifi,
      _ => action.session.account.locationEnabled,
    };
    action.session.account.updatePreference(key, !current);
    return true;
  }
}
