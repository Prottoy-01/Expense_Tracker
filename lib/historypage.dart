import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/history_details.dart';

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
                final userInput = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                );
                if (userInput != null) {
                  day = userInput.day;
                  month = userInput.month;
                  year = userInput.year;
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryDetails(day: day, month: month, year: year),
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
