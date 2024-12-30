import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profile_page.dart' as profile; // Usar alias para evitar conflito
import 'trophies_page.dart';
import 'friend_profile_page.dart' as friendProfile;
import 'store_page.dart';
import 'waiting_for_player_page.dart'; // Importe a classe WaitingForPlayerPage
import 'filter_dialog.dart'; // Importar a página de filtro
import 'blaey_page.dart'; // Importar BlaeyPage

class FunPage extends StatefulWidget {
  final double userBalance;

  FunPage({required this.userBalance});

  @override
  _FunPageState createState() => _FunPageState();
}

class _FunPageState extends State<FunPage> {
  bool isOnline = true;
  bool isDarkMode = false;
  String? _selectedOption;
  String? _selectedBettingMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Diversão',
              style: TextStyle(fontSize: 23.sp),
            ),
            Row(
              children: [
                Text(
                  '\$${widget.userBalance.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(width: 2.w),
                Image.asset(
                  'assets/icons/moeda.png',
                  width: 24.w,
                  height: 24.h,
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorePage(updateBalance: (amount) {})),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Icon(
                Icons.store,
                size: 30.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => profile.ProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 27.r,
                          backgroundColor: const Color(0xFFE7DFEC), // Cor de fundo do círculo
                          backgroundImage: AssetImage('assets/icons/perfil.png'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 26.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem-vindo de volta',
                          style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                        ),
                        Text(
                          'Jeff',
                          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrophiesPage()),
                      );
                    },
                    child: Icon(
                      Icons.emoji_events,
                      size: 33.sp,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () {
                      // Adicione aqui a navegação para sua página de ranking
                    },
                    child: Icon(
                      Icons.leaderboard,
                      size: 31.sp,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 29.h),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEDEDED),
                  hintText: 'Encontre um amigo ou um jogo',
                  hintStyle: TextStyle(fontSize: 13.sp),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Image.asset(
                      'assets/images/pesquisa.png',
                      width: 26.w,
                      height: 26.h,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(31.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sala de jogos',
                    style: TextStyle(fontSize: 29.sp, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  Transform.translate(
                    offset: Offset(-21.w, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 3.0.w),
                        borderRadius: BorderRadius.circular(17.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green,
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.tune_sharp, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(10.w),
                                child: FilterDialog(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21.h),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 11.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 11.5.sp, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                height: 90.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    String userName;
                    String imagePath;
                    Widget nextPage;

                    // Definindo os nomes e imagens dos usuários
                    if (index == 0) {
                      userName = 'Blaey';
                      imagePath = 'assets/icons/app_icon.png';
                      nextPage = BlaeyPage(); // Página BlaeyPage para Blaey
                    } else {
                      userName = 'username';
                      imagePath = 'assets/icons/user.png';
                      nextPage = friendProfile.FriendProfilePage(userName); // Página FriendProfilePage para outros usuários
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => nextPage,
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 28.r,
                              backgroundImage: AssetImage(imagePath),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            userName,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.timelapse,
                    color: Colors.black12,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Recentes',
                    style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black12),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                height: 140.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final recentGames = [
                      {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
                      {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
                      {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
                    ];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaitingForPlayerPage(gameTitle: recentGames[index]['name']!),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.r),
                          child: Image.asset(
                            recentGames[index]['image']!,
                            width: 148.w,
                            height: 148.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 26.h),
              Row(
                children: [
                  Icon(
                    Icons.timeline_sharp,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Estatísticas',
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 26.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatisticCard('Semana', '5 jogos'),
                  _buildStatisticCard('Mês', '20 jogos'),
                  _buildStatisticCard('Ano', '200 jogos'),
                ],
              ),
              SizedBox(height: 26.h),
              Row(
                children: [
                  Icon(
                    Icons.videogame_asset_outlined,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Todos os jogos',
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 19.h),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7.w,
                  mainAxisSpacing: 24.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final allGames = [
                    {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
                    {'image': 'assets/jogos/truco.png', 'name': 'Truco'},
                    {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
                    {'image': 'assets/jogos/jogo_da_velha.png', 'name': 'Jogo da Velha'},
                    {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingForPlayerPage(gameTitle: allGames[index]['name']!),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3.r),
                          child: Image.asset(
                            allGames[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          allGames[index]['name']!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String count) {
    return Container(
      padding: EdgeInsets.all(8.w),
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 9.h),
          Text(
            count,
            style: TextStyle(fontSize: 12.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}