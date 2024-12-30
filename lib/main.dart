import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Importações únicas
import 'pages/gamepage_dama.dart'; // Importar a página do jogo de damas com o nome correto
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
            appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[900],
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(
              color: Colors.grey[900],
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          themeMode: ThemeMode.system,
          home: HomePage().animate().fadeIn(duration: Duration(seconds: 1)),
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
            color: Colors.white,
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: _pages[_selectedIndex].animate().fadeIn(duration: Duration(milliseconds: 500)),
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
            icon: _buildIcon(Icons.dashboard_customize_outlined, 1),
            label: 'Diversão',
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
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 30.0,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.black87,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12.0,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.green[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 16.0.w),
      child: Icon(
        iconData,
        size: 25.0,
        color: _selectedIndex == index ? Colors.green[900] : Colors.black54,
      ),
    ).animate().scale(duration: Duration(milliseconds: 500));
  }
}