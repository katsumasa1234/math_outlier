import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'math.dart';

class ExpressionDisplay extends StatelessWidget {
  final Expression exp;
  final double fontSize;
  const ExpressionDisplay({super.key, required this.exp, this.fontSize = 30});

  @override
  Widget build(BuildContext context) {
    return Math.tex(exp.toLateX(), textStyle: TextStyle(fontSize: fontSize));
  }
}