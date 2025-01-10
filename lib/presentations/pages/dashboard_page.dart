import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:energy_app/widgets/custom_appbar.dart';
import 'package:energy_app/widgets/custom_scaffold.dart';
import 'package:energy_app/widgets/line_chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabBar buildTabBar() {
    return TabBar(
      splashFactory: NoSplash.splashFactory,
      overlayColor:
          WidgetStateProperty.resolveWith((states) => Colors.transparent),
      controller: _tabController,
      tabs: const [
        Tab(
          icon: Icon(Icons.solar_power),
        ),
        Tab(
          icon: Icon(Icons.home),
        ),
        Tab(
          icon: Icon(Icons.battery_charging_full),
        ),
      ],
    );
  }

  Widget buildView(DashboardProvider dbp, List<EnergyPoint> data,
      EnergyPoint? maxData, String title) {
    return RefreshIndicator(
      onRefresh: () {
        return dbp.refreshData();
      },
      child: ListView(children: [
        Center(
          child: CustomLineChart(
            data: data,
            maxPoint: maxData,
            title: title,
          ),
        ),
      ]),
    );
  }

  Widget buildTabBarView(DashboardProvider dbp) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildView(dbp, dbp.solar, dbp.maxSolar, 'Solar Generation'),
          buildView(dbp, dbp.house, dbp.maxHouse, 'House Consumption'),
          buildView(dbp, dbp.battery, dbp.maxBatt, 'Battery Consumption')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dbp = Provider.of<DashboardProvider>(context);
    return CustomScaffold(
      appBar: customAppBar(context, 'Dashboard', buildTabBar()),
      child: buildTabBarView(dbp),
    );
  }
}
