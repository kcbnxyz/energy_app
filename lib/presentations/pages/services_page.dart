import 'package:energy_app/widgets/custom_appbar.dart';
import 'package:energy_app/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: customAppBar(context, 'Services', null),
        child: const Placeholder());
  }
}
