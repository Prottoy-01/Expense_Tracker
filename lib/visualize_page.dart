import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class VisualaPage extends StatefulWidget {
  const VisualaPage({super.key});

  @override
  State<VisualaPage> createState() => _VisualaPageState();
}

class _VisualaPageState extends State<VisualaPage> {
  late double totalAdd;
  late double totalCost;
  List<Map<String, dynamic>> items = [];
  late double currentAmount;
  final Box box = Hive.box('expenses');
  var firstweekincome = 0.0;
  var firstweekexpense = 0.0;
  var secondweekincome = 0.0;
  var secondweekexpense = 0.0;
  var thirdweekincome = 0.0;
  var thirdweekexpense = 0.0;
  var lastweekincome = 0.0;
  var lastweekexpense = 0.0;

  @override
  void initState() {
    super.initState();
    final savedItems = box.get('items', defaultValue: []);
    final savedAmount = box.get('currentAmount', defaultValue: 0.0);
    totalAdd = box.get('totalAdd', defaultValue: 0.0);
    totalCost = box.get('totalCost', defaultValue: 0.0);

    items = (savedItems as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    currentAmount = savedAmount;

    //logic implemention

    final List<Map<String, dynamic>> firstweek = [];
    /*final Map<String, List<Map<String, dynamic>>> secondweek = {};*/

    final List<Map<String, dynamic>> secondweek = [];
    final List<Map<String, dynamic>> thirdweek = [];
    final List<Map<String, dynamic>> lastweek = [];

    for (var item in items) {
      /* final date = item['date'] as String;
      final parsedate = DateTime.parse(date);
      final day = parsedate.day;*/
      final date = item['date'] as String;
      final dateFormat = DateFormat('dd-MM-yyyy');
      final parsedDate = dateFormat.parse(date);
      final day = parsedDate.day;

      if (day <= 7) {
        firstweek.add(item);
      } else if (day <= 14) {
        secondweek.add(item);
      } else if (day <= 21) {
        thirdweek.add(item);
      } else {
        lastweek.add(item);
      }
    }

    for (var expense in firstweek) {
      if (expense['addSign'] == 1) {
        firstweekincome = firstweekincome + expense['realamount'];
      } else {
        firstweekexpense = firstweekexpense + expense['realamount'];
      }
    }
    for (var expense in secondweek) {
      if (expense['addSign'] == 1) {
        secondweekincome = secondweekincome + expense['realamount'];
      } else {
        secondweekexpense = secondweekexpense + expense['realamount'];
      }
    }
    for (var expense in thirdweek) {
      if (expense['addSign'] == 1) {
        thirdweekincome = thirdweekincome + expense['realamount'];
      } else {
        thirdweekexpense = thirdweekexpense + expense['realamount'];
      }
    }
    for (var expense in lastweek) {
      if (expense['addSign'] == 1) {
        lastweekincome = lastweekincome + expense['realamount'];
      } else {
        lastweekexpense = lastweekexpense + expense['realamount'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Income & Expenses'),
        backgroundColor: Colors.blue,
      ),

      /*body: Center(
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            sections: [
              PieChartSectionData(value: firstweekincome, color: Colors.green),
              PieChartSectionData(value: firstweekexpense, color: Colors.red),
              PieChartSectionData(value: secondweekincome, color: Colors.green),
              PieChartSectionData(value: secondweekexpense, color: Colors.red),
              PieChartSectionData(value: thirdweekincome, color: Colors.green),
              PieChartSectionData(value: thirdweekexpense, color: Colors.red),
              PieChartSectionData(value: lastweekincome, color: Colors.green),
              PieChartSectionData(value: lastweekexpense, color: Colors.red),
            ],
          ),
        ),
      ),*/
      body: Center(
        child: BarChart(
          BarChartData(
            groupsSpace: 5,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: firstweekincome,
                    color: Colors.green,
                    width: 15,
                  ),
                  BarChartRodData(
                    fromY: 0,
                    toY: firstweekexpense,
                    color: Colors.red,
                    width: 15,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: secondweekincome,
                    color: Colors.green,
                    width: 15,
                  ),
                  BarChartRodData(
                    fromY: 0,
                    toY: secondweekexpense,
                    color: Colors.red,
                    width: 15,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: thirdweekincome,
                    color: Colors.green,
                    width: 15,
                  ),
                  BarChartRodData(
                    fromY: 0,
                    toY: thirdweekexpense,
                    color: Colors.red,
                    width: 15,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: lastweekincome,
                    color: Colors.green,
                    width: 15,
                  ),
                  BarChartRodData(
                    fromY: 0,
                    toY: lastweekexpense,
                    color: Colors.red,
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
