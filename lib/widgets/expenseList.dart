// ignore_for_file: file_names
import 'package:expense_tracker/components/expense.dart';
import 'package:expense_tracker/widgets/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.error.withOpacity(0.70),
          ),
        ),
        key: ValueKey(
          expenses[index],
        ),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItems(
          expenses[index],
        ),
      ),
    );
  }
}
