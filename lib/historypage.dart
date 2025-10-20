import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/history_details.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  dynamic day;
  dynamic month;
  dynamic year;

  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(hintText: "select date"),
              onTap: () async {
                final selectedDate = await showMonthPicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    month = selectedDate.month;
                    year = selectedDate.year;

                    dateController.text = "$month-$year";
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryDetails(month: month, year: year),
                  ),
                );
              },
              child: Text("see details"),
            ),
          ],
        ),
      ),
    );
  }
}
