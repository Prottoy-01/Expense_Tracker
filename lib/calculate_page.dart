import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  final double amount;
  const CalculatePage({super.key, required this.amount});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Enter your title',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Enter your amount',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                ElevatedButton(
                  onPressed: () {
                    double updateamount = double.parse(amountController.text);
                    double realamount = double.parse(amountController.text);
                    int addSign = 1;

                    updateamount = widget.amount + updateamount;

                    Navigator.pop(context, {
                      'title': titleController.text,
                      'amount': updateamount,
                      'realamount': realamount,
                      'addSign': addSign,
                    });
                  },
                  child: Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    double amount = double.parse(amountController.text);
                    double realamount = double.parse(amountController.text);
                    int addSign = -1;

                    if (amount <= widget.amount && widget.amount > 0) {
                      amount = widget.amount - amount;

                      Navigator.pop(context, {
                        'title': titleController.text,
                        'amount': amount,
                        'realamount': realamount,
                        'addSign': addSign,
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your Balance is 0')),
                      );
                    }
                  },
                  child: Text('Subtract'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
