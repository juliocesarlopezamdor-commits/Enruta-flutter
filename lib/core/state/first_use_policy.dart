import '../models/mockup_document.dart';

class EmptyPanelSpec {
  const EmptyPanelSpec({
    required this.top,
    required this.height,
    required this.title,
    required this.detail,
    this.action,
  });

  final double top;
  final double height;
  final String title;
  final String detail;
  final String? action;
}

class FirstUsePolicy {
  static const _hiddenExamples = <String, Set<String>>{
    'A-03': {'distribuidora-norte', 'operador@empresa', '● ● ● ●', 'Modo sin conexión disponible · último dato 06:10'},
    'A-04': {'DN-8F3K-2026', 'Luis Martínez Pérez', '55 1234 5678', 'luis@distribuidoranorte.mx', '✓'},
    'A-05': {'●'},
    'A-07': {'Luis Martínez', 'Distribuidora Norte', 'Hoy 09:12', 'Pendiente'},
    'A-08': {'operador@empresa'},
    'M-18': {'Camioneta 3.5T · ABC-123'},
    'M-09': {'Camioneta 3.5T · ABC-123'},
    'M-01': {
      'Ruta R-114', 'Miércoles 16 de septiembre', '8 / 32',
      'Sin conexión · 4 operaciones por enviar',
    },
    'M-02': {
      'Quedan 24 paradas · 18.4 km', '7', '8', '9', '10', '11', '12',
      'Parada 9', 'Abarrotes Doña Mari', 'Av. Juárez 210 · atiende hasta las 20:00', '4 min',
    },
    'M-19': {
      'Abarrotes Doña Mari', 'Av. Juárez 210 · visita L–M–V', 'Sin conexión · última sincronización 09:58',
      '\$1,240', '1 doc. vencido', '\$5,000', 'Disponible \$3,760', '12 cajas · 6 SKU',
      '\$3,180', 'Levantado por preventa el 14 sep', '12 sep', 'Completo', 'Entregado',
      '10 sep', 'Faltó 1 caja', 'Parcial',
    },
    'M-08': {'Abarrotes Doña Mari · Mayoreo A', 'Sin conexión · el pedido se enviará al recuperar señal', '\$3,760 de \$5,000'},
    'A-10': {'Camioneta 3.5T · ABC-123'},
    'M-03': {'Abarrotes Doña Mari · 6 productos'},
    'M-04': {'Folio F-8842 · \$2,946.50', 'María Rodríguez', '12 m', '16 sep 2026 · 10:18:44 · dispositivo TEC-0442'},
    'M-10': {'Papelería Sol · parada 8', 'Elegido', 'Obligatoria'},
    'M-11': {'Abarrotes Doña Mari', '1 vencido', '\$1,240', '✓ F-20931 · vencida hace 12 días', '\$1,820.00'},
    'M-21': {'Abarrotes Doña Mari', 'Foto obligatoria'},
    'A-11': {'Pan de caja grande · 7501234567890', 'Se agregará 1 pieza al pedido'},
    'A-12': {
      'Folio F-8842', 'María Rodríguez', '\$2,946.50', '\$1,820.00', '\$2,366.50',
      'Parada 9 de 32 · siguiente: Minisúper El Roble',
    },
    'M-05': {'R-114 · 16 sep · Luis Martínez', '\$48,210', '30/32', '\$41,880', '\$41,650', '\$230.00'},
    'M-12': {
      'Última: hoy 09:58 · configuración v14', 'En línea', '17 operaciones',
      'Enviando… 7 de 17', '3 enviadas', '2 en cola', '12 esperan buena señal',
    },
    'A-13': {'R-114 · 16 sep', 'Luis', '30 de 32', '\$48,210', '\$41,650', '31 cajas', 'Jorge Salas'},
    'M-06': {'Abarrotes Doña Mari', 'Llega hoy a las 10:15', 'Ruta R-114 · reparte Luis M.', '12 cajas · 6 productos', '\$3,180'},
    'M-20': {'Entrega F-8842 · hoy 10:18', 'María Rodríguez', 'Pedido de 12 cajas · \$3,180', 'Elegido'},
    'A-15': {'Fuera de tu frecuencia habitual'},
    'A-17': {
      'LM', 'Luis Martínez', 'Repartidor · R-114 · Centro Veracruz',
      'luis@distribuidoranorte.mx', 'TEC-0442', '2.5.1', 'v14 · hoy 09:58', 'Repartidor',
    },
    'A-19': {'3 nuevas', 'Ruta modificada', 'Configuración v15 disponible', 'Aprobación recibida', 'Descuento rechazado', 'Ruta publicada', 'Ayer'},
    'A-23': {'Tienes 4 operaciones sin enviar. Se conservarán en el dispositivo y se enviarán'},
  };

