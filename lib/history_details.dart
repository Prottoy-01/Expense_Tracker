import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryDetails extends StatefulWidget {
  //final day;
  final month;
  final year;

  const HistoryDetails({
    super.key,
    //required this.day,
    required this.month,
    required this.year,
  });

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  List<Map<String, dynamic>> results = []; // state variable

  @override
  void initState() {
    super.initState();

    final box = Hive.box('expenses');

    final savedItems = box.get('items', defaultValue: []);
    final items = (savedItems as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    // Filter items by date
    results = items.where((item) {
      // return item['date'] == "${widget.day}-${widget.month}-${widget.year}";
      //return item['month'] == "${widget.month}-${widget.year}";
      return item['date'].toString().contains(
        "-${widget.month}-${widget.year}",
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text("Details for ${widget.month}-${widget.year}"),
              Expanded(
                child: results.isEmpty
                    ? const Center(child: Text("No items found"))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            title: Text(item['title'] ?? ''),
                            trailing: item['addSign'] == 1
                                ? Icon(Icons.arrow_upward, color: Colors.green)
                                : Icon(Icons.arrow_downward, color: Colors.red),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['realamount'].toString()),
                                Text(item['date'] ?? ''),
                                // Text(item['time'] ?? ''), // optional
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
