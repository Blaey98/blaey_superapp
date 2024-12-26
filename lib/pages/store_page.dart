import 'package:flutter/material.dart';

class StorePage extends StatelessWidget {
  final Function(double) updateBalance;

  StorePage({required this.updateBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loja'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comprar Moedas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.amber, size: 40),
              title: Text('100 Moedas'),
              subtitle: Text('\$1.99'),
              trailing: ElevatedButton(
                onPressed: () {
                  updateBalance(100.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você comprou 100 Moedas!')),
                  );
                },
                child: Text('Comprar'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.amber, size: 40),
              title: Text('500 Moedas'),
              subtitle: Text('\$8.99'),
              trailing: ElevatedButton(
                onPressed: () {
                  updateBalance(500.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você comprou 500 Moedas!')),
                  );
                },
                child: Text('Comprar'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Comprar Presentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.card_giftcard, color: Colors.red, size: 40),
              title: Text('Presente Pequeno'),
              subtitle: Text('50 Moedas'),
              trailing: ElevatedButton(
                onPressed: () {
                  updateBalance(-50.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você comprou um Presente Pequeno!')),
                  );
                },
                child: Text('Comprar'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard, color: Colors.red, size: 40),
              title: Text('Presente Grande'),
              subtitle: Text('200 Moedas'),
              trailing: ElevatedButton(
                onPressed: () {
                  updateBalance(-200.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você comprou um Presente Grande!')),
                  );
                },
                child: Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}