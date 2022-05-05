import 'package:flutter_auth/t_page/constant.dart';
import 'package:flutter_auth/t_page/amount_box.dart';
import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer(
      {Key? key, required this.totalExpense, required this.totalIncome})
      : super(key: key);
  final int totalExpense;
  final int totalIncome;
  @override
  Widget build(BuildContext context) {
    int saving = totalIncome + totalExpense;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(20),
      height: height * 0.3,
      width: width * 0.9,
      decoration: BoxDecoration(
        gradient: kGradient,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Total Transactions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.0,
            ),
          ),
          Text(
           "KES " + saving.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountBox(
                    icon: Icons.arrow_downward_rounded,
                    iconColor: Colors.green,
                    title: 'Income',
                    amount: "KES " + totalIncome.toStringAsFixed(2)),
                AmountBox(
                    icon: Icons.arrow_upward_rounded,
                    iconColor: Colors.red,
                    title: 'Expense',
                    amount: "KES " +totalExpense.toStringAsFixed(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
