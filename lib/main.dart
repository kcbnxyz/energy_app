import 'package:energy_app/dependency.dart';
import 'package:energy_app/providers/bottombar_provider.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:energy_app/routing/main_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  configureDependencies();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomBarProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider())
      ],
      child: MaterialApp(
        builder: (BuildContext context, Widget? widget) =>
            mainRouter(context, '/dashboard'),
      ),
    );
  }
}
