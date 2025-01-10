import 'package:energy_app/api/api.dart';
import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../api/api_test.mocks.dart';

// Annotate the provider for mock generation
@GenerateMocks([DashboardProvider])
void main() {
  late DashboardProvider dashboardProvider;
  late MockApi mockApi;

  setUp(() {
    GetIt.I.reset();
    mockApi = MockApi();
    GetIt.I.registerSingleton<Api>(mockApi);
    dashboardProvider = DashboardProvider();
  });

  tearDown(() {
    GetIt.I.reset();
  });

  test('fetchData data and save max point', () async {
    final mockDate = DateTime(2025, 1, 8);
    final mockResponse = [
      EnergyPoint(
          valueW: 500,
          valueKW: 0.5,
          date: mockDate.subtract(const Duration(hours: 1))),
      EnergyPoint(
          valueW: 1000,
          valueKW: 1,
          date: mockDate.subtract(const Duration(hours: 2))),
      EnergyPoint(
          valueW: 750,
          valueKW: 0.75,
          date: mockDate.subtract(const Duration(hours: 3))),
    ];

    when(mockApi.getEnergyInDay(
      DateFormat('yyyy-MM-dd').format(mockDate),
      Energy.SOLAR.type,
    )).thenAnswer((_) async => ApiResponseWrapper(
          value: mockResponse,
        ));

    await dashboardProvider.fetchData(mockDate, Energy.SOLAR);

    expect(dashboardProvider.solar, mockResponse);
    expect(dashboardProvider.maxSolar?.valueW, 1000);
    verify(mockApi.getEnergyInDay(
      DateFormat('yyyy-MM-dd').format(mockDate),
      Energy.SOLAR.type,
    )).called(1);
  });
}
