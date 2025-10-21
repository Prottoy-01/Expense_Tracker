import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  final double amount;
  final double totalAdd;
  final double totalCost;
  const CalculatePage({
    super.key,
    required this.amount,
    required this.totalAdd,
    required this.totalCost,
  });

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  dynamic datetime;
  dynamic formattedDate;
  dynamic formattedTime;

  @override
  void initState() {
    super.initState();
    datetime = DateTime.now();
    formattedDate = "${datetime.day}-${datetime.month}-${datetime.year}";
    formattedTime = "${datetime.hour}:${datetime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Description',
                labelStyle: TextStyle(color: Colors.white),

                /* hintText: "Description",
                hintStyle: TextStyle(color: Colors.white, fontSize: 12),*/
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: Colors.white),
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor:
                          Colors.white, // This line sets the text color
                    ),
                    onPressed: () {
                      double updateamount = double.parse(amountController.text);
                      double realamount = double.parse(amountController.text);
                      int addSign = 1;

                      updateamount = widget.amount + updateamount;

                      //widget.totalAdd = totalAdd + realamount;
                      double totalAdd = widget.totalAdd + realamount;

                      Navigator.pop(context, {
                        'title': titleController.text,
                        'amount': updateamount,
                        'realamount': realamount,
                        'addSign': addSign,
                        'date': formattedDate,
                        // 'date': datetime.day,
                        'time': formattedTime,
                        'totalAdd': totalAdd,
                      });
                    },
                    child: Text(
                      'Income',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    /*style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),*/
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: () {
                      double amount = double.parse(amountController.text);
                      double realamount = double.parse(amountController.text);
                      int addSign = -1;

                      if (amount <= widget.amount && widget.amount > 0) {
                        amount = widget.amount - amount;
                        //totalCost = totalCost + realamount;
                        double totalCost = widget.totalCost + realamount;

                        Navigator.pop(context, {
                          'title': titleController.text,
                          'amount': amount,
                          'realamount': realamount,
                          'addSign': addSign,
                          'date': formattedDate,
                          //'date': datetime.day,
                          'time': formattedTime,
                          'totalCost': totalCost,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Your Balance is 0')),
                        );
                      }
                    },
                    child: Text(
                      'Expense',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
