import 'package:flutter/material.dart';

class BalancePage extends StatelessWidget {
  final double userBalance;

  BalancePage({required this.userBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seu Saldo'),
      ),
      body: Center(
        child: Text(
          'Saldo Atual: \$${userBalance.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}