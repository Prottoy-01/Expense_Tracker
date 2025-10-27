import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  String item;
  double amount;
  EditPage({super.key, required this.item, required this.amount});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Page')),
      body: Center(
        child: Column(
          children: [
            Text(widget.item),
            Text(widget.amount.toString()),
            TextFormField(
              controller: titleController,

              decoration: const InputDecoration(labelText: 'Update Title'),
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Update Amount'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': titleController.text.isEmpty
                      ? widget.item
                      : titleController.text,

                  'amount': amountController.text.isEmpty
                      ? widget.amount
                      : double.parse(amountController.text),
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
