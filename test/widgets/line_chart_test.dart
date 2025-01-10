import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:energy_app/widgets/line_chart/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider_test.mocks.dart';

void main() {
  group('Line Chart', () {
    late MockDashboardProvider mockDashboardProvider;
    setUp(() {
      mockDashboardProvider = MockDashboardProvider();
    });

    testWidgets('display title, date, current unit and line chart',
        (WidgetTester tester) async {
      final solar = [
        EnergyPoint(
            valueW: 200, valueKW: 0.2, date: DateTime(2025, 1, 1, 10, 0, 0)),
        EnergyPoint(
            valueW: 100, valueKW: 0.1, date: DateTime(2025, 1, 1, 10, 0, 5)),
      ];

      final maxSolar =
          EnergyPoint(valueW: 200, valueKW: 0.2, date: DateTime.now());

      when(mockDashboardProvider.currentUnit).thenReturn(Unit.kW);
      when(mockDashboardProvider.currentDate)
          .thenReturn(DateTime(2025, 1, 1, 10, 0, 10));

      await tester.pumpWidget(ChangeNotifierProvider<DashboardProvider>.value(
        value: mockDashboardProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(children: [
              Center(
                child: CustomLineChart(
                    data: solar, title: 'Test Title', maxPoint: maxSolar),
              ),
            ]),
          ),
        ),
      ));

      expect(find.text('in kW'), findsWidgets);
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
      expect(
          find.text(
              DateFormat('dd/MM/yyyy').format(DateTime(2025, 1, 1)).toString()),
          findsOneWidget);
      verify(mockDashboardProvider.currentUnit).called(greaterThan(1));
    });
  });
}
