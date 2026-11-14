import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

const drawioAssetPath = 'EnRuta-Mockups-App-Transportistas.drawio';
const mockupWidth = 300.0;
const mockupHeight = 620.0;

class MockupDocument {
  const MockupDocument(this.screens);

  final List<MockupScreen> screens;

  static Future<MockupDocument> load() async {
    final source = await rootBundle.loadString(drawioAssetPath);
    return parse(source);
  }

  static MockupDocument parse(String source) {
    final document = XmlDocument.parse(source);
    final screens = <MockupScreen>[];

    for (final diagram in document.findAllElements('diagram')) {
      final graph = diagram.findElements('mxGraphModel').firstOrNull;
      final root = graph?.findElements('root').firstOrNull;
      if (root == null) continue;

      final cells = root.findElements('mxCell').toList();
      final byId = {for (final cell in cells) cell.getAttribute('id') ?? '': cell};
      final byParent = <String, List<XmlElement>>{};
      for (final cell in cells) {
        final parent = cell.getAttribute('parent');
        if (parent != null) byParent.putIfAbsent(parent, () => []).add(cell);
      }

      for (final frame in cells.where((cell) => cell.getAttribute('parent') == '1')) {
        final geometry = _geometry(frame);
        if (geometry == null || geometry.width != mockupWidth || geometry.height != mockupHeight) {
          continue;
        }
        final heading = cells.cast<XmlElement?>().firstWhere(
          (cell) {
            if (cell?.getAttribute('parent') != '1') return false;
            final titleGeometry = _geometry(cell!);
            return titleGeometry != null &&
                titleGeometry.x == geometry.x &&
                titleGeometry.y == geometry.y - 30;
          },
          orElse: () => null,
        );
        final title = _cleanValue(heading?.getAttribute('value') ?? 'Vista');
        final id = RegExp(r'^[A-Z]+-\d+').firstMatch(title)?.group(0) ?? frame.getAttribute('id')!;
        final elements = <MockupElement>[];
        String? failure;

        try {
          _collectElements(
            frame.getAttribute('id')!,
            0,
            0,
            byParent,
            byId,
            elements,
          );
        } catch (error) {
          failure = 'No se pudo interpretar esta vista: $error';
        }

        screens.add(MockupScreen(
          id: id,
          title: title,
          group: diagram.getAttribute('name') ?? 'EnRuta',
          backgroundColor: _styleColor(frame.getAttribute('style'), 'fillColor', const Color(0xFFF2F5F7)),
          elements: List.unmodifiable(elements),
          failure: failure,
        ));
      }
    }

    return MockupDocument(List.unmodifiable(screens));
  }

  static void _collectElements(
    String parentId,
    double offsetX,
    double offsetY,
    Map<String, List<XmlElement>> byParent,
    Map<String, XmlElement> byId,
    List<MockupElement> output,
  ) {
    for (final cell in byParent[parentId] ?? const <XmlElement>[]) {
      final geometry = _geometry(cell);
      if (geometry == null) continue;
      final x = offsetX + geometry.x;
      final y = offsetY + geometry.y;
      final style = cell.getAttribute('style') ?? '';
      final value = _cleanValue(cell.getAttribute('value') ?? '');
      if (!style.contains('edgeStyle=') && !style.contains('endArrow=')) {
        output.add(MockupElement(
          id: cell.getAttribute('id') ?? '',
          x: x,
          y: y,
          width: geometry.width,
          height: geometry.height,
          value: value,
          style: style,
          fillColor: _styleColor(style, 'fillColor', Colors.transparent),
          strokeColor: _styleColor(style, 'strokeColor', Colors.transparent),
          textColor: _styleColor(style, 'fontColor', const Color(0xFF0F1E2B)),
          fontSize: _styleNumber(style, 'fontSize', 12),
          bold: style.contains('fontStyle=1') || style.contains('fontStyle=1;'),
        ));
      }
      final id = cell.getAttribute('id');
      if (id != null && byParent.containsKey(id)) {
        _collectElements(id, x, y, byParent, byId, output);
      }
    }
  }
}

class MockupScreen {
  const MockupScreen({
    required this.id,
    required this.title,
    required this.group,
    required this.backgroundColor,
    required this.elements,
    this.failure,
  });

  final String id;
  final String title;
  final String group;
  final Color backgroundColor;
  final List<MockupElement> elements;
  final String? failure;
}

class MockupElement {
  const MockupElement({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.value,
    required this.style,
    required this.fillColor,
    required this.strokeColor,
    required this.textColor,
    required this.fontSize,
    required this.bold,
  });

  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final String value;
  final String style;
  final Color fillColor;
  final Color strokeColor;
  final Color textColor;
  final double fontSize;
  final bool bold;

  bool get isEllipse => style.contains('ellipse');
  bool get isRounded => style.contains('rounded=1');
    bool get hasBorder => strokeColor != Colors.transparent && strokeColor.a != 0;
  bool get isText => style.contains('shape=text') ||
      (fillColor.a == 0 && !hasBorder && value.isNotEmpty);
}

class _Geometry {
  const _Geometry(this.x, this.y, this.width, this.height);
  final double x;
  final double y;
  final double width;
  final double height;
}

_Geometry? _geometry(XmlElement cell) {
  final element = cell.findElements('mxGeometry').firstOrNull;
  if (element == null) return null;
  return _Geometry(
    double.tryParse(element.getAttribute('x') ?? '0') ?? 0,
    double.tryParse(element.getAttribute('y') ?? '0') ?? 0,
    double.tryParse(element.getAttribute('width') ?? '0') ?? 0,
    double.tryParse(element.getAttribute('height') ?? '0') ?? 0,
  );
}

String _cleanValue(String value) => value
    .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
    .replaceAll(RegExp(r'<[^>]*>'), '')
    .replaceAll('&nbsp;', ' ')
    .trim();

Color _styleColor(String? style, String key, Color fallback) {
  final match = RegExp('$key=#([0-9A-Fa-f]{6})').firstMatch(style ?? '');
  if (match == null) return fallback;
  return Color(0xFF000000 | int.parse(match.group(1)!, radix: 16));
}

double _styleNumber(String style, String key, double fallback) {
  final value = RegExp('$key=([0-9.]+)').firstMatch(style)?.group(1);
  return double.tryParse(value ?? '') ?? fallback;
}
