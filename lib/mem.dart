import 'package:flutter/material.dart';
import 'dart:math';

class Mem extends StatefulWidget {
  const Mem({super.key});

  @override
  State<Mem> createState() => _MemState();
}

class _MemState extends State<Mem> {
  int rows = 4;
  int cols = 5;
  List<List<Color>> cardColors = [];
  List<List<bool>> isFlipped = [];
  final Color inactiveColor = Colors.grey[300]!;

  @override
  void initState() {
    super.initState();
    generateColors();
  }

  void generateColors() {
    int totalCards = rows * cols;
    Random random = Random();

    cardColors = [];
    isFlipped = [];

    for (int i = 0; i < rows; i++) {
      List<Color> rowColors = [];
      List<bool> rowFlipped = [];

      for (int j = 0; j < cols; j++) {
        // Generar color aleatorio para cada carta
        Color randomColor = Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );

        rowColors.add(randomColor);
        rowFlipped.add(false); // Inicialmente todas las cartas están volteadas hacia abajo
      }

      cardColors.add(rowColors);
      isFlipped.add(rowFlipped);
    }
  }

  void changeBoardSize(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
    });
    generateColors();
  }

  void onCardTap(int row, int col) {
    setState(() {
      isFlipped[row][col] = !isFlipped[row][col];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diego Rolando Maldonado Acevedo'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implementar funcionalidad de reiniciar
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar juego',
          ),
        ],
      ),
      body: Column(
        children: [
          // Controles de tamaño del tablero
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => changeBoardSize(4, 5),
                  child: const Text('4x5'),
                ),
                ElevatedButton(
                  onPressed: () => changeBoardSize(5, 4),
                  child: const Text('5x4'),
                ),
                ElevatedButton(
                  onPressed: () => changeBoardSize(4, 6),
                  child: const Text('4x6'),
                ),
                ElevatedButton(
                  onPressed: () => changeBoardSize(6, 4),
                  child: const Text('6x4'),
                ),
              ],
            ),
          ),

          // Tablero del juego
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildGameBoard(),
            ),
          ),

          // Botón de reiniciar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implementar funcionalidad de reiniciar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Reiniciar Juego'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameBoard() {
    return AspectRatio(
      aspectRatio: cols / rows,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: List.generate(rows, (row) {
            return Expanded(
              child: Row(
                children: List.generate(cols, (col) {
                  return Expanded(
                    child: buildCard(row, col),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildCard(int row, int col) {
    Color displayColor;

    // Si la carta está volteada, mostrar su color, si no, mostrar el color inactivo
    if (isFlipped[row][col]) {
      displayColor = cardColors[row][col];
    } else {
      displayColor = inactiveColor;
    }

    return GestureDetector(
      onTap: () => onCardTap(row, col),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: displayColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}