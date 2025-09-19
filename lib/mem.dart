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
  List<List<bool>> isMatched = [];
  int? firstSelectedRow;
  int? firstSelectedCol;
  int? secondSelectedRow;
  int? secondSelectedCol;
  bool canTap = true;
  bool gameCompleted = false;
  final Color inactiveColor = Colors.grey[300]!;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    gameCompleted = false;
    canTap = true;
    firstSelectedRow = null;
    firstSelectedCol = null;
    secondSelectedRow = null;
    secondSelectedCol = null;
    generateColors();
  }

  void generateColors() {
    int totalCards = rows * cols;
    int pairs = totalCards ~/ 2;

    // colores para pares
    List<Color> uniqueColors = generateUniqueColors(pairs);
    List<Color> allColors = [];

    // duplicar color para pares
    for (int i = 0; i < pairs; i++) {
      allColors.add(uniqueColors[i]);
      allColors.add(uniqueColors[i]);
    }

    // mezclar los colores
    allColors.shuffle();

    cardColors = [];
    isFlipped = [];
    isMatched = [];

    int colorIndex = 0;
    for (int i = 0; i < rows; i++) {
      List<Color> rowColors = [];
      List<bool> rowFlipped = [];
      List<bool> rowMatched = [];

      for (int j = 0; j < cols; j++) {
        rowColors.add(allColors[colorIndex]);
        rowFlipped.add(false);
        rowMatched.add(false);
        colorIndex++;
      }

      cardColors.add(rowColors);
      isFlipped.add(rowFlipped);
      isMatched.add(rowMatched);
    }

    setState(() {});
  }

  List<Color> generateUniqueColors(int count) {
    List<Color> colors = [];
    Random random = Random();

    for (int i = 0; i < count; i++) {
      Color color;
      do {
        color = Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );
      } while (colors.any((c) => _areColorsSimilar(c, color)));

      colors.add(color);
    }

    return colors;
  }

  bool _areColorsSimilar(Color c1, Color c2) {
    const threshold = 50;
    return (c1.red - c2.red).abs() < threshold &&
        (c1.green - c2.green).abs() < threshold &&
        (c1.blue - c2.blue).abs() < threshold;
  }

  void changeBoardSize(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
    });
    initializeGame();
  }

  void onCardTap(int row, int col) {
    if (!canTap || isFlipped[row][col] || isMatched[row][col]) {
      return;
    }

    setState(() {
      isFlipped[row][col] = true;

      if (firstSelectedRow == null) {
        // primera carta seleccionada
        firstSelectedRow = row;
        firstSelectedCol = col;
      } else {
        // segunda carta seleccionada
        secondSelectedRow = row;
        secondSelectedCol = col;
        canTap = false;

        // verificar si coinciden
        Future.delayed(const Duration(milliseconds: 1000), () {
          checkMatch();
        });
      }
    });
  }

  void checkMatch() {
    bool isMatch = cardColors[firstSelectedRow!][firstSelectedCol!] ==
        cardColors[secondSelectedRow!][secondSelectedCol!];

    setState(() {
      if (isMatch) {
        // si coinciden, marcarlas como emparejadas
        isMatched[firstSelectedRow!][firstSelectedCol!] = true;
        isMatched[secondSelectedRow!][secondSelectedCol!] = true;
      } else {
        // si no coinciden, voltearlas de nuevo
        isFlipped[firstSelectedRow!][firstSelectedCol!] = false;
        isFlipped[secondSelectedRow!][secondSelectedCol!] = false;
      }

      // resetear seleccio
      firstSelectedRow = null;
      firstSelectedCol = null;
      secondSelectedRow = null;
      secondSelectedCol = null;
      canTap = true;

      // checar si acabo
      checkGameCompleted();
    });
  }

  void checkGameCompleted() {
    bool allMatched = true;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (!isMatched[i][j]) {
          allMatched = false;
          break;
        }
      }
      if (!allMatched) break;
    }

    if (allMatched) {
      setState(() {
        gameCompleted = true;
      });

      // mensaje win
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Felicidades!'),
            content: const Text('¡Has completado el memorama!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
            onPressed: initializeGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar juego',
          ),
        ],
      ),
      body: Column(
        children: [
          // tamaños
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

          // tablero del juego
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildGameBoard(),
            ),
          ),

          // reiniciar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: initializeGame,
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
    if (isMatched[row][col] || isFlipped[row][col]) {
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