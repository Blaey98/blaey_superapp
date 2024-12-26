import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profile_page.dart';
import 'trophies_page.dart';
import 'friend_profile_page.dart';
import 'store_page.dart';
import 'waiting_for_player_page.dart';
import 'negotiation_page.dart';
import 'gamepage_dama.dart';

class FunPage extends StatelessWidget {
  final double userBalance;

  FunPage({required this.userBalance});

  @override
  Widget build(BuildContext context) {
    final String userName = "Jeff";
    final String userPhotoUrl = "https://via.placeholder.com/150"; // Use uma URL válida

    final List<Map<String, String>> friends = [
      {'name': 'Blaey', 'photoUrl': 'assets/icons/app_icon.png'},
      {'name': 'Bob', 'photoUrl': 'assets/icons/user.png'},
      {'name': 'Charlie', 'photoUrl': 'assets/icons/user.png'},
      {'name': 'David', 'photoUrl': 'assets/icons/user.png'},
      {'name': 'Eve', 'photoUrl': 'assets/icons/user.png'},
    ];

    final List<Map<String, String>> recentGameImages = [
      {'image': 'assets/jogos/dama.png'},
      {'image': 'assets/jogos/xadrez.png'},
      {'image': 'assets/jogos/ludo.png'},
    ];

    final List<Map<String, String>> recentPlayers = [
      {'name': 'Alice', 'photoUrl': 'assets/icons/user.png'},
      {'name': 'John', 'photoUrl': 'assets/icons/user.png'},
      {'name': 'Mia', 'photoUrl': 'assets/icons/user.png'},
    ];

    final List<Map<String, String>> allGames = [
      {'image': 'assets/jogos/dama.png', 'name': 'Dama'},
      {'image': 'assets/jogos/truco.png', 'name': 'Truco'},
      {'image': 'assets/jogos/xadrez.png', 'name': 'Xadrez'},
      {'image': 'assets/jogos/jogo_da_velha.png', 'name': 'Jogo da Velha'},
      {'image': 'assets/jogos/ludo.png', 'name': 'Ludo'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saldo: \$${userBalance.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                'assets/icons/moeda.png',
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
        ),
        centerTitle: true, // Garante que o título do AppBar (incluindo o saldo) esteja centralizado
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorePage(updateBalance: (amount) {})), // Navega para a página de loja
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.store,
                size: 30.sp, // Tamanho maior do ícone
                color: Colors.black, // Ícone preto
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
              // Seção de perfil do usuário
              Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 27.r,
                          backgroundImage: NetworkImage(userPhotoUrl),
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
                          userName,
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
                      color: Colors.blue, // Cor do ícone de ranking azul
                    ),
                  ),
                ],
              ),
              SizedBox(height: 29.h),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffEDEDED), // Cor de fundo da barra de pesquisa
                  hintText: 'Encontre um amigo ou um jogo',
                  hintStyle: TextStyle(fontSize: 13.sp), // Diminuir o tamanho do texto
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(6.w), // Ajuste o padding conforme necessário
                    child: Image.asset(
                      'assets/images/pesquisa.png',
                      width: 26.w,  // Aumentar a largura do ícone
                      height: 26.h, // Aumentar a altura do ícone
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(31.r), // Arredondar a barra de pesquisa
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
                    style: TextStyle(fontSize: 29.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Transform.translate(
                    offset: Offset(-21.w, 0), // Move o ícone 21 pixels para a esquerda
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, width: 3.0.w), // Aumentar a espessura da borda do filtro
                        borderRadius: BorderRadius.circular(17.r),
                        // Adiciona sombra ao ícone
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green,
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.tune_sharp, color: Colors.black87),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FilterDialog();
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
                    size: 11.sp, // Diminui o tamanho da bolinha verde
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 11.5.sp, color: Colors.black87), // Remove o negrito do texto
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Lista de amigos
              Container(
                height: 90.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendProfilePage(friends[index]['name'] ?? 'Usuário'),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 28.r,
                              backgroundImage: AssetImage(friends[index]['photoUrl']!),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            friends[index]['name'] ?? 'Usuário',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Recentes',
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black12),
              ),
              SizedBox(height: 8.h),
              // Jogos recentes (sem nomes)
              Container(
                height: 140.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentGameImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w), // Aumenta o espaçamento horizontal jogos recente
                      child: GestureDetector(
                        onTap: () {
                          if (recentGameImages[index]['image'] == 'assets/jogos/dama.png') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WaitingForPlayerPage(gameTitle: 'Dama'),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.r),
                          child: Image.asset(
                            recentGameImages[index]['image']!,
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
              Text(
                'Estatísticas',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54), // Diminuir o tamanho do texto e mudar a cor para preto claro
              ),
              SizedBox(height: 26.h), // Aumentar o espaçamento entre as seções
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatisticCard('Semana', '5 jogos'),
                  _buildStatisticCard('Mês', '20 jogos'),
                  _buildStatisticCard('Ano', '200 jogos'),
                ],
              ),
              SizedBox(height: 26.h),
              Text(
                'Jogadores Recentes',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54), // Diminuir o tamanho do texto e mudar a cor para preto claro
              ),
              SizedBox(height: 8.h),
              Container(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentPlayers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w), // aumenta a largura jogadores recentes
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendProfilePage(recentPlayers[index]['name'] ?? 'Usuário'),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage: NetworkImage(recentPlayers[index]['photoUrl']!),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            recentPlayers[index]['name'] ?? 'Usuário',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Todos os jogos',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black54), // Diminuir o tamanho do texto e mudar a cor para preto claro
              ),
              SizedBox(height: 19.h),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.w,
                  mainAxisSpacing: 24.h,
                  childAspectRatio: 1,
                ),
                itemCount: allGames.length,
                itemBuilder: (context, index) {
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
                        SizedBox(height: 4.h),
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
//botão painel de controle
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

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedOption;
  String? _selectedBettingMode;
  bool isOnline = true;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão de fechar fora do bloco
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(' Painel de Controle', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  indicatorColor: Colors.green,
                  tabs: [
                    Tab(icon: Icon(Icons.settings, color: Colors.black87), text: 'Configurações'),
                    Tab(icon: Icon(Icons.games, color: Colors.black87), text: 'Jogos'),
                  ],
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 400.h,
                  width: MediaQuery.of(context).size.width * 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(36.r)),
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
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Visibilidade'),
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
            title: Text('Modo Escuro'),
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
          Text('Modo de Aposta', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
              Text('Negociada', style: TextStyle(fontSize: 14.sp)),
              Radio<String>(
                value: 'Direta',
                groupValue: _selectedBettingMode,
                onChanged: (value) {
                  setState(() {
                    _selectedBettingMode = value;
                  });
                },
              ),
              Text('Direta', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          Divider(),
          ListTile(
            title: Text('Notificações'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            title: Text('Privacidade'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            title: Text('Idioma'),
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
        padding: EdgeInsets.all(16.0), // Ajuste o padding geral
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
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8.0), // Espaço entre o texto e a imagem
            Image.asset(
              imagePath,
              width: 25, // Ajuste da largura da imagem
              height: 25, // Ajuste da altura da imagem
              fit: BoxFit.cover,
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza as opções
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
                Text(option, style: TextStyle(fontSize: 14.0)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
