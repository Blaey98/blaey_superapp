import 'package:flutter/material.dart';

class ChatSecundarioPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {'username': 'User1', 'message': 'Olá!', 'time': '10:00 AM'},
    {'username': 'User2', 'message': 'Como vai?', 'time': '09:30 AM'},
    {'username': 'User3', 'message': 'Oi, tudo bem?', 'time': '09:00 AM'},
    {'username': 'User4', 'message': 'Vamos conversar?', 'time': '08:30 AM'},
    {'username': 'User5', 'message': 'Bom dia!', 'time': '08:00 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Secundário'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
            color: Colors.white, // Fundo branco para a mensagem
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/icons/user.png'),
              ),
              title: Text(
                users[index]['username'] ?? 'Desconhecido', // Verificação de null
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                users[index]['message'] ?? '', // Verificação de null
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    users[index]['time'] ?? '', // Verificação de null
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
              onTap: () {
                // Lógica ao clicar no usuário
              },
            ),
          );
        },
      ),
    );
  }
}