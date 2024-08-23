import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_outlier/database.dart';

class RecordPage extends StatefulWidget {


  const RecordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RecordPageState();
  }
}

class RecordPageState extends State<RecordPage> {
  List<ExpressionRecordItemData> expressions = [];

  @override
  void initState() {
    super.initState();

    readDatabase();
  }

  readDatabase() {
    DatabaseController.database.select(DatabaseController.database.expressionRecordItem).get().then((value) {
      setState(() {
        expressions = value;
      });
    });
  }

  deleteRecord() {
    DatabaseController.database.delete(DatabaseController.database.expressionRecordItem).go().then((onValue) {
      readDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("記録"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text("記録を削除する", style: TextStyle(fontFamily: "SawarabiMincho")),
                  content: const Text("記録を削除する動作は\n元には戻せません。", style: TextStyle(fontFamily: "SawarabiMincho"),),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: const Text("Cancel", style: TextStyle(fontFamily: "SawarabiMincho"))),
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                      deleteRecord();
                    }, child: const Text("OK", style: TextStyle(fontFamily: "SawarabiMincho")))
                  ],
                );
              });
            },
            icon: const Icon(Icons.delete),
            tooltip: "記録を消す",
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: expressions.isEmpty ?
        const Center(child: SizedBox.expand(child: FittedBox(child: Text("記録がありません。"),),)):
        ListView.builder(
          itemCount: expressions.length,
          itemBuilder: (context, i) {
            int index = expressions.length - i - 1;
            return Container(
              padding: const EdgeInsets.all(10),
              child: MaterialButton(
                elevation: 1,
                color: const Color.fromARGB(200, 135, 159, 236),
                splashColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {},
                child: SizedBox(
                  height: 120,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Expanded(flex: 5, child: FittedBox(child: Math.tex(expressions[index].exp))),
                        const Expanded(flex: 2, child: Divider(color: Colors.white,)),
                        Expanded(flex: 1, child: FittedBox(child: Math.tex("= ${expressions[index].ans}")))
                      ],
                    ),
                  ),
                )
              ),
            );
          },
        ),
      ),
    );
  }
}