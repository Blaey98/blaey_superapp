import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'chat_page.dart';
import 'chat_secundario_page.dart';
import 'notas_page.dart';

class MessagesPage extends StatelessWidget {
  final String userPhotoUrl = "assets/icons/perfil.png"; // Use a imagem do perfil correta

  final List<Map<String, String>> messages = [
    {'sender': 'Alice', 'message': 'Oi, como você está?', 'time': '10:00 AM'},
    {'sender': 'Bob', 'message': 'Vamos nos encontrar amanhã?', 'time': '09:00 AM'},
    {'sender': 'Charlie', 'message': 'Não se esqueça da reunião às 10h.', 'time': '08:30 AM'},
    {'sender': 'David', 'message': 'Você viu o último episódio?', 'time': '08:00 AM'},
    {'sender': 'Eve', 'message': 'Parabéns pelo seu trabalho!', 'time': '07:30 AM'},
  ];

  final List<Map<String, dynamic>> stories = [
    {'user': 'Atualize', 'image': 'assets/icons/plus.png'},
    {'user': 'Alice', 'image': 'assets/icons/user.png'},
    {'user': 'Bob', 'image': 'assets/icons/user.png'},
    {'user': 'Charlie', 'image': 'assets/icons/user.png'},
    {'user': 'David', 'image': 'assets/icons/user.png'},
    {'user': 'Eve', 'image': 'assets/icons/user.png'},
    {'user': 'Frank', 'image': 'assets/icons/user.png'},
    {'user': 'Grace', 'image': 'assets/icons/user.png'},
    {'user': 'Heidi', 'image': 'assets/icons/user.png'},
    {'user': 'Ivan', 'image': 'assets/icons/user.png'},
    {'user': 'Judy', 'image': 'assets/icons/user.png'},
    {'user': 'Mallory', 'image': 'assets/icons/user.png'},
    {'user': 'Niaj', 'image': 'assets/icons/user.png'},
    {'user': 'Oscar', 'image': 'assets/icons/user.png'},
    {'user': 'Peggy', 'image': 'assets/icons/user.png'},
    {'user': 'Sybil', 'image': 'assets/icons/user.png'},
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
            IconButton(
              icon: const Icon(Icons.note, size: 28, color: Colors.black54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotasPage()),
                );
              },
            ),
            SizedBox(width: 16), // Espaçamento entre ícones
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE7DFEC), // Cor de fundo do círculo
                backgroundImage: AssetImage(userPhotoUrl),
              ),
            ),
            SizedBox(width: 16), // Espaçamento entre ícones
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // Adicione a lógica aqui
              },
            ),
            const SizedBox(width: 12), // Espaçamento final
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrossel de Stories
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage(stories[index]['image']),
                        child: stories[index]['image'] == 'assets/icons/plus.png'
                            ? Icon(Icons.add, color: Colors.black, size: 30)
                            : null,
                      ),
                      SizedBox(height: 4),
                      Text(
                        stories[index]['user'] ?? 'Desconhecido',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 24, // Definir a largura do ícone de pesquisa
                    height: 24, // Definir a altura do ícone de pesquisa
                    child: Image.asset('assets/images/pesquisa.png'),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.all(15.0),
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Texto "Conversas" com ícone de chat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conversas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navega para a página de mensagem secundária
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatSecundarioPage()),
                    );
                  },
                  child: Icon(
                    Icons.chat,
                    color: Colors.green,
                    size: 30, // Aumenta o tamanho do ícone
                  ),
                ),
              ],
            ),
          ),
          // Lista de Conversas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: Colors.white, // Fundo branco para a mensagem
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24, // Aumenta o tamanho do ícone do usuário
                      backgroundImage: AssetImage('assets/icons/user.png'),
                    ),
                    title: Text(
                      messages[index]['sender'] ?? 'Desconhecido', // Verificação de null
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      messages[index]['message'] ?? '', // Verificação de null
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          messages[index]['time'] ?? '', // Verificação de null
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            friendName: messages[index]['sender']!,
                            friendPhotoUrl: 'https://via.placeholder.com/150', // Placeholder para foto do amigo
                            isOnline: true, // Supondo que o amigo está online
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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

// Página de mensagem secundária (exemplo)
class ChatSecundarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Secundário'),
      ),
      body: Center(
        child: Text('Conteúdo do Chat Secundário'),
      ),
    );
  }
}



// Página de notas (exemplo)
class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _items = [];

  void _addItem() {
    final String todo = _todoController.text;
    final String note = _noteController.text;

    if (todo.isNotEmpty || note.isNotEmpty) {
      setState(() {
        _items.add({'todo': todo, 'note': note});
      });
      _todoController.clear();
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                labelText: 'To-Do',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Nota',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Adicionar'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(_items[index]['todo'] ?? ''),
                      subtitle: Text(_items[index]['note'] ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}