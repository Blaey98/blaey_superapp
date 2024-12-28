import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'filter_dialog.dart';

// Classe principal do widget Stateful para a página de perfil
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// Estado do widget ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  String bio = ""; // Biografia do usuário
  XFile? _image; // Arquivo de imagem para o perfil do usuário
  String userName = "Jeff"; // Nome do usuário
  int numPublications = 42; // Número de publicações
  int numFriends = 120; // Número de amigos
  int numBestFriends = 5; // Número de melhores amigos

  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker
  List<XFile> photoGallery = [ // Lista de fotos da galeria
    XFile('assets/images/photo1.jpg'),
    XFile('assets/images/photo2.jpg'),
    XFile('assets/images/photo3.jpg'),
  ];

  bool showFriends = false; // Controle para mostrar a lista de amigos
  bool showTrophies = false; // Controle para mostrar a lista de troféus

  // Método para selecionar uma imagem da galeria
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  // Método para adicionar uma foto à galeria
  Future<void> _addPhotoToGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photoGallery.add(pickedFile);
      });
    }
  }

  // Método para navegar para a página de edição de perfil
  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    ).then((_) {
      // Atualizar a página de perfil após edição
      setState(() {});
    });
  }

  // Método para visualizar a imagem selecionada
  void _viewImage() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewPage(imageFile: File(_image!.path)),
        ),
      );
    }
  }

  // Método para visualizar o perfil de um amigo
  void _viewFriendProfile(String friendName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendProfilePage(friendName: friendName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('@$userName'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navegar para a página de configurações
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinhar à esquerda
          children: [
            Row(
              children: [
                // Widget para visualizar a imagem de perfil com uma opção para alterar a foto
                GestureDetector(
                  onTap: _viewImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.grey[300],
                        child: CircleAvatar(
                          radius: 63,
                          backgroundImage: _image != null
                              ? FileImage(File(_image!.path))
                              : AssetImage('assets/icons/perfil.png') as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 8, // Ajustar a posição para mais dentro
                        right: 8, // Ajustar a posição para mais dentro
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black.withOpacity(0.5), // 50% transparente
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exibição do nome do usuário
                    Text(
                      userName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    // Exibição do número de publicações
                    Row(
                      children: [
                        Text(
                          '$numPublications ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Publicações',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    // Exibição do número de amigos
                    Row(
                      children: [
                        Text(
                          '$numFriends ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Amigos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    // Exibição do status online
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10), // Bolinha verde pequena
                        SizedBox(width: 5),
                        Text('online', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    // Exibição da biografia do usuário
                    child: Text(
                      bio.isNotEmpty ? bio : 'adicione uma bios...',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                IconButton(
                  icon: ImageIcon(AssetImage('assets/icons/filter.png'), size: 30, color: Colors.black54), // Aumentar tamanho do ícone de filtro
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FilterDialog();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // Botão para adicionar uma atualização de imagem
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _pickImage,
                  child: Text(
                    '+ Adicionar atualização',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(width: 10), // Espaçamento entre os botões
                // Botão para editar o perfil
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _editProfile,
                  icon: Icon(Icons.edit, color: Colors.white, size: 16),
                  label: Text(
                    'Editar perfil',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), // Aumentar espaço entre o botão "Editar perfil" e a barra de seleção
            // Barra de navegação
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // Centralizar e distribuir igualmente
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library, color: !showFriends && !showTrophies ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = false;
                            showTrophies = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.group, color: showFriends ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = true;
                            showTrophies = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_events, color: showTrophies ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = false;
                            showTrophies = true;
                          });
                        },
                      ),
                    ],
                  ),
                  // Indicador de aba selecionada
                  Container(
                    height: 6, // Mais grossa
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            color: !showFriends && !showTrophies ? Colors.black : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            color: showFriends ? Colors.black : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            color: showTrophies ? Colors.black : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 2, // Barra inferior em cinza
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            // Bloco com 3 colunas
            Expanded(
              child: Stack(
                children: [
                  // Coluna de Galeria de Fotos
                  Positioned.fill(
                    child: Visibility(
                      visible: !showFriends && !showTrophies,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: 3, // Mostrar apenas 3 quadrados
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.grey.withOpacity(0.6),
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Coluna de Amigos
                  Positioned.fill(
                    child: Visibility(
                      visible: showFriends,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Melhores Amigos',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '($numBestFriends)',
                                      style: TextStyle(fontSize: 18, color: Colors.green),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8), // Espaço entre "Melhores Amigos" e "Amigo 1"
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 1'),
                                  onTap: () => _viewFriendProfile('Amigo 1'),
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 2'),
                                  onTap: () => _viewFriendProfile('Amigo 2'),
                                ),
                                SizedBox(height: 8), // Espaço entre a barra de divisão e "Amigos"
                                Divider(),
                                SizedBox(height: 8),
                                Text(
                                  'Amigos',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                SizedBox(height: 8), // Espaço entre "Amigos" e "Amigo 3"
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 3'),
                                  onTap: () => _viewFriendProfile('Amigo 3'),
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 4'),
                                  onTap: () => _viewFriendProfile('Amigo 4'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Coluna de Troféus
                  Positioned.fill(
                    child: Visibility(
                      visible: showTrophies,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.emoji_events),
                                  title: Text('Troféu 1'),
                                  subtitle: Text('Descrição do troféu'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.emoji_events),
                                  title: Text('Troféu 2'),
                                  subtitle: Text('Descrição do troféu'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Botão flutuante para adicionar uma foto à galeria
      floatingActionButton: showFriends || showTrophies
          ? null
          : FloatingActionButton(
        onPressed: _addPhotoToGallery,
        backgroundColor: Colors.black54, // Fundo preto claro
        child: Icon(Icons.add_a_photo, color: Colors.white), // Ícone branco
      ),
    );
  }
}

// Página para visualizar a imagem selecionada
class ImagePreviewPage extends StatelessWidget {
  final File imageFile;

  ImagePreviewPage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Foto'),
        leading: IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}

// Página para editar o perfil do usuário
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userName = "Jeff";
  String userHandle = "jeff";
  String bio = "";
  String gender = "Prefiro não dizer";

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Método para selecionar uma nova imagem de perfil
  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  // Método para salvar as informações do perfil
  void _saveProfile() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : AssetImage('assets/icons/perfil.png') as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Campo de texto para editar o nome do usuário
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  userName = text;
                });
              },
              controller: TextEditingController(text: userName),
            ),
            SizedBox(height: 20),
            // Campo de texto para editar o nome de usuário
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome de usuário (@)',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  userHandle = text;
                });
              },
              controller: TextEditingController(text: userHandle),
            ),
            SizedBox(height: 20),
            // Campo de texto para editar a biografia
            TextField(
              decoration: InputDecoration(
                labelText: 'Biografia',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  bio = text;
                });
              },
              controller: TextEditingController(text: bio),
            ),
            SizedBox(height: 20),
            // Dropdown para selecionar o gênero
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
              value: gender,
              items: [
                DropdownMenuItem(value: "Masculino", child: Text("Masculino")),
                DropdownMenuItem(value: "Feminino", child: Text("Feminino")),
                DropdownMenuItem(value: "Personalizado", child: Text("Personalizado")),
                DropdownMenuItem(value: "Prefiro não dizer", child: Text("Prefiro não dizer")),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            SizedBox(height: 20),
            // Botão para salvar as alterações
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página para visualizar o perfil de um amigo
class FriendProfilePage extends StatelessWidget {
  final String friendName;

  FriendProfilePage({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendName),
      ),
      body: Center(
        child: Text('Perfil do $friendName'),
      ),
    );
  }
}