import 'package:flutter/material.dart';
import 'profile_page.dart'; // Certifique-se de que este arquivo existe

class MessagesPage extends StatelessWidget {
  final String userPhotoUrl = "https://via.placeholder.com/150"; // Use uma URL válida

  final List<Map<String, String>> messages = [
    {'sender': 'Alice', 'message': 'Oi, como você está?'},
    {'sender': 'Bob', 'message': 'Vamos nos encontrar amanhã?'},
    {'sender': 'Charlie', 'message': 'Não se esqueça da reunião às 10h.'},
    {'sender': 'David', 'message': 'Você viu o último episódio?'},
    {'sender': 'Eve', 'message': 'Parabéns pelo seu trabalho!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Ajuste para maior destaque
        child: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'blaey', // Texto à esquerda
            style: TextStyle(
              fontSize: 30, // Maior tamanho para destaque
              fontWeight: FontWeight.bold,
              color: Colors.green, // Texto em verde
            ),
          ),
          titleSpacing: 16.0, // Espaço à esquerda do texto
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userPhotoUrl),
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.more_vert, size: 28),
              onPressed: () {
                // Adicione a lógica aqui
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            elevation: 3, // Adiciona uma sombra sutil
            color: Colors.white, // Fundo branco para a mensagem
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/icons/user.png'),
              ),
              title: Text(
                messages[index]['sender']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                messages[index]['message']!,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              onTap: () {
                // Ação ao tocar na mensagem
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para abrir a lista de amigos
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, size: 30, color: Colors.white), // Ícone "+" em branco
        elevation: 6.0, // Adiciona uma sombra ao botão
      ),
    );
  }
}
