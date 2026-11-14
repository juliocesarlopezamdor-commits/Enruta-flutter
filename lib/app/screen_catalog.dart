import 'package:flutter/material.dart';

import '../core/models/mockup_document.dart';

Future<void> showScreenCatalog(
  BuildContext context,
  List<MockupScreen> screens,
  ValueChanged<String> onSelect,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF2F5F7),
    builder: (context) => SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .78,
        minChildSize: .45,
        builder: (context, controller) => Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(children: [
              Icon(Icons.grid_view_rounded, color: Color(0xFF0B2F52)),
              SizedBox(width: 10),
              Text('Vistas del diagrama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: screens.length,
              itemBuilder: (context, index) {
                final screen = screens[index];
                return ListTile(
                  leading: SizedBox(
                    width: 52,
                    child: Text(screen.id, style: const TextStyle(
                      color: Color(0xFF14497A), fontSize: 11, fontWeight: FontWeight.w700,
                    )),
                  ),
                  title: Text(screen.title.replaceFirst(RegExp(r'^[A-Z]+-\d+\s*[·-]\s*'), '')),
                  subtitle: Text(screen.group),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(screen.id);
                  },
                );
              },
            ),
          ),
        ]),
      ),
    ),
  );
}
