import 'package:flutter/material.dart';
import '../models/ludo_logic.dart';

class LudoBoardWidget extends StatelessWidget {
  final LudoLogic ludoLogic;
  final Function(int player, int pieceIndex, int steps) onMove;
  final Function() onRollDice;
  final int currentDiceValue;

  const LudoBoardWidget({
    Key? key,
    required this.ludoLogic,
    required this.onMove,
    required this.onRollDice,
    required this.currentDiceValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double boardSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        double cellSize = boardSize / 15;

        return Center(
          child: Container(
            width: boardSize,
            height: boardSize,
            color: Colors.white,
            child: Stack(
              children: [
                // Quadrante superior esquerdo (Vermelho)
                _buildQuadrant(0, 0, Colors.red, cellSize),
                // Quadrante superior direito (Verde)
                _buildQuadrant(0, 9, Colors.green, cellSize),
                // Quadrante inferior esquerdo (Amarelo)
                _buildQuadrant(9, 0, Colors.yellow, cellSize),
                // Quadrante inferior direito (Azul)
                _buildQuadrant(9, 9, Colors.blue, cellSize),
                // Caminhos
                _buildPaths(cellSize),
                // Dados
                _buildDice(cellSize),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuadrant(int startX, int startY, Color color, double cellSize) {
    return Positioned(
      left: startX * cellSize,
      top: startY * cellSize,
      child: Container(
        width: cellSize * 6,
        height: cellSize * 6,
        color: color.withOpacity(0.6),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: color,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaths(double cellSize) {
    return Stack(
      children: [
        // Caminhos horizontais
        _buildHorizontalPath(6, 0, cellSize),
        _buildHorizontalPath(6, 9, cellSize),
        // Caminhos verticais
        _buildVerticalPath(0, 6, cellSize),
        _buildVerticalPath(9, 6, cellSize),
        // Área central
        _buildCenter(cellSize),
      ],
    );
  }

  Widget _buildHorizontalPath(int startX, int startY, double cellSize) {
    return Positioned(
      left: startX * cellSize,
      top: startY * cellSize,
      child: Row(
        children: List.generate(6, (index) => _buildPathCell(cellSize)),
      ),
    );
  }

  Widget _buildVerticalPath(int startX, int startY, double cellSize) {
    return Positioned(
      left: startX * cellSize,
      top: startY * cellSize,
      child: Column(
        children: List.generate(6, (index) => _buildPathCell(cellSize)),
      ),
    );
  }

  Widget _buildPathCell(double cellSize) {
    return Container(
      width: cellSize,
      height: cellSize,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildCenter(double cellSize) {
    return Positioned(
      left: 6 * cellSize,
      top: 6 * cellSize,
      child: Container(
        width: cellSize * 3,
        height: cellSize * 3,
        color: Colors.white,
        child: Center(
          child: Container(
            width: cellSize * 2,
            height: cellSize * 2,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  Widget _buildDice(double cellSize) {
    return Positioned(
      top: 6 * cellSize,
      left: 6 * cellSize,
      child: GestureDetector(
        onTap: onRollDice,
        child: Container(
          width: cellSize * 3,
          height: cellSize * 3,
          color: Colors.white,
          child: Center(
            child: Text(
              '$currentDiceValue',
              style: TextStyle(fontSize: cellSize, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}