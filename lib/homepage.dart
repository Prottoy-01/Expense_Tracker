import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/calculate_page.dart';

class FirstPage extends StatefulWidget {
  final String title;
  final double amount;
  const FirstPage({super.key, required this.title, required this.amount});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Map<String, dynamic>> items = [];
  late double currentAmount;
  late double realamount;
  late int addSign;

  final Box box = Hive.box('expenses');

  @override
  void initState() {
    super.initState();
    currentAmount = widget.amount;
    final savedItems = box.get('items', defaultValue: []);
    final savedAmount = box.get('currentAmount', defaultValue: 0.0);

    items = (savedItems as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    currentAmount = savedAmount;
  }

  void saveToHive() {
    box.put('items', items);
    box.put('currentAmount', currentAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personal Expense Tracker'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 236, 240, 5),
        elevation: 100,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    color: Colors.amberAccent,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            currentAmount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['title']),

                  trailing: items[index]['addSign'] == 1
                      ? Icon(Icons.arrow_upward, color: Colors.green)
                      : Icon(Icons.arrow_downward, color: Colors.red),
                  subtitle: Text(items[index]['realamount'].toString()),
                );
              },
              itemCount: items.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final number =
              await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CalculatePage(amount: currentAmount),
                    ),
                  )
                  as Map<String, dynamic>?;
          if (number != null) {
            setState(() {
              items.add(number);
              currentAmount = number['amount'] ?? 0.0;
              //realamount = number['realamount'] ?? 0.0;
              //addSign = number['addSign'] ?? 0;
            });
            saveToHive();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
