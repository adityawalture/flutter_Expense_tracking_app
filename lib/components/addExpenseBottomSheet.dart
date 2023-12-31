import 'dart:io';

import 'package:expense_tracker/components/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  //to take input String from user
  final _inputText = TextEditingController();
  final _inputAmount = TextEditingController();
  Category? _selectedCategory;

  @override
  void dispose() {
    _inputText.dispose();
    _inputAmount.dispose();
    super.dispose();
  }

//function to pick a date
  DateTime? _selectedDate;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.day, now.month, now.year - 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    "Please enter a valid title, date, amount and category"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("close"),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please enter a valid title, date, amount and category"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("close"),
            ),
          ],
        ),
      );
    }
  }

  //function for adding expense to home pg
  void _addExpense() {
    final enteredAmount = double.tryParse(
        _inputAmount.text); //tryParse will convert string into double
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_inputText.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //show error

      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _inputText.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory!,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final landScapeKeyboard = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      //it configures ui according to the screen layout

      // print(constraints.minWidth);
      // print(constraints.maxWidth);
      // print(constraints.minHeight);
      // print(constraints.maxHeight);
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, landScapeKeyboard + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputText,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            hintText: "Add a expense",
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _inputAmount,
                          decoration: const InputDecoration(
                            prefixText: "₹ ",
                            hintText: "Amount",
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _inputText,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      hintText: "Add a expense",
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(4.0),
                          hint: const Text("Type"),
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(categoryIcons[category]),
                                        //const SizedBox(width: 4),
                                        Text(
                                          category.name.toUpperCase(),
                                        ),
                                      ],
                                    )),
                              )
                              .toList(), //if the dropdown has a value selected it will change in set state
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                            Text(
                              _selectedDate == null
                                  ? "No Date Selected"
                                  : formatter.format(_selectedDate!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _inputAmount,
                          decoration: const InputDecoration(
                            prefixText: "₹ ",
                            hintText: "Amount",
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                            Text(
                              _selectedDate == null
                                  ? "No Date Selected"
                                  : formatter.format(_selectedDate!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 5),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: const Text("Cancel"),
                      // ),
                      ElevatedButton(
                        onPressed: _addExpense,
                        child: const Text("Add Expense"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // const SizedBox(width: 5),
                      DropdownButton(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(4.0),
                          hint: const Text("Type"),
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(categoryIcons[category]),
                                        //const SizedBox(width: 4),
                                        Text(
                                          category.name.toUpperCase(),
                                        ),
                                      ],
                                    )),
                              )
                              .toList(), //if the dropdown has a value selected it will change in set state
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _addExpense,
                        child: const Text("Add Expense"),
                      )
                    ],
                  ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