  static const _emptyPanels = <String, EmptyPanelSpec>{
    'M-18': EmptyPanelSpec(top: 96, height: 440, title: 'Sin carga registrada', detail: 'Agrega productos cuando recibas la carga.', action: 'Registrar producto'),
    'M-09': EmptyPanelSpec(top: 100, height: 420, title: 'Jornada sin iniciar', detail: 'Agrega las paradas y confirma la carga para comenzar.', action: 'Agregar parada'),
    'M-01': EmptyPanelSpec(top: 112, height: 398, title: 'Tu ruta está vacía', detail: 'No hay paradas asignadas para esta jornada.', action: 'Agregar parada'),
    'M-02': EmptyPanelSpec(top: 110, height: 412, title: 'Sin ruta asignada', detail: 'El mapa se mostrará cuando agregues una parada.', action: 'Agregar parada'),
    'M-19': EmptyPanelSpec(top: 92, height: 444, title: 'Sin cliente seleccionado', detail: 'Elige una parada de la ruta para consultar el detalle.', action: 'Ver ruta'),
    'M-08': EmptyPanelSpec(top: 102, height: 430, title: 'Pedido vacío', detail: 'Agrega productos para preparar una preventa.', action: 'Agregar producto'),
    'A-10': EmptyPanelSpec(top: 92, height: 448, title: 'Inventario vacío', detail: 'Los productos aparecerán al registrar una carga.', action: 'Agregar producto'),
    'M-03': EmptyPanelSpec(top: 92, height: 434, title: 'Sin productos por entregar', detail: 'Selecciona un cliente y agrega productos a la entrega.', action: 'Ver ruta'),
    'M-04': EmptyPanelSpec(top: 112, height: 405, title: 'Evidencia pendiente', detail: 'La firma y las fotografías se agregarán al completar una entrega.'),
    'M-10': EmptyPanelSpec(top: 104, height: 414, title: 'Sin entrega seleccionada', detail: 'Selecciona una parada para indicar el motivo de no entrega.'),
    'M-11': EmptyPanelSpec(top: 96, height: 428, title: 'Sin saldo por cobrar', detail: 'El cobro estará disponible al seleccionar un cliente.', action: 'Ver ruta'),
    'M-21': EmptyPanelSpec(top: 102, height: 418, title: 'Auditoría sin iniciar', detail: 'Selecciona una parada para revisar la exhibición.', action: 'Ver ruta'),
    'A-12': EmptyPanelSpec(top: 118, height: 386, title: 'Sin entregas registradas', detail: 'El comprobante aparecerá al confirmar una entrega.'),
    'M-05': EmptyPanelSpec(top: 96, height: 438, title: 'Sin jornada para cerrar', detail: 'El corte se calculará cuando completes una jornada.', action: 'Cerrar jornada'),
    'M-12': EmptyPanelSpec(top: 108, height: 416, title: 'Todo está sincronizado', detail: 'No hay operaciones pendientes de envío.'),
    'A-13': EmptyPanelSpec(top: 128, height: 380, title: 'Sin jornadas cerradas', detail: 'Al terminar una jornada, su resumen aparecerá aquí.'),
    'A-14': EmptyPanelSpec(top: 112, height: 414, title: 'Sin jornadas anteriores', detail: 'El historial aparecerá después de cerrar una jornada.'),
    'M-06': EmptyPanelSpec(top: 114, height: 410, title: 'Todavía no hay entregas', detail: 'Las entregas del negocio aparecerán aquí.'),
    'M-20': EmptyPanelSpec(top: 116, height: 408, title: 'Sin incidencias', detail: 'Los reportes enviados aparecerán aquí.'),
    'A-15': EmptyPanelSpec(top: 118, height: 398, title: 'Solicitud vacía', detail: 'Agrega productos para pedir un reabasto.', action: 'Agregar producto'),
    'A-16': EmptyPanelSpec(top: 132, height: 382, title: 'Cuenta sin movimientos', detail: 'Los saldos y comprobantes aparecerán al sincronizar.'),
    'A-19': EmptyPanelSpec(top: 112, height: 416, title: 'No tienes notificaciones', detail: 'Los avisos de ruta y aprobaciones aparecerán aquí.'),
  };

  static EmptyPanelSpec? panelFor(String screenId) => _emptyPanels[screenId];

  static bool coveredByEmptyPanel(MockupScreen screen, MockupElement element) {
    final panel = panelFor(screen.id);
    if (panel == null) return false;
    return element.x >= 14 &&
        element.x + element.width <= mockupWidth - 14 &&
        element.y >= panel.top &&
        element.y + element.height <= panel.top + panel.height;
  }

  static bool editableField(MockupScreen screen, MockupElement element) =>
      hideExample(screen, element) ||
      (screen.id == 'A-06' && element.y >= 108 && element.y < 145 && element.value.isEmpty);

  static bool hideExample(MockupScreen screen, MockupElement element) {
    if (_hiddenExamples[screen.id]?.contains(element.value) ?? false) return true;
    if (screen.id == 'A-06' && element.y >= 108 && element.y < 145 && RegExp(r'^\d$').hasMatch(element.value)) {
      return true;
    }
    if (screen.id == 'A-17' && element.value == 'LM') return true;
    return false;
  }
}
