import 'package:appzap_counter_web_app/app/routes/screen_not_found.dart';
import 'package:appzap_counter_web_app/contanst.dart';
import 'package:appzap_counter_web_app/page/setting.dart';
import 'package:appzap_counter_web_app/page/web_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
          path: Routes.root,
          pageBuilder: (context, state) => const NoTransitionPage(
                child: WebViewAppCounter(),
              ),
          routes: [
            GoRoute(
              path: Routes.setting,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: Setting()),
            )
          ])
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  static GoRouter get router => _router;
}
