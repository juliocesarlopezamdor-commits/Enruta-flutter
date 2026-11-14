# EnRuta · Transportistas

Aplicacion Flutter que renderiza las 38 pantallas de telefono del archivo `EnRuta-Mockups-App-Transportistas.drawio`. El archivo Drawio es un asset de ejecucion: textos, colores, coordenadas y dimensiones se leen desde el documento original.

## Ejecutar

Requiere Flutter 3.27 o posterior.

```sh
flutter pub get
flutter run
```

Para web: `flutter run -d chrome` o `flutter run -d web-server --web-port 8080`.

El boton de cuadrícula, fuera del lienzo del dispositivo, permite abrir cualquiera de las vistas para inspeccion. La navegación del mockup también conecta los flujos principales.

## Estructura

- `lib/core/models`: parser y modelos de marcos/celdas Drawio.
- `lib/core/widgets`: dispositivo, lienzo, ilustración y estados vacíos.
- `lib/core/session` y `lib/features`: estado y acciones independientes por dominio.
- `lib/app`: composición del workspace y despacho de acciones.

## Primer uso y aislamiento

La app inicia en Bienvenida. Rutas, inventario, pedidos, entregas, saldos, jornadas y notificaciones empiezan vacíos; los ejemplos que aparecen en los mockups se filtran del modo inicial. Los registros creados se mantienen en memoria y se eliminan al cerrar sesión. La lectura de cada vista, el render de celdas y las acciones de cada dominio se aíslan para que un error local no bloquee los demás flujos. Cámara, GPS, Bluetooth y sincronización de servidor son simulados.

## Validar

```sh
flutter analyze
flutter test
flutter build web
```