import 'package:expense_tracker/components/addExpenseBottomSheet.dart';
import 'package:expense_tracker/components/expense.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/expenseList.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> registeredExpenses = [];

//void function for button in appbar adding expenses
  void _addExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpenses(
        onAddExpense: _addExpense,
      ),
    );
  }

  //adds a expense to the home screen
  void _addExpense(Expense expense) {
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  //removes a expense from home screen
  void _removeExpense(Expense expense) {
    final expenseIndex = registeredExpenses.indexOf(expense);
    setState(() {
      registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("expense deleted"),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //width variable stores the device screen width if the screen size is more then 600 than the column will switch to row
    final width = MediaQuery.of(context).size.width;
    Widget displayContent = const Center(
      child: Text("Add a Expense"),
    );

    if (registeredExpenses.isNotEmpty) {
      //if the homeScreen dont have any itemList then it will show a messsage "Add a expense"
      displayContent = ExpenseList(
        expenses: registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _addExpensesOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: registeredExpenses),
                Expanded(child: displayContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: displayContent),
                Expanded(child: Chart(expenses: registeredExpenses)),
              ],
            ),
    );
  }
}
