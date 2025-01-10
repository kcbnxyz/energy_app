import 'package:energy_app/api/api.dart';
import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/dependency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Energy {
  SOLAR('solar'),
  HOUSE('house'),
  BATTERY('battery');

  const Energy(this.type);
  final String type;
}

enum Unit {
  W('W'),
  kW('kW');

  const Unit(this.unit);
  final String unit;
}

class DashboardProvider extends ChangeNotifier {
  List<EnergyPoint> _solar = [];
  List<EnergyPoint> _house = [];
  List<EnergyPoint> _battery = [];
  EnergyPoint? maxSolar;
  EnergyPoint? maxHouse;
  EnergyPoint? maxBatt;
  DateTime _currentDate = DateTime.now();
  Unit _currentUnit = Unit.W;
  final Api api = getIt<Api>();

  setCurrentDate(DateTime? date) {
    if (date == null) return;
    _currentDate = date;
    fetchData(date, Energy.SOLAR);
    fetchData(date, Energy.HOUSE);
    fetchData(date, Energy.BATTERY);
    notifyListeners();
  }

  setUnit(Unit unit) {
    _currentUnit = unit;
    notifyListeners();
  }

  set solar(List<EnergyPoint> data) {
    _solar = data;
    notifyListeners();
  }

  set house(List<EnergyPoint> data) {
    _house = data;
    notifyListeners();
  }

  set battery(List<EnergyPoint> data) {
    _battery = data;
    notifyListeners();
  }

  List<EnergyPoint> get solar => _solar;
  List<EnergyPoint> get house => _house;
  List<EnergyPoint> get battery => _battery;
  DateTime get currentDate => _currentDate;
  Unit get currentUnit => _currentUnit;

  EnergyPoint _getMaxPoint(List<EnergyPoint> le) {
    return le.reduce(
        (current, next) => current.valueW > next.valueW ? current : next);
  }

  Future<void> fetchData(DateTime date, Energy energy) async {
    ApiResponseWrapper<List<EnergyPoint>> res = await api.getEnergyInDay(
        DateFormat('yyyy-MM-dd').format(date).toString(), energy.type);
    api.showSnackbarOnException(res);
    switch (energy) {
      case Energy.SOLAR:
        solar = res.value ?? [];
        if (_solar.isNotEmpty) {
          maxSolar = _getMaxPoint(_solar);
        }
        break;
      case Energy.HOUSE:
        house = res.value ?? [];
        if (_house.isNotEmpty) {
          maxHouse = _getMaxPoint(_house);
        }
        break;
      case Energy.BATTERY:
        battery = res.value ?? [];
        if (_battery.isNotEmpty) {
          maxBatt = _getMaxPoint(_battery);
        }
        break;
      default:
        break;
    }
  }

  Future<void> refreshData() async {
    _currentDate = DateTime.now();
    await fetchData(DateTime.now(), Energy.SOLAR);
    await fetchData(DateTime.now(), Energy.HOUSE);
    await fetchData(DateTime.now(), Energy.BATTERY);
  }
}
