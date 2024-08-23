import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_outlier/generate_expression.dart';
import 'package:math_outlier/load_page.dart';
import 'package:math_outlier/question_page.dart';

class LevelListPage extends StatelessWidget {
  const LevelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("数学的外れ値"),
      ),
      body: ListView.builder(
        itemCount: GenerateExpression.seeds.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(5),
            child: MaterialButton(
              color: Theme.of(context).colorScheme.inversePrimary,
              splashColor: Theme.of(context).colorScheme.surface,
              shape: const UnderlineInputBorder(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoadPage(label: "問題作成中",
                      next: compute((id) {
                        return QuestionPage(generateSeedId: id);
                      }, GenerateExpression.seeds.keys.toList()[index]), loadMarge: 4,
                    ))
                );
              },
              child: Column(
                children: [
                  Text(GenerateExpression.seeds.values.toList()[index].title ?? "untitled", style: const TextStyle(fontSize: 30, fontFamily: "SawarabiMincho"),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(GenerateExpression.seeds.values.toList()[index].description ?? "", style: const TextStyle(fontSize: 15, fontFamily: "SawarabiMincho", color: Colors.black38),)),
                      Text("Lv.${GenerateExpression.seeds.values.toList()[index].level}", style: const TextStyle(fontSize: 15, fontFamily: "SawarabiMincho", color: Colors.black38),),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}