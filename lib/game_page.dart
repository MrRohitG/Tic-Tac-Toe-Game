import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Defining a stateful widget named GamePage.
class GamePage extends StatefulWidget {
  // Constructor for GamePage, initializing with an optional key.
  const GamePage({Key? key}) : super(key: key);

  // Overriding the createState method to return an instance of _GamePageState.
  @override
  State<GamePage> createState() => _GamePageState();
}

// State class _GamePageState that manages the state for the GamePage widget.
class _GamePageState extends State<GamePage> {
  static const String PLAYER_X = "X";
  static const String PLAYER_Y = "O";

  // State variables
  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    // Initialization method called when the state object is first created.
    initializeGame(); // Custom method to initialize the game state.
    super
        .initState(); // Calling the initState method of the superclass (State).
  }

  // Custom method to initialize the game state.
  void initializeGame() {
    currentPlayer = PLAYER_X; // Player X starts the game.
    gameEnd = false; // Game is initially not ended.
    occupied = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    ]; // Represents 9 empty places on the game board.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerText(),
              _gameContainer(),
              SizedBox(
                height: 20,
              ),
              _restartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        Text("Tic Tac Toe",
            style: GoogleFonts.poppins(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.red)),
        Text("$currentPlayer Turn",
            style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 14, 13, 13))),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, int index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        //on click of box
        if (gameEnd || occupied[index].isNotEmpty) {
          //Return if game already ended or box already clicked
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          print('$currentPlayer');
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: () {
            if (occupied[index].isEmpty) {
              return Colors.white; // Reddish color for empty occupied slot
            } else if (occupied[index] == PLAYER_X) {
              return Colors.blue; // Blue color if occupied by PLAYER_X
            } else {
              return Colors
                  .orange; // Orange color if occupied by PLAYER_Y or other condition
            }
          }(), //invoke the anonymous function

          //or color: occupied[index].isEmpty? Color.fromARGB(66, 197, 71, 71) // Reddish color for empty occupied slot: occupied[index] == PLAYER_X? Colors.blue // Blue color if occupied by PLAYER_X: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  _restartButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          initializeGame();
        });
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red, width: 1), // Border width and color
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)), // Text color
        padding: EdgeInsets.all(16), // Button padding
      ),
      child: Text(
        "Restart Game",
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  /*
Define winning positions
 0 | 1 | 2
-----------
 3 | 4 | 5
-----------
 6 | 7 | 8

  */
  checkForWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          //all equal means player won
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  void checkForDraw() {
    // If the game has already ended, do nothing
    if (gameEnd) {
      return;
    }

    // Assume the game is a draw unless proven otherwise
    bool draw = true;

    // Iterate through each cell in the board
    for (var occupiedPlayer in occupied) {
      // If any cell is empty, the game is not a draw
      if (occupiedPlayer.isEmpty) {
        draw = false;
        break;
      }
    }

    // If all cells are filled and no empty cell is found, declare a draw
    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        backgroundColor: () {
          if (message.contains("X")) {
            return Colors.blue;
          } else if (message.contains("O")) {
            return Colors.orange;
          } else {
            return Colors.red;
          }
        }(),
        content: Text(
          "Game Over \n $message",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
