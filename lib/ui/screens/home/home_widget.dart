import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_bloc.dart';
import 'package:money_manage_project/models/transaction.dart';

Widget addCategoryWidget(BuildContext currContext, Function addCategory,
    BuildContext widgetContext) {
  String input = "";
  return BlocProvider.value(
    value: BlocProvider.of<TransactionBloc>(currContext),
    child: AlertDialog(
      title: Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              decoration: InputDecoration(hintText: 'Category'),
              onChanged: (val) {
                input = val;
              }),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(widgetContext).pop();
            print(input);
            addCategory(input);
          },
          child: Text('Add Category'),
          color: Colors.blueAccent,
        )
      ],
    ),
  );
}

Widget addTransactionWidget(BuildContext currContext, Function addEvent,
    List<String> categoryList, BuildContext widgetContext) {
  Transaction input = Transaction(
    title: 'Title',
    description: 'Description',
    category: 'Category',
    amount: 0.0,
    expense: false,
    dateTime: DateTime.now(),
  );
  return BlocProvider.value(
    value: BlocProvider.of<TransactionBloc>(currContext),
    child: AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                decoration: InputDecoration(hintText: 'Transaction Title'),
                onChanged: (val) {
                  input.title = val;
                }),
            TextField(
              decoration: InputDecoration(hintText: 'Description'),
              onChanged: (val) {
                input.description = val;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Amount'),
              onChanged: (val) {
                input.amount = double.parse(val);
              },
            ),
            DropdownButtonFormField<String>(
              hint: Text(categoryList.length == 0
                  ? 'No category added'
                  : 'Select Category'),
              items: categoryList.map((c) {
                print(c);
                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );
              }).toList(),
              onChanged: (val) {
                input.category = val ?? "Category";
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            DateTimepicker(
              function: (DateTime time) {
                input.dateTime = time;
              },
            ),
          ],
        ),
      ),
      actions: [
        Text(
          'Add as: ',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(widgetContext).pop();
            print(input);
            addEvent(input);
          },
          child: Text('Income'),
          color: Colors.blueAccent,
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(widgetContext).pop();
            print(input);
            input.expense = true;
            addEvent(input);
          },
          child: Text('Expense'),
          color: Colors.blueAccent,
        )
      ],
    ),
  );
}

Widget selectCategoryWidget(BuildContext currContext, List<String> categoryList,
    String currCategory, double height, double width, Function addEvent) {
  print('category list : $categoryList');
  return AlertDialog(
    title: Text('Select Category'),
    content: Container(
      height: height * 0.5,
      width: width * 0.7,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == categoryList.length) {
            return ListTile(
                title: Text("All Categories"),
                onTap: () {
                  addEvent("All Categories");
                  Navigator.of(context).pop();
                });
          }
          return ListTile(
              title: Text(categoryList[index]),
              onTap: () {
                addEvent(categoryList[index]);
                Navigator.of(context).pop();
              });
        },
        itemCount: categoryList.length + 1,
      ),
    ),
    scrollable: true,
  );
}

class DateTimepicker extends StatefulWidget {
  final Function function;
  DateTimepicker({required this.function});
  @override
  _DateTimepickerState createState() => _DateTimepickerState();
}

class _DateTimepickerState extends State<DateTimepicker> {
  DateTime input = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2022))
                .then((date) {
              print(date);
              setState(() {
                input = date ?? DateTime.now();
                widget.function(input);
              });
            });
          },
        ),
        Text(
          input.day.toString() +
              '-' +
              input.month.toString() +
              '-' +
              input.year.toString(),
          style: TextStyle(fontSize: 18.0),
        )
      ],
    );
  }
}
