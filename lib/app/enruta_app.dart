import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/models/mockup_document.dart';
import '../core/session/app_session.dart';
import '../core/widgets/mockup_device.dart';
import '../core/widgets/screen_error_boundary.dart';
import 'screen_actions.dart';
import 'screen_catalog.dart';

const _navy = Color(0xFF0B2F52);
const _pageBackground = Color(0xFFE5E8EA);

class EnRutaApp extends StatefulWidget {
  const EnRutaApp({super.key, this.document});

  final MockupDocument? document;

  @override
  State<EnRutaApp> createState() => _EnRutaAppState();
}

class _EnRutaAppState extends State<EnRutaApp> {
  late final AppSession _session = AppSession();
  late final ErrorWidgetBuilder _previousErrorBuilder;
  late Future<MockupDocument> _document;

  @override
  void initState() {
    super.initState();
    _previousErrorBuilder = installScreenErrorBuilder();
    _document = widget.document == null
        ? MockupDocument.load()
        : Future.value(widget.document);
  }

  void _retryLoad() {
    setState(() {
      _document = widget.document == null
          ? MockupDocument.load()
          : Future.value(widget.document);
    });
  }

  @override
  void dispose() {
    ErrorWidget.builder = _previousErrorBuilder;
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EnRuta · Transportistas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: _pageBackground,
          colorScheme: ColorScheme.fromSeed(seedColor: _navy).copyWith(
            primary: _navy,
            secondary: const Color(0xFFE8B000),
            surface: const Color(0xFFF2F5F7),
          ),
          appBarTheme: const AppBarTheme(backgroundColor: _pageBackground, foregroundColor: _navy),
        ),
        home: FutureBuilder<MockupDocument>(
          future: _document,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _LoadFailure(onRetry: _retryLoad);
            }
            if (!snapshot.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return _MockupWorkspace(document: snapshot.data!, session: _session);
          },
        ),
      );
}

class _MockupWorkspace extends StatefulWidget {
  const _MockupWorkspace({required this.document, required this.session});
  final MockupDocument document;
  final AppSession session;

  @override
  State<_MockupWorkspace> createState() => _MockupWorkspaceState();
}

class _MockupWorkspaceState extends State<_MockupWorkspace> {
  String _currentId = 'A-02';
  final _inputs = <String, String>{};

  MockupScreen get _current => widget.document.screens.firstWhere((screen) => screen.id == _currentId);

  void _navigate(String id) {
    if (!widget.document.screens.any((screen) => screen.id == id)) return;
    setState(() => _currentId = id);
  }

  Future<void> _openCatalog() => showScreenCatalog(
        context,
        widget.document.screens,
        _navigate,
      );

  Future<void> _tapElement(MockupElement element) async {
    final actions = ScreenActions(
      context: context,
      screen: _current,
      session: widget.session,
      inputs: _inputs,
      navigate: _navigate,
    );
    await actions.onElement(element);
    if (mounted) setState(() {});
  }

  Future<void> _tapEmptyAction() async {
    final actions = ScreenActions(
      context: context,
      screen: _current,
      session: widget.session,
      inputs: _inputs,
      navigate: _navigate,
    );
    await actions.onEmptyAction();
  }

  List<String> _itemsFor(String screenId) => switch (screenId) {
        'M-01' || 'M-02' || 'M-19' => widget.session.route.stops,
        'M-18' || 'A-10' => widget.session.route.inventory,
        'M-08' || 'A-15' => widget.session.route.orders,
        'A-12' || 'M-06' => widget.session.delivery.deliveries,
        'M-20' => widget.session.delivery.incidents,
        'A-13' || 'A-14' => widget.session.closing.shifts,
        'A-19' => widget.session.account.notifications,
        _ => const [],
      };

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.session,
        builder: (context, _) => Scaffold(
          backgroundColor: _pageBackground,
          body: SafeArea(
            child: Column(children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
                  child: IconButton(
                    tooltip: 'Abrir las 38 vistas del diagrama',
                    onPressed: _openCatalog,
                    icon: const Icon(Icons.grid_view_rounded),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  final width = math.min(constraints.maxWidth, constraints.maxHeight * mockupWidth / mockupHeight);
                  final height = width * mockupHeight / mockupWidth;
                  return Center(
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: mockupWidth,
                          height: mockupHeight,
                            child: MockupDevice(
                              screen: _current,
                              populatedItems: _itemsFor(_current.id),
                              valueFor: (element) => _inputs[element.id],
                              onElementTap: _tapElement,
                              onEmptyAction: _tapEmptyAction,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ]),
          ),
        ),
      );
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.broken_image_outlined, size: 42, color: _navy),
            const SizedBox(height: 12),
            const Text('No se pudo cargar el archivo de vistas.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ]),
        ),
      );
}
