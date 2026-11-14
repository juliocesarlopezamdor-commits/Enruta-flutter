import 'package:flutter/material.dart';

import '../models/mockup_document.dart';
import '../session/app_session.dart';
import '../state/first_use_policy.dart';

class ScreenActionContext {
  const ScreenActionContext({
    required this.context,
    required this.screen,
    required this.session,
    required this.inputs,
    required this.navigate,
  });

  final BuildContext context;
  final MockupScreen screen;
  final AppSession session;
  final Map<String, String> inputs;
  final ValueChanged<String> navigate;

  Future<void> isolate(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (error) {
      message('$error');
    }
  }

  Future<void> run(Future<void> Function() operation) => isolate(operation);

  void message(String text) {
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> edit(MockupElement element, {String? label}) async {
    final controller = TextEditingController(text: inputs[element.id] ?? '');
    final prompt = label ?? fieldLabel(element);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(prompt),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: screen.id == 'A-05' || (screen.id == 'A-03' && element.value.contains('●')),
          decoration: InputDecoration(labelText: prompt),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
    controller.dispose();
    if (value != null) inputs[element.id] = value;
  }

  bool isEditable(MockupElement element) => FirstUsePolicy.editableField(screen, element);

  String fieldLabel(MockupElement element) {
    if (element.value.contains('@')) return 'Correo electrónico';
    if (element.value.contains('●') || screen.id == 'A-05' || screen.id == 'A-06') return 'Código o PIN';
    if (element.value.startsWith('55 ')) return 'Teléfono celular';
    if (element.value.startsWith('DN-')) return 'Código de invitación';
    if (screen.id == 'A-17') return 'Dato del perfil';
    return 'Escribe un valor';
  }

  Future<String?> ask(String title, String label) async {
    final result = await askMany(title, [label]);
    return result?.first;
  }

  Future<List<String>?> askMany(String title, List<String> labels) async {
    final controllers = labels.map((_) => TextEditingController()).toList();
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          for (var index = 0; index < labels.length; index++) ...[
            if (index > 0) const SizedBox(height: 12),
            TextField(controller: controllers[index], decoration: InputDecoration(labelText: labels[index])),
          ],
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final values = controllers.map((controller) => controller.text.trim()).toList();
              if (values.any((value) => value.isEmpty)) return;
              Navigator.pop(context, values);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    for (final controller in controllers) {
      controller.dispose();
    }
    return result;
  }

  void navigateTo(String target) => navigate(target);
}
