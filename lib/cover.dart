import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool started;

  MyCoverScreen({required this.started});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.5),
      child: Text(
        started ? '' : 'T A P  T O  P L A Y',
        style: TextStyle(color: Colors.white, fontSize: 35),
      ),
    );
  }
}
