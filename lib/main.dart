import 'package:flutter/material.dart';

void main() => runApp(MyApp());
int player = 1;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: new ThemeData(
        primaryColor: Colors.green[50],
        buttonTheme: ButtonThemeData(minWidth:50, height:50),
      ),
      home: TicTacToe(),  
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  /*
  var ticTacToeGrid = List<List<TicTacToeTile>>.generate(
    3, (i) => List<TicTacToeTile>.generate(3, (j) => new TicTacToeTile(i, j)));
  */

  int player = 1;
  List<List> _grid;
  int gridSize = 4;
  int totalSetVals = 0;
  Color c1 = Colors.deepOrangeAccent;
  Color c2 = Colors.tealAccent[400];

  _TicTacToeState(){
    _initGrid(gridSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar:AppBar(
        title: Text(
          'Tic Tac Toe'
        ),
      ),
      body: Center(
        child: Container(
        //height: 225.0, // in logical pixels
        //width: 225.0,
        //margin: const EdgeInsets.symmetric(horizontal: 25.0),
          alignment: Alignment.center,
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(50.0),
                //padding: const EdgeInsets.all(50.0),
                child:Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child:IconButton (
                              icon: Icon(Icons.person, 
                                          size: 50.0, 
                                          color: c1),
                              tooltip: 'Change Player',
                              onPressed: () {
                                setState(() {
                                  Icon(Icons.computer, size: 50.0);
                                });
                              },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child:IconButton (
                              icon: Icon(Icons.person, 
                                          size: 50.0, 
                                          color: c2),
                              tooltip: 'Change Player',
                              onPressed: () {
                                setState(() {
                                  //TODO
                                  Icon(Icons.computer, size: 50.0);
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Column(
                    children: _buildGrid(gridSize-1),
                  ),
                ],
              ),
            ],     
          ),
        ),
      ),
    );
  }

  _initGrid(gridSize) {
    _grid = new List<List>(gridSize);
    for(var i = 0; i < _grid.length; i++) {
      _grid[i] = new List(gridSize);
      for(var j = 0; j < _grid.length; j++) {
        _grid[i][j] = ' ';
      }
    }
    player = 1;
    totalSetVals = 0;
  }

  Widget _buildTicTacToeTile(int i, int j) {
    return GestureDetector(
      onTap: () {
        _setGridValue(i, j);
        _checkWinner(i, j);
      },
      child: Container (
        height: 65.0,
        width: 65.0,
        margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        decoration:BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 1.0, color: Colors.black)
        ),
        child: Text(_grid[i][j],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold,
                                      color: _grid[i][j]=='X' ? c1 : c2),
        ),
      ),
    );
  }

  _setGridValue(int i, int j) {
    setState(() {
      if(_grid[i][j] == ' ') {
        if(player == 1) {
          _grid[i][j] = 'X';
          totalSetVals++;
          player = 2;
        } else {
           _grid[i][j] = 'O';
           totalSetVals++;
          player = 1;
        }
      }
    });
  }

  _checkWinner(int i, int j) {
    var winnerFound = true;
    for(var x=1; x < _grid.length; x++){
      if(_grid[0][j] != _grid[x][j]) {
        winnerFound = false;
        break;
      } 
    }
    if(winnerFound == false) {
      winnerFound = true;
      for(var y=1; y < _grid.length; y++) {
        if(_grid[i][0] != _grid[i][y]) {
          winnerFound = false;
          break;
        }
      }
    }

    if(i==j && winnerFound == false) {
      winnerFound = true;
      for(var x=1; x < _grid.length; x++) {
        if(_grid[0][0] != _grid[x][x]){
          winnerFound = false;
          break;
        }
      }
    } 
    else if((i+j)==(_grid.length-1) && winnerFound == false){
      winnerFound = true;
      for(var x=1,y=_grid.length-2; x < _grid.length && y >= 0; x++,y--){
        if(_grid[0][_grid.length-1] != _grid[x][y]){
          winnerFound = false;
          break;
        }
      }
    }
    //print(totalSetVals.toString() + " " + winnerFound.toString());
    if(winnerFound) {
      _declareWinner(i, j);
    } else if(winnerFound == false && totalSetVals==(gridSize*gridSize)) {
      _successAlert("Its a Draw!");
    }
  }

  _declareWinner(int i, int j) {
    String winner = ' ';
    if(_grid[i][j]=='X') {
      winner = 'Player 1 won!';
    } else {
      winner = 'Player 2 won!';
    } 
    _successAlert(winner);
  }

  _successAlert(String winner) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold)),
          content: Text(winner,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            FlatButton(
              child: Text('Restart Game',
                          textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initGrid(gridSize);
                });
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildGrid(int cnt) {
    List<Widget> rowList = new List();
    for(var x=0; x <= cnt; x++) {
      List<Widget> widgetList = new List();
      for(var y=0; y <= cnt; y++) {
        widgetList.add(_buildTicTacToeTile(x, y));
      }
      Row r = new Row( mainAxisSize: MainAxisSize.min,
                      children : widgetList);
      rowList.add(r);
    }
    return rowList;
  }

}


class TicTacToeTile extends StatefulWidget {
  TicTacToeTile(int i, int j);
  @override
  _TicTacToeTileState createState() => _TicTacToeTileState();
}

class _TicTacToeTileState extends State<TicTacToeTile> {
  String val = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Row(
        // <Widget> is the type of items in the list
        children: <Widget>[
          RaisedButton(
            onPressed: (){
              setState((){
                if (player == 1) {
                  val = 'X';
                  player = 2;
                } else {
                  val = 'O';
                  player = 1;
                }
              });
              onPressed: null;
            },
            child: Text(val),
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}

