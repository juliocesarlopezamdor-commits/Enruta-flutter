import 'package:flutter/material.dart';

import '../models/mockup_document.dart';
import '../state/first_use_policy.dart';
import 'route_illustration.dart';

const _navy = Color(0xFF0B2F52);
const _gold = Color(0xFFE8B000);
const _muted = Color(0xFF6B8298);
const _text = Color(0xFF0F1E2B);

class MockupDevice extends StatelessWidget {
  const MockupDevice({
    required this.screen,
    required this.onElementTap,
    required this.populatedItems,
    this.onEmptyAction,
    this.valueFor,
    super.key,
  });

  final MockupScreen screen;
  final ValueChanged<MockupElement> onElementTap;
  final List<String> populatedItems;
  final VoidCallback? onEmptyAction;
  final String? Function(MockupElement element)? valueFor;

  @override
  Widget build(BuildContext context) {
    if (screen.failure != null) return _screenFailure(screen.failure!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: screen.backgroundColor,
          border: Border.all(color: _navy, width: 2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: SizedBox(
          width: mockupWidth,
          height: mockupHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              for (final element in screen.elements)
                if ((!FirstUsePolicy.hideExample(screen, element) &&
                        !FirstUsePolicy.coveredByEmptyPanel(screen, element)) ||
                    FirstUsePolicy.editableField(screen, element) ||
                    (valueFor?.call(element)?.isNotEmpty ?? false))
                  _positionElement(
                    element,
                    valueFor?.call(element),
                    editable: FirstUsePolicy.editableField(screen, element),
                  ),
              if (FirstUsePolicy.panelFor(screen.id) case final panel?)
                _emptyPanel(panel, populatedItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _positionElement(MockupElement element, String? value, {required bool editable}) {
    try {
      return Positioned(
        left: element.x,
        top: element.y,
        width: element.width,
        height: element.height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: element.value.isEmpty ? null : () => onElementTap(element),
          child: _cellContent(element, value ?? (editable ? '' : element.value), editable: editable),
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  Widget _cellContent(MockupElement element, String value, {required bool editable}) {
    if (value == 'Ilustración · ruta y mapa') {
      return const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        child: RouteIllustration(),
      );
    }
    final radius = element.isEllipse
        ? BorderRadius.circular(100)
        : BorderRadius.circular(element.isRounded ? 8 : 0);
    return Container(
      alignment: _textAlignment(element.style),
      padding: element.isText ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: editable ? Colors.white : element.fillColor,
        borderRadius: editable ? BorderRadius.circular(5) : radius,
        border: editable
            ? Border.all(color: const Color(0xFFB7C6D2))
            : element.hasBorder
                ? Border.all(color: element.strokeColor)
                : null,
      ),
      child: value.isEmpty && !editable
          ? null
          : Text(
              value.isEmpty ? 'Toca para ingresar' : value,
              maxLines: _maxLines(element.height),
              overflow: TextOverflow.clip,
              textAlign: _textAlign(element.style),
              style: TextStyle(
                color: value.isEmpty && editable ? _muted : element.textColor,
                fontSize: element.fontSize,
                fontWeight: element.bold ? FontWeight.bold : FontWeight.normal,
                height: 1.12,
              ),
            ),
    );
  }

  Widget _emptyPanel(EmptyPanelSpec panel, List<String> items) => Positioned(
        left: 14,
        right: 14,
        top: panel.top,
        height: panel.height,
        child: ColoredBox(
          color: screen.backgroundColor,
          child: Column(children: [
            Expanded(
              child: items.isEmpty
                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.inbox_outlined, size: 32, color: _muted),
                      const SizedBox(height: 12),
                      Text(panel.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: _text, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(panel.detail,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: _muted, fontSize: 11, height: 1.35)),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.circle_outlined, size: 16, color: _navy),
                        title: Text(items[index], style: const TextStyle(fontSize: 12, color: _text)),
                      ),
                    ),
            ),
            if (panel.action != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _gold,
                      foregroundColor: _text,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    ),
                    onPressed: onEmptyAction,
                    child: Text(panel.action!, style: const TextStyle(fontSize: 12)),
                  ),
                ),
            ],
          ]),
        ),
      );

  Widget _screenFailure(String failure) => Container(
        width: mockupWidth,
        height: mockupHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5F7),
          border: Border.all(color: _navy, width: 2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.warning_amber_rounded, color: _navy, size: 36),
          const SizedBox(height: 12),
          const Text('No se pudo abrir esta vista', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(failure, textAlign: TextAlign.center),
        ]),
      );

  int _maxLines(double height) => (height / 13).floor().clamp(1, 5);

  Alignment _textAlignment(String style) {
    if (style.contains('align=center')) return Alignment.center;
    if (style.contains('align=right')) return Alignment.centerRight;
    final vertical = style.contains('verticalAlign=top') ? -1.0 : 0.0;
    return Alignment(-1, vertical);
  }

  TextAlign _textAlign(String style) {
    if (style.contains('align=center')) return TextAlign.center;
    if (style.contains('align=right')) return TextAlign.right;
    return TextAlign.left;
  }
}
