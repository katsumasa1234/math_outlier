import 'dart:async';
import 'dart:math';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:math_outlier/database.dart';
import 'package:math_outlier/expression_display.dart';
import 'package:math_outlier/generate_expression.dart';
import 'package:math_outlier/math.dart';

class Question {
  final Expression exp;
  final bool correct;
  late final ExpressionDisplay display;

  bool enable = true;

  Question({required this.exp, required this.correct}) {
    display = ExpressionDisplay(exp: exp);
  }
}

class QuestionPage extends StatefulWidget {
  final String generateSeedId;
  final int questionCount;
  final int correctCount;
  final int maxAnsNum;
  late final double ansNum;
  late final bool ansUp;
  final List<Question> questions = [];

  QuestionPage({super.key, required this.generateSeedId, this.questionCount = 6, this.correctCount = 2, this.maxAnsNum = 20}) {
    ansUp = Random().nextBool();
    ansNum = (Random().nextDouble() * maxAnsNum).roundToDouble();
    for (int i = 0; i < questionCount; i++) {
      if (i < correctCount) {
        questions.add(
            Question(
                exp: GenerateExpression.seeds[generateSeedId]!.generateExpression(ansNum, ansUp),
                correct: true
            )
        );
      } else {
        questions.add(
            Question(
                exp: GenerateExpression.seeds[generateSeedId]!.generateExpression(ansNum, !ansUp),
                correct: false
            )
        );
      }
    }
    questions.shuffle();
  }

  @override
  State<StatefulWidget> createState() {
    return QuestionPageState();
  }
}

class QuestionPageState extends State<QuestionPage> {
  int remainingCorrectQuestion = 0;
  int countDown = 2;
  static const int maxTime = 120;
  int timeCountDown = 0;
  String countDownStr = "";
  bool end = false;
  bool showMessage = false;

  @override
  void initState() {
    super.initState();

    remainingCorrectQuestion = widget.correctCount;
    timeCountDown = maxTime;
    countDownStr = (countDown + 1).toString();

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (end) timer.cancel();
      setState(() {
        if (countDown > 0) {
          countDownStr = countDown.toString();
          countDown--;
        } else if (countDown == 0) {
          countDownStr = "スタート！";
          countDown--;
        } else if (timeCountDown >= 0) {
          timeCountDown--;
          if (countDown == -1) {
            countDown--;
          }
        } else if (timeCountDown < 0) {
          if (!end) {
            endingProcess("タイムアップ");
          }
        }
      });
    });

    save();
  }

  void endingProcess(String message) {
    end = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        for (int i = 0; i < widget.questions.length; i++) {
          widget.questions[i].enable = false;
        }
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            countDownStr = message;
            showMessage = true;
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          });
        });
      });
    });
  }

  save() async {
    for (int i = 0; i < widget.questions.length; i++) {
      await DatabaseController.database.into(
          DatabaseController.database.expressionRecordItem).insert(
          ExpressionRecordItemCompanion(
              exp: drift.Value(widget.questions[i].exp.toLateX()),
              ans: drift.Value(
                  (simplifyConstant(widget.questions[i].exp) as Constant).value)
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: FittedBox(child: Text("${widget.ansNum}より${widget.ansUp ? "大きい" : "小さい"}ものをすべて選べ", style: const TextStyle(fontSize: 100, fontFamily: "SawarabiMincho"),)),),
            LinearProgressIndicator(value: timeCountDown.toDouble() / maxTime,),
            const SizedBox(height: 20,),
            countDown >= -1 || showMessage ?
                Expanded(flex: 9, child: Center(child: FittedBox(child: Text(countDownStr, style: const TextStyle(fontSize: 200),)))) :
                Expanded(flex: 9, child: ListView.builder(
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: MaterialButton(
                        elevation: 1,
                        color: const Color.fromARGB(200, 135, 159, 236),
                        disabledColor: widget.questions[index].correct ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: widget.questions[index].enable ? () {
                          if (!end) {
                            setState(() {
                              widget.questions[index].enable = false;
                              if (widget.questions[index].correct) {
                                remainingCorrectQuestion--;
                              } else {
                                endingProcess("不正解");
                              }
                              if (remainingCorrectQuestion == 0) {
                                endingProcess("正解");
                              }
                            });
                          }
                        } : null,
                        child: SizedBox(
                          height: 80,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: FittedBox(
                              child: widget.questions[index].display,
                            ),
                          )
                        ),
                      )
                    );
                  },
                ),)
          ],
        ),
      )
    );
  }
}