import 'package:flutter/material.dart';

import '../widgets/load_overlay.dart';
import 'game_page.dart';

class PlayerLose extends StatelessWidget {
  const PlayerLose({super.key, required this.section});

  final Map<String, dynamic> section;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/games_logos/tic_tac_toe.png'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Vamos tentar de novo ?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("sections")
                      .doc(section["id"])
                      .snapshots(),
                  builder: (context, sectionSnap) {
                    return ElevatedButton(
                      onPressed: sectionSnap.hasData
                          ? (sectionSnap.data!.data())!["allow_rematch"]
                          ? () async {
                        OverlayEntry entry = LoadOverlay.load();
                        Overlay.of(context).insert(entry);

                        QuerySnapshot movesQue =
                        await FirebaseFirestore.instance
                            .collection("sections")
                            .doc(section["id"])
                            .collection("moves")
                            .get();

                        for (DocumentSnapshot doc in movesQue.docs) {
                          await doc.reference.delete();
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamePage(
                                  sectionId: section["id"],
                                )));
                        entry.remove();
                      }
                          : null
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Revanche',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF0472E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Voltar para o Início',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
