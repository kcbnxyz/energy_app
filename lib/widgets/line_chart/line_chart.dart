import 'package:energy_app/api/models/energy_point.dart';
import 'package:energy_app/providers/dashboard_provider.dart';
import 'package:energy_app/widgets/line_chart/chart_title.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomLineChart extends StatefulWidget {
  final List<EnergyPoint> data;
  final EnergyPoint? maxPoint;
  final String title;
  const CustomLineChart(
      {super.key,
      required this.data,
      required this.title,
      required this.maxPoint});

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  List<EnergyPoint>? _data;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dbp = Provider.of<DashboardProvider>(context);
    _data = widget.data;
    const leftReservedSize = 52.0;
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                const SizedBox(width: leftReservedSize),
                ChartTitle(
                  title: widget.title,
                ),
                const Spacer(),
              ],
            );
          },
        ),
        AspectRatio(
          aspectRatio: 1.4,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
              right: 18.0,
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                    border: Border(
                        left: BorderSide(color: Theme.of(context).primaryColor),
                        bottom:
                            BorderSide(color: Theme.of(context).primaryColor))),
                minY: 0,
                maxY: widget.maxPoint != null
                    ? ((dbp.currentUnit == Unit.W
                            ? widget.maxPoint!.valueW
                            : widget.maxPoint!.valueKW) *
                        1.5)
                    : null,
                lineBarsData: [
                  LineChartBarData(
                    spots: _data?.asMap().entries.map((e) {
                          final index = e.key;
                          final item = e.value;
                          final value = dbp.currentUnit == Unit.W
                              ? item.valueW
                              : item.valueKW;
                          return FlSpot(index.toDouble(), value.toDouble());
                        }).toList() ??
                        [],
                    dotData: const FlDotData(show: false),
                    color: Colors.green,
                    barWidth: 1,
                    shadow: const Shadow(
                      color: Colors.green,
                      blurRadius: 2,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Colors.green.withOpacity(0),
                        ],
                        stops: const [0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchSpotThreshold: 5,
                  getTouchLineStart: (_, __) => -double.infinity,
                  getTouchLineEnd: (_, __) => double.infinity,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        const FlLine(
                          color: Colors.grey,
                          strokeWidth: 1.5,
                          dashArray: [8, 2],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.red,
                                strokeWidth: 1,
                                strokeColor: Colors.white);
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final energy = barSpot.y;
                        final date = _data![barSpot.x.toInt()].date;
                        return LineTooltipItem(
                          '',
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat('HH:mm').format(date).toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: '\n$energy',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                    // getTooltipColor: (LineBarSpot barSpot) => Colors.black,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: leftReservedSize,
                      maxIncluded: false,
                      minIncluded: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      maxIncluded: false,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final date = _data![value.toInt()].date;
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Transform.rotate(
                            angle: -45 * 3.14 / 180,
                            child: Text(
                              DateFormat('HH:mm').format(date).toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              duration: Duration.zero,
            ),
          ),
        ),
      ],
    );
  }
}
