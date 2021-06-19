import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chartbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentDay;
  Chart(this.recentDay) {
    print('Constructor Chart');
  }
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (int i = 0; i < recentDay.length; i++) {
        if (recentDay[i].date.day == weekDay.day &&
            recentDay[i].date.month == weekDay.month &&
            recentDay[i].date.year == weekDay.year) {
          totalSum += recentDay[i].amount;
        }
      }

      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 1),
        'Amount': totalSum
      };
      //DateFormat.E() the class from intl tell me what the day
    }).reversed.toList();
    //if you Want start the week from right  to left Write .reversed.toList() at the end of the method of the days
    //here
  }

  double get totalSpending {
    //fold for return value i want calculate it
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      data['Day'],
                      data['Amount'],
                      totalSpending == 0.0
                          ? 0.0
                          : (data['Amount'] as double) / (totalSpending)));
            }).toList(),
          )),
    );
  }
}
