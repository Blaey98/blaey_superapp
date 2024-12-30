import 'package:flutter/material.dart';

class UpgradePontoDeRecargaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade Ponto de Recarga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ganhe moedas sem anúncios!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Com a Recarga Pró, você não precisa perder seu tempo com anúncios:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '- Clicou, recebeu instantaneamente!\n- Até 400 Moedas a cada 2 hrs\n- Maior conforto e tranquilidade',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              'Teste grátis por 7 dias, depois R\$ 19,90/mês.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecargaProPage()),
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 32, vertical: 16)), // Aumenta o padding do botão
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)), // Aumenta o tamanho do texto
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                  ),
                ),
                // Degradê dourado
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.transparent; // Deixa transparente para aplicar o degradê
                  },
                ),
                shadowColor: MaterialStateProperty.all(Colors.transparent), // Remove a sombra padrão
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Degradê do dourado para o laranja
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'Testar Grátis por 7 dias',
                    style: TextStyle(color: Colors.black), // Texto preto
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecargaProPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recarga Pró'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Recarga Pró!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
