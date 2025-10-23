import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_expense_tracker/calculate_page.dart';
import 'package:personal_expense_tracker/historypage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_expense_tracker/visualize_page.dart';

class FirstPage extends StatefulWidget {
  final String title;
  final double amount;
  final double totalAdd;
  final double totalCost;
  const FirstPage({
    super.key,
    required this.title,
    required this.amount,
    required this.totalAdd,
    required this.totalCost,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Map<String, dynamic>> items = [];
  late int month;
  late double currentAmount;
  late double realamount;
  late int addSign;
  late double totalAdd;
  late double totalCost;

  final Box box = Hive.box('expenses');

  @override
  void initState() {
    super.initState();
    currentAmount = widget.amount;
    final savedItems = box.get('items', defaultValue: []);
    final savedAmount = box.get('currentAmount', defaultValue: 0.0);
    totalAdd = box.get('totalAdd', defaultValue: 0.0);
    totalCost = box.get('totalCost', defaultValue: 0.0);

    items = (savedItems as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
    currentAmount = savedAmount;
  }

  void saveToHive() {
    box.put('items', items);

    box.put('currentAmount', currentAmount);
    box.put('totalAdd', totalAdd);
    box.put('totalCost', totalCost);
  }

  @override
  Widget build(BuildContext context) {
    // Group items by date
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in items) {
      final date = item['date'] as String;
      if (groupedItems[date] == null) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item);
    }
    final sortedDates = groupedItems.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VisualaPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Your Personal Expense Tracker'),

        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 236, 240, 5),
        elevation: 100,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total Income',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '\$${totalAdd.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '\$${currentAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total Expense',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '\$${totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sortedDates.length,

                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  final itemsForDate = groupedItems[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.white24, thickness: 1),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemsForDate.length,
                        itemBuilder: (context, itemIndex) {
                          final item =
                              itemsForDate[itemIndex]; //core line for logic implemention
                          return Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      //Update Main Balance Based on Deleted Item
                                      if (item['addSign'] == 1) {
                                        // It was an income, so removing it means subtracting from total income
                                        currentAmount =
                                            currentAmount - item['realamount'];
                                        totalAdd =
                                            totalAdd - item['realamount'];
                                      } else {
                                        // It was an expense, so removing it means adding back to balance
                                        currentAmount =
                                            currentAmount + item['realamount'];
                                        totalCost =
                                            totalCost - item['realamount'];
                                      }
                                      items.remove(item);
                                    });
                                    saveToHive();
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      item['realamount'].toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: item['addSign'] == 1
                                      ? Center(
                                          child: const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.green,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.arrow_downward,

                                          color: Colors.red,
                                        ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 15, color: Colors.black),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final number =
              await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalculatePage(
                        amount: currentAmount,
                        totalAdd: totalAdd,
                        totalCost: totalCost,
                      ),
                    ),
                  )
                  as Map<String, dynamic>?;
          if (number != null) {
            setState(() {
              items.add(number);
              //month = DateTime.now().month;

              currentAmount = number['amount'] ?? 0.0;
              totalAdd = number['totalAdd'] ?? totalAdd;
              totalCost = number['totalCost'] ?? totalCost;
            });
            saveToHive();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
