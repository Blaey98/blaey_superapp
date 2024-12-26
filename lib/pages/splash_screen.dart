import 'package:flutter/material.dart';
import 'dart:async'; // Para usar o Timer
import 'messages_page.dart'; // Importando a tela de mensagens
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configurando a animação
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Timer para esperar 3 segundos antes de ir para a MessagesScreen
    Timer(Duration(seconds: 3), () {
      // Redireciona para a primeira tela, MessagesScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MessagesScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Cor de fundo da splash
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/icon_transparente.png',
                width: 150.w, // Usando ScreenUtil para responsividade
                height: 150.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Blaey App', // Nome do seu app na tela de splash
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}