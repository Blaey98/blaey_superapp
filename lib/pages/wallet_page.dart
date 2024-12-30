import 'package:flutter/material.dart';
import 'dart:async';
import 'subscription_page.dart';
import 'rewarded_ad_page.dart';
import 'bonus_page.dart';
import 'store_page.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'recarga_pro.dart';
import 'package:audioplayers/audioplayers.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  double userBalance = 0.0;
  int currentLevel = 1;
  int adsWatched = 0;
  Timer? levelTimer;
  Timer? checkpointTimer;
  Timer? regressionTimer;
  bool isWatchingAd = false;
  bool isAtCheckpoint = false;
  bool showLevelText = false;
  bool showCoinAnimation = false;
  late AnimationController _progressController;
  late AnimationController _coinController;
  late AnimationController _balanceController;
  late AnimationController _flashController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _coinAnimation;
  late Animation<Color?> _balanceColorAnimation;
  late Animation<double> _flashAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Adiciona o AudioPlayer
  final AudioCache _audioCache = AudioCache(prefix: 'assets/som/'); // Adiciona o AudioCache

  static const int level1Ads = 4;
  static const int level2Ads = 6;
  static const int level3Ads = 8;
  static const int checkpointDelaySeconds = 30;
  static const int regressionIntervalSeconds = 60;

  @override
  void initState() {
    super.initState();
    startLevelTimer();

    // Initialize the animation controllers
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _coinController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _balanceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _flashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Initialize the animations
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _coinAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, -2)).animate(_coinController);
    _balanceColorAnimation = ColorTween(begin: Colors.black54, end: Colors.green)
        .animate(CurvedAnimation(parent: _balanceController, curve: Curves.easeInOut));
    _flashAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_flashController);

    // Pré-carregar sons
    _audioCache.loadAll(['move_sound.mp3', 'moeda.mp3']);

    startProgressRegression();
  }

  @override
  void dispose() {
    levelTimer?.cancel();
    checkpointTimer?.cancel();
    regressionTimer?.cancel();
    _progressController.dispose();
    _coinController.dispose();
    _balanceController.dispose();
    _flashController.dispose();
    _audioPlayer.dispose(); // Dispose o AudioPlayer
    super.dispose();
  }

  void startLevelTimer() {
    levelTimer?.cancel();
    levelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint) {
        if (adsWatched > 0) {
          setState(() {
            isAtCheckpoint = true;
            checkpointTimer = Timer(Duration(seconds: checkpointDelaySeconds), () {
              regressionTimer = Timer.periodic(Duration(seconds: regressionIntervalSeconds), (timer) {
                if (!isWatchingAd && adsWatched > 0) {
                  setState(() {
                    adsWatched--;
                    _progressController.reverse(from: _progressController.value);
                  });
                } else {
                  regressionTimer?.cancel();
                }
              });
              isAtCheckpoint = false;
            });
          });
        } else if (currentLevel > 1) {
          setState(() {
            currentLevel--;
            adsWatched = currentLevel == 2 ? level1Ads : currentLevel == 3 ? level2Ads : level3Ads;
            _showLevelUpMessage("Nível $currentLevel");
          });
        }
      }
    });
  }

  void startProgressRegression() {
    regressionTimer?.cancel();
    regressionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint && _progressController.value > 0) {
        setState(() {
          _progressController.value -= 1 / regressionIntervalSeconds;
        });
      }
    });
  }

  void _addReward(double reward) {
    setState(() {
      userBalance += reward;
      _balanceController.forward().then((_) {
        _balanceController.reverse();
      });

      // Toca o som de recompensa
      _audioCache.play('moeda.mp3');
    });
  }

  void _watchAd() async {
    isWatchingAd = true;
    final reward = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RewardedAdPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    isWatchingAd = false;

    if (reward != null) {
      setState(() {
        showCoinAnimation = true;

        if (currentLevel == 3 && adsWatched >= level3Ads) {
        } else {
          adsWatched++;
        }

        _progressController.forward(from: _progressController.value);
        _flashController.forward().then((_) {
          _flashController.reverse();
        });

        if (currentLevel == 1 && adsWatched >= level1Ads) {
          _showLevelUpMessage("Nível 2");
          currentLevel = 2;
          adsWatched = 0;
        } else if (currentLevel == 2 && adsWatched >= level2Ads) {
          _showLevelUpMessage("Nível 3");
          currentLevel = 3;
          adsWatched = 0;
        } else if (currentLevel == 3 && adsWatched >= level3Ads) {
          setState(() {
            adsWatched = level3Ads;
          });
        }

        _coinController.reset();
        _coinController.forward().then((_) {
          _addReward(currentLevel.toDouble());
          setState(() {
            showCoinAnimation = false;
          });
        });
      });
    }
  }

  void _showLevelUpMessage(String message) {
    setState(() {
      showLevelText = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        showLevelText = false;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Carteira',
            style: TextStyle(fontSize: 23),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _balanceColorAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Saldo atual:',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 0),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/moeda.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '\$${userBalance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: userBalance >= 100 ? 40 : 60,
                                    fontWeight: FontWeight.bold,
                                    color: _balanceColorAnimation.value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 0), // Reduz a distância entre o saldo e o bloco de imagens
                _buildImageBlock(),
                SizedBox(height: 1),
                _buildRechargePoint(context),
              ],
            ),
            if (showCoinAnimation)
              AnimatedBuilder(
                animation: _coinController,
                builder: (context, child) {
                  return Positioned(
                    top: 100 + (_coinAnimation.value.dy * 200),
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Row(
                      children: [
                        Text(
                          "+\$${currentLevel.toDouble().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 1),
                        Image.asset(
                          'assets/icons/moeda.png',
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  );
                },
              ),
            Center(
              child: Visibility(
                visible: showLevelText,
                child: Text(
                  currentLevel == 2 ? "Nível 2" : currentLevel == 3 ? "Nível 3" : "",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecargaProPage()),
              );
            },
            backgroundColor: const Color(0xFFFFCE1F),
            elevation: 0,
            child: Image.asset(
              'assets/icons/recargapro.png',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: -30,
            right: 10,
            child: Text(
              'Teste Grátis',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildImageBlock() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconColumn(
            iconPath: 'assets/icons/convite.png',
            radius: 40,
            width: 60,
            height: 130,
            onTap: () {
              // Ação para Convite
            },
          ),
          SizedBox(width: 1),
          _buildIconColumn(
            iconPath: 'assets/icons/bonus.png',
            radius: 73,
            width: 180,
            height: 200,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BonusPage()),
              );
            },
          ),
          SizedBox(width: 1),
          _buildIconColumn(
            iconPath: 'assets/icons/loja.png',
            radius: 73,
            width: 180,
            height: 200,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorePage(updateBalance: _addReward)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn({
    required String iconPath,
    required double radius,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: Image.asset(iconPath, width: width, height: height),
      ),
    );
  }

  Widget _buildRechargePoint(BuildContext context) {
    int totalAds = currentLevel == 1 ? level1Ads : currentLevel == 2 ? level2Ads : level3Ads;

    Color progressColor;
    switch (currentLevel) {
      case 1:
        progressColor = Colors.blue;
        break;
      case 2:
        progressColor = Colors.red;
        break;
      case 3:
        progressColor = Colors.black;
        break;
      default:
        progressColor = Colors.blue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 29),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Nível $currentLevel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: progressColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Text(
              'Período',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '+\$${currentLevel.toDouble().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 2),
                Image.asset(
                  'assets/icons/moeda.png',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.schedule, size: 20),
                SizedBox(width: 4),
                Text(
                  '$adsWatched/$totalAds',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 19),
        Center(
          child: GestureDetector(
            onTap: _watchAd,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 195,
                      child: CircularProgressIndicator(
                        value: adsWatched / totalAds,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        strokeWidth: 15,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -10,
                        color: progressColor,
                        boxShape: NeumorphicBoxShape.circle(),
                        lightSource: LightSource.topLeft,
                        shadowLightColorEmboss: Colors.white,
                        shadowDarkColorEmboss: Colors.black.withOpacity(0.7),
                      ),
                      child: Container(
                        width: 170,
                        height: 170,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 120,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Página RecargaProPage
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