import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:energy_app/presentations/pages/dashboard_page.dart';
import 'package:energy_app/presentations/pages/services_page.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

VRouter mainRouter(BuildContext context, String initialUrl) {
  VRouter vrouter = VRouter(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      initialUrl: initialUrl,
      builder: (context, widget) {
        return AdaptiveTheme(
            light: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                primaryColor: Colors.black),
            dark: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: Colors.white,
            ),
            initial: AdaptiveThemeMode.light,
            builder: (theme, darktheme) => Theme(data: theme, child: widget));
      },
      routes: [
        VNester(
            path: '/',
            widgetBuilder: (child) => ScaffoldMessenger(
                  key: scaffoldMessengerKey,
                  child: child,
                ),
            nestedRoutes: [
              VWidget(
                path: '/dashboard',
                widget: const DashboardPage(),
              ),
              VWidget(path: '/services', widget: const ServicesPage()),
            ])
      ]);

  Provider.of<DashboardProvider>(context, listen: false).refreshData();

  return vrouter;
}
