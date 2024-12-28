import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedOption;
  String? _selectedBettingMode;
  bool isOnline = true;
  bool isDarkMode = false;
  bool isPrivateProfile = false; // Variável para controlar o estado do perfil privado

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0), // Bordas mais arredondadas
      ),
      backgroundColor: Colors.white, // Garantindo que o fundo do diálogo seja branco
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), // Espaçamento interno maior
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0), // Espaçamento maior nas bordas
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Painel de Controle', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)), // Fonte menor
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black87),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    indicatorColor: Colors.green,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings, color: Colors.black87),
                            SizedBox(width: 4.0), // Espaço entre o ícone e o texto
                            Text('', style: TextStyle(color: Colors.black87, fontSize: 14.0)), // Fonte menor
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videogame_asset_outlined, color: Colors.black87),
                            SizedBox(width: 8.0), // Espaço entre o ícone e o texto
                            Text('', style: TextStyle(color: Colors.black87, fontSize: 14.0)), // Fonte menor
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Container(
                    height: 450.0, // Aumentando a altura do container
                    width: MediaQuery.of(context).size.width * 0.95, // Ajuste da largura para caber melhor na tela
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
                    ),
                    child: TabBarView(
                      children: [
                        _buildSettingsTab(),
                        _buildGamesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Visibilidade', style: TextStyle(fontSize: 14.0)), // Fonte menor
            value: isOnline,
            onChanged: (value) {
              setState(() {
                isOnline = value;
              });
            },
            secondary: Icon(
              Icons.circle,
              color: isOnline ? Colors.green : Colors.grey,
            ),
          ),
          SwitchListTile(
            title: Text('Perfil Privado', style: TextStyle(fontSize: 14.0)), // Nova opção para perfil privado
            value: isPrivateProfile,
            onChanged: (value) {
              setState(() {
                isPrivateProfile = value;
              });
            },
            secondary: Icon(
              isPrivateProfile ? Icons.lock : Icons.lock_open,
            ),
          ),
          SwitchListTile(
            title: Text('Modo Escuro', style: TextStyle(fontSize: 14.0)), // Fonte menor
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            secondary: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
            ),
          ),
          Divider(),
          Text('Modo de Aposta', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)), // Fonte menor
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: 'Negociada',
                groupValue: _selectedBettingMode,
                onChanged: (value) {
                  setState(() {
                    _selectedBettingMode = value;
                  });
                },
              ),
              Text('Negociada', style: TextStyle(fontSize: 14.0)), // Fonte menor
              Radio<String>(
                value: 'Direta',
                groupValue: _selectedBettingMode,
                onChanged: (value) {
                  setState(() {
                    _selectedBettingMode = value;
                  });
                },
              ),
              Text('Direta', style: TextStyle(fontSize: 14.0)), // Fonte menor
            ],
          ),
          Divider(),
          ListTile(
            title: Text('Notificações', style: TextStyle(fontSize: 14.0)), // Fonte menor
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            title: Text('Privacidade', style: TextStyle(fontSize: 14.0)), // Fonte menor
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            title: Text('Idioma', style: TextStyle(fontSize: 14.0)), // Fonte menor
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGamesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGameSection('Dama', ['1 min', '3 min', '5 min'], 'assets/jogos/dama.png'),
            Divider(),
            _buildGameSection('Xadrez', ['1 min', '3 min', '5 min'], 'assets/jogos/xadrez.png'),
            Divider(),
            _buildGameSection('Ludo', ['Rápido', 'Tradicional'], 'assets/jogos/ludo.png'),
            Divider(),
            _buildGameSection('Truco', ['Manilha Velha', 'Manilha Nova'], 'assets/jogos/truco.png'),
            Divider(),
            _buildGameSection('Jogo da Velha', ['1x', '3x', '5x'], 'assets/jogos/jogo_da_velha.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSection(String gameTitle, List<String> options, String imagePath) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gameTitle,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), // Fonte menor
            ),
            SizedBox(width: 8.0),
            Image.asset(
              imagePath,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: options.map((option) {
            return Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
                Text(option, style: TextStyle(fontSize: 14.0)), // Fonte menor
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}