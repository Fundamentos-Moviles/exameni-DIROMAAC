import 'package:flutter/material.dart';

class Mem extends StatefulWidget {
  const Mem({super.key});

  @override
  State<Mem> createState() => _MemState();
}

class _MemState extends State<Mem> {
  int rows = 4;
  int cols = 5;
  final Color inactiveColor = Colors.grey[300]!;

  void changeBoardSize(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diego Rolando Maldonado Acevedo'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
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
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: inactiveColor,
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
    );
  }
}