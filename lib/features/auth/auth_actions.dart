import '../../core/actions/screen_action_context.dart';
import '../../core/models/mockup_document.dart';

class AuthActions {
  static const _screens = {'A-01', 'A-02', 'A-03', 'A-04', 'A-05', 'A-06', 'A-07', 'A-08', 'A-09', 'A-21', 'A-22', 'A-23'};

  static bool supports(String id) => _screens.contains(id);

  static Future<void> handle(ScreenActionContext action, MockupElement element) async {
    final value = element.value.trim();
    if (action.screen.id == 'A-09') {
      final key = switch (value) {
        'Ubicación' => 'locationEnabled',
        'Cámara' => 'cameraEnabled',
        'Notificaciones' => 'notificationsEnabled',
        _ => null,
      };
      if (key != null) {
        final current = switch (key) {
          'locationEnabled' => action.session.account.locationEnabled,
          'cameraEnabled' => action.session.account.cameraEnabled,
          _ => action.session.account.notificationsEnabled,
        };
        action.session.account.updatePreference(key, !current);
        return;
      }
    }
    if (action.isEditable(element)) {
      await action.edit(element);
      return;
    }

    const routes = <String, String>{
      'Continuar': 'A-02',
      'Comenzar': 'A-03',
      'Ya tengo cuenta': 'A-03',
      'Entrar': 'M-01',
      'Crear cuenta': 'A-04',
      '¿Olvidaste tu PIN?': 'A-08',
      'Atrás': 'A-03',
      'Guardar PIN': 'A-06',
      'Verificar': 'A-07',
      'Actualizar estado': 'A-03',
      'Enviar código': 'A-06',
      'Volver al acceso': 'A-03',
      'Continuar con permisos': 'M-01',
      'Actualizar ahora': 'A-02',
      'Contactar al administrador': 'A-20',
      'Cancelar': 'A-17',
    };
    final target = routes[value];
    if (target == null) return;
    if (action.screen.id == 'A-23' && value == 'Cerrar sesión') {
      action.session.resetForSignOut();
      action.navigateTo('A-02');
      return;
    }
    action.navigateTo(target);
  }
}
