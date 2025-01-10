import 'package:energy_app/widgets/custom_bottombar.dart';
import 'package:energy_app/widgets/custom_end_drawer.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final AssetImage? image;
  const CustomScaffold(
      {super.key, required this.child, this.image, this.appBar});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      endDrawer: const CustomEndDrawer(),
      body: widget.child,
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
