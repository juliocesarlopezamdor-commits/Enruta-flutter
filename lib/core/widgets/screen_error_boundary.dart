import 'package:flutter/material.dart';

ErrorWidgetBuilder installScreenErrorBuilder() {
  final previous = ErrorWidget.builder;
  ErrorWidget.builder = (details) => Container(
        color: const Color(0xFFF2F5F7),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: const Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.warning_amber_rounded, size: 30, color: Color(0xFF0B2F52)),
          SizedBox(height: 8),
          Text('Esta parte de la vista no está disponible.', textAlign: TextAlign.center),
        ]),
      );
  return previous;
}
