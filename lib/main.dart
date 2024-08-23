import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_outlier/expression_display.dart';
import 'package:math_outlier/generate_expression.dart';
import 'package:math_outlier/level_list_page.dart';
import 'package:math_outlier/load_page.dart';
import 'package:math_outlier/record_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Outlier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: "ExpressionFont",
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder> {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder()
          }
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {setState(() {});});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const FittedBox(
                child: Text("数学的\n外れ値", style: TextStyle(fontSize: 100)),
              ),
              SizedBox.fromSize(
                size: const Size.fromHeight(80),
                child: FittedBox(
                  child: ExpressionDisplay(exp: GenerateExpression.seeds["All Round"]!.generateExpression(Random().nextInt(10).toDouble(), Random().nextBool())),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoadPage(label: "数学的外れ値",
                        next: compute((t) {
                          return const LevelListPage();
                        }, ""), loadMarge: 4
                    ))
                  );
                },
                shape: const UnderlineInputBorder(),
                color: Theme.of(context).colorScheme.inversePrimary,
                splashColor: Theme.of(context).colorScheme.surface,
                child: const Text("スタート", style: TextStyle(fontSize: 70)),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadPage(label: "記録取得中",
                        next: compute((t) {
                          return const RecordPage();
                        }, ""),
                        loadMarge: 3,
                      )
                    )
                  );
                },
                shape: const UnderlineInputBorder(),
                color: Theme.of(context).colorScheme.inversePrimary,
                splashColor: Theme.of(context).colorScheme.surface,
                child: const Text("記録", style: TextStyle(fontSize: 70)),
              )
            ],
          ),
        )
      )
    );
  }
}
