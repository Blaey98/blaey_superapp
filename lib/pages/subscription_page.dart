import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plano de Assinatura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha seu Plano de Assinatura',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SubscriptionPlan(
              title: 'Plano Básico',
              price: 'R\$ 19,99/mês',
              features: ['Acesso básico', 'Suporte por e-mail'],
            ),
            SubscriptionPlan(
              title: 'Plano Padrão',
              price: 'R\$ 39,99/mês',
              features: ['Acesso completo', 'Suporte 24/7', 'Acesso a eventos'],
            ),
            SubscriptionPlan(
              title: 'Plano Premium',
              price: 'R\$ 59,99/mês',
              features: ['Acesso completo', 'Suporte prioritário', 'Acesso exclusivo a novos recursos'],
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPlan extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;

  SubscriptionPlan({required this.title, required this.price, required this.features});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => Text('• $feature')).toList(),
            ),
          ],
        ),
      ),
    );
  }
}