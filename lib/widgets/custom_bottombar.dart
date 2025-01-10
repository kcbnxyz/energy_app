import 'package:energy_app/providers/bottombar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  void _onItemTapped(BuildContext context, int index, BottomBarProvider bp) {
    switch (index) {
      case 0:
        context.vRouter.to('/dashboard');
        break;
      case 1:
        context.vRouter.to('/services');
        break;
      default:
        break;
    }
    bp.currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    BottomBarProvider bp = Provider.of<BottomBarProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_repair_service),
            label: 'Services',
          ),
        ],
        currentIndex: bp.currentIndex,
        onTap: (index) {
          _onItemTapped(context, index, bp);
        },
      ),
    );
  }
}
