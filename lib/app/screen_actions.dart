import 'package:flutter/material.dart';

import '../core/actions/screen_action_context.dart';
import '../core/models/mockup_document.dart';
import '../core/session/app_session.dart';
import '../features/auth/auth_actions.dart';
import '../features/business/business_actions.dart';
import '../features/closing/closing_actions.dart';
import '../features/delivery/delivery_actions.dart';
import '../features/route/route_actions.dart';

class ScreenActions {
  const ScreenActions({
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

  ScreenActionContext get _action => ScreenActionContext(
        context: context,
        screen: screen,
        session: session,
        inputs: inputs,
        navigate: navigate,
      );

  Future<void> onElement(MockupElement element) => _action.run(() async {
        final action = _action;
        if (AuthActions.supports(screen.id)) {
          await AuthActions.handle(action, element);
        } else if (RouteActions.supports(screen.id)) {
          await RouteActions.handle(action, element);
        } else if (DeliveryActions.supports(screen.id)) {
          await DeliveryActions.handle(action, element);
        } else if (ClosingActions.supports(screen.id)) {
          await ClosingActions.handle(action, element);
        } else if (BusinessActions.supports(screen.id)) {
          await BusinessActions.handle(action, element);
        }
      });

  Future<void> onEmptyAction() => _action.run(() async {
        final action = _action;
        if (RouteActions.supports(screen.id)) {
          await RouteActions.handleEmptyAction(action);
        } else if (DeliveryActions.supports(screen.id)) {
          await DeliveryActions.handleEmptyAction(action);
        } else if (ClosingActions.supports(screen.id)) {
          await ClosingActions.handleEmptyAction(action);
        } else if (BusinessActions.supports(screen.id)) {
          await BusinessActions.handleEmptyAction(action);
        }
      });
}
