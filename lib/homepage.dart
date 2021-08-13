//    B)    B:|

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cover.dart';
import 'barrier.dart';
import 'bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initpos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -2.5;   //power of gravity
  double velocity = 1.5;    //power of jump
  double birdWidth = 0.1; // out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; // out of 2, 2 being the entire height of the screen
  int totaltime = 0;
  int score = 0;
  int bestscore = 0;
  //game values
  bool started = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];


  void start(){
    started = true;
    Timer.periodic(Duration(milliseconds: 1000),(timer) {
      totaltime += 1;
      //print("$totaltime");

      if(birdded()){
        timer.cancel();
        totaltime = 0;
      }
    });



    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initpos - height;
      });


      //checks if bird is ded or not
      if(birdded()){
        timer.cancel();
        _showDialog();
      }

      // keep the map moving
      moveit();

      //time keeps on going
      //so the bird falls faster
      time += 0.1;
    });
  }



  void moveit(){
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.03;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void reset(){
    //changes some variables to
    //it's initial position
    Navigator.pop(context);
    setState(() {
      if(score >= bestscore){
        bestscore = score;
      }
      birdY = 0;
      started = false;
      time = 0;
      initpos = birdY;
      score = 0;
      barrierX = [2,2+1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E  O V E R ( u nubb )",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: reset,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    //when we tap, the position of the bird
    //becomes the new initial position
    setState(() {
      time = 0;
      initpos = birdY;
      score = totaltime;
    });
  }

  bool birdded(){
    //as the name suggests
    //checks if the bird is dead or not
      if(birdY < -1 || birdY > 1){
        return true;
      }

      // when bird hits barriers
      // checks if bird is within the barriers
      for (int i = 0; i < barrierX.length; i++) {
        if (barrierX[i] <= birdWidth &&
            barrierX[i] + barrierWidth >= -birdWidth &&
            (birdY <= -1 + barrierHeight[i][0] ||
                birdY + birdHeight >= 1 - barrierHeight[i][1])) {
          return true;
        }
      }
      return false;
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: started ? jump : start,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Stack(
                        children: [
                          // bird image
                          MyBird(
                            birdY: birdY,
                            birdWidth: birdWidth,
                            birdHeight: birdHeight,
                          ),

                          // tap to play
                          MyCoverScreen(started: started),


                          // Top barrier 0
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 0
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][1],
                            isThisBottomBarrier: true,
                          ),

                          // Top barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][1],
                            isThisBottomBarrier: true,
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              Expanded(
                child: Container(
                  color: Colors.brown,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$score',
                              style: TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'SCORE',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$bestscore',
                              style: TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'BEST SCORE',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

