import 'package:flutter/material.dart';

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