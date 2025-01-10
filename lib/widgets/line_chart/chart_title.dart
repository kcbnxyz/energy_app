import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChartTitle extends StatefulWidget {
  final String title;
  const ChartTitle({super.key, required this.title});

  @override
  State<ChartTitle> createState() => _ChartTitleState();
}

class _ChartTitleState extends State<ChartTitle> {
  Future<void> onDatePick(BuildContext context, DashboardProvider dbp) async {
    DateTime? datePicked = await DatePicker.showSimpleDatePicker(context,
        initialDate: dbp.currentDate,
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        dateFormat: "dd-MMMM-yyyy",
        textColor: Theme.of(context).primaryColor,
        backgroundColor:
            AdaptiveTheme.of(context).isDefault ? Colors.white : Colors.black);
    dbp.setCurrentDate(datePicked);
  }

  Widget buildDropdownMenu(DashboardProvider dbp) {
    return DropdownMenu<Unit>(
      inputDecorationTheme: InputDecorationTheme(
          border: MaterialStateOutlineInputBorder.resolveWith(
        (states) => const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
      )),
      width: 120,
      dropdownMenuEntries: Unit.values
          .map(
            (e) => DropdownMenuEntry(value: e, label: 'in ${e.unit}'),
          )
          .toList(),
      initialSelection: dbp.currentUnit,
      onSelected: (val) {
        dbp.setUnit(val!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dbp = Provider.of<DashboardProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            buildDropdownMenu(dbp),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            await onDatePick(context, dbp);
          },
          child: Text(
            DateFormat('dd/MM/yyyy').format(dbp.currentDate).toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
