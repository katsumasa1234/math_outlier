import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LoadPage extends StatefulWidget {
  final String label;
  final Future<Widget> next;
  final int loadMarge;
  late final Map<Text, Math> wises;
  
  LoadPage({super.key, required this.label, required this.next, this.loadMarge = 0}) {
    wises = {
      const Text("定積分は\nリーマン和の\n極限値", style: TextStyle(fontSize: 100),): 
          Math.tex(r"\int_{a}^{b} f(x) dx = \lim_{n \to \infty} \sum_{k = 1}^{n} f(ξ_k)(x_k - x_{k -1})", textStyle: const TextStyle(fontSize: 30),),

      const Text("オイラーの公式\n数学の詩", style:TextStyle(fontSize: 100),):
          Math.tex(r"e^{iπ} + 1 = 0", textStyle: const TextStyle(fontSize: 30),),

      const Text("万物の根源は\n数である", style:TextStyle(fontSize: 100),):
          Math.tex(r"a^2 + b^2 = c^2", textStyle: const TextStyle(fontSize: 30),),

      const Text("神は絶対に\nサイコロをふらない", style:TextStyle(fontSize: 100),):
          Math.tex(r"E = mc^2", textStyle: const TextStyle(fontSize: 30),),

      const Text("証明のための\n余白が足りない", style:TextStyle(fontSize: 100),):
          Math.tex(r"x^n + y^n = z^n (n \geq 3)", textStyle: const TextStyle(fontSize: 30),),

      const Text("関数の近似\nテイラー展開", style:TextStyle(fontSize: 100),):
          Math.tex(r"f(x) = \sum_{n=0}^{\infty} \frac{f^{\left(n\right)}\left(a\right)}{n!}{\left(x - a\right)}^n", textStyle: const TextStyle(fontSize: 30),),

      const Text("解の公式\n二次方程式のカギ", style:TextStyle(fontSize: 100),):
          Math.tex(r"x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}", textStyle: const TextStyle(fontSize: 30),),

      const Text("ゴロ合わせで暗記\n加法定理", style:TextStyle(fontSize: 100),):
          Math.tex(r"\sin(\alpha + \beta) = \sin\alpha\cos\beta + \cos\alpha\sin\beta", textStyle: const TextStyle(fontSize: 30),),

      const Text("リンゴは\n木から落ちる", style:TextStyle(fontSize: 100),):
          Math.tex(r"F = G\frac{Mm}{r^2}", textStyle: const TextStyle(fontSize: 30),),

      const Text("束の間の\n変化をとらえる", style:TextStyle(fontSize: 100),):
          Math.tex(r"{\frac{d}{dx}}_{x=a}f(x) = \lim_{x \to a}\frac{f(x) - f(a)}{x - a}", textStyle: const TextStyle(fontSize: 30),),

      const Text("実数の裏社会\n複素数降臨", style:TextStyle(fontSize: 100),):
          Math.tex(r"i^2 = -1", textStyle: const TextStyle(fontSize: 30),),

      const Text("確率の美学\n正規分布の曲線", style:TextStyle(fontSize: 100),):
          Math.tex(r"f(x) = \frac{1}{\sqrt{2\pi{\sigma}^2}}e^{-\frac{{(x - \mu)}^2}{2{\sigma}^2}}", textStyle: const TextStyle(fontSize: 30),),
    };
  }

  @override
  State<StatefulWidget> createState() {
    return LoadPageState();
  }
}

class LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    asyncProcess();
  }

  Future<void> asyncProcess() async {
    await Future.delayed(Duration(seconds: widget.loadMarge));
    widget.next.then((value) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => value)
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int random = Random().nextInt(widget.wises.length);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FittedBox(
                          child: widget.wises.keys.toList()[random],
                        ),
                        FittedBox(
                          child: widget.wises.values.toList()[random],
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      children: [
                        LinearProgressIndicator(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
                        Text(widget.label, style: const TextStyle(fontSize: 30))
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}