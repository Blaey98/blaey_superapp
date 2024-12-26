import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'pages/messages_page.dart';
import 'pages/fun_page.dart';
import 'pages/wallet_page.dart';
import 'pages/notifications_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Blaey App',
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[900], // Modo escuro
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system, // Altera para o modo do sistema
          home: HomePage().animate().fadeIn(duration: Duration(seconds: 1)), // Animação de fade-in para HomePage
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double userBalance = 100.0;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MessagesPage(),
    FunPage(userBalance: 100.0),
    WalletPage(),
    NotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: _pages[_selectedIndex].animate().fadeIn(duration: Duration(milliseconds: 500)), // Animação de fade-in para páginas
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.message, 0),
            label: 'Mensagem',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.dashboard_customize_outlined, 1), // Ícone de jogo
            label: 'Diversão', // Rótulo alterado para "Diversão"
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.account_balance_wallet, 2),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications, 3),
            label: 'Notificações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87, // Preto claro para o item selecionado
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 30.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.black87, // Preto claro para o texto selecionado
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12.0,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Remove a sombra abaixo do menu
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.green[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
      child: Icon(
        iconData,
        size: 25.0,
        color: _selectedIndex == index ? Colors.green[900] : Colors.black54,
      ),
    ).animate().scale(duration: Duration(milliseconds: 500)); // Animação de escala para ícones
  }
}