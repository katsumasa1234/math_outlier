import 'dart:math';
import 'math.dart';

class GenerateExpression {
  static Map<String, ExpressionSeed> seeds = {
    /*"ID" : ExpressionSeed(
        title: ,
        description: ,
        level: ,
        variables: ,
        constants: ,
        operators: ,
        functions: ,
        bigFunctions: ,
        minItem: ,
        maxItem: ,
        minNumRange: ,
        maxNumRange: ,
        maxAbs:
    ),*/
    "All Round": ExpressionSeed(
      title: "オールラウンド",
      description: "様々な演算が同じような割合で出現します。",
      level: 10,
      variables: {
        "x": 0.5
      },
      constants: {
        "e": 0.05,
        "π": 0.05
      },
      operators: {
        Expression.addition : 0.2,
        Expression.subtraction : 0.2,
        Expression.multiplication : 0.2,
        Expression.division : 0.2,
        Expression.power : 0.2
      },
      functions: {
        Expression.sin : 0.05,
        Expression.cos : 0.05,
        Expression.tan : 0.05,
        Expression.loge: 0.05,
        Expression.log2: 0.05,
        Expression.log10: 0.05,
        Expression.asin: 0.05,
        Expression.acos: 0.05,
        Expression.atan: 0.05
      },
      bigFunctions: {
        Expression.differentiate : 0.2,
        Expression.integrate : 0.2,
        Expression.limit : 0.2,
        Expression.sum : 0.2
      },
      minItem: 2,
      maxItem: 5,
      minNumRange: 2,
      maxNumRange: 10,
      maxAbs: 1.0
    ),
    "Easy" : ExpressionSeed(
      title: "イージー",
      description: "整数の加減算が出現します。",
      level: 1,
      variables: {},
      constants: {},
      operators: {
        Expression.addition : 0.5,
        Expression.subtraction : 0.5
      },
      functions: {},
      bigFunctions: {},
      minItem: 1,
      maxItem: 3,
      minNumRange: 1,
      maxNumRange: 20,
      maxAbs: 5.0
    ),
    "Normal" : ExpressionSeed(
        title: "ノーマル",
        description: "四則演算が出現します。",
        level: 2,
        variables: {},
        constants: {},
        operators: {
          Expression.addition : 0.25,
          Expression.subtraction : 0.25,
          Expression.multiplication : 0.25,
          Expression.division : 0.25
        },
        functions: {},
        bigFunctions: {},
        minItem: 2,
        maxItem: 5,
        minNumRange: 1,
        maxNumRange: 20,
        maxAbs: 3
    ),
    "ハード" : ExpressionSeed(
        title: "ハード",
        description: "複数の関数、定数が出現します。",
        level: 5,
        variables: {},
        constants: {
          "e": 0.05,
          "π": 0.05
        },
        operators: {
          Expression.addition: 0.2,
          Expression.subtraction: 0.2,
          Expression.multiplication: 0.2,
          Expression.division: 0.2,
          Expression.power: 0.2
        },
        functions: {
          Expression.sin: 0.1,
          Expression.cos: 0.1,
          Expression.tan: 0.1,
          Expression.loge: 0.1
        },
        bigFunctions: {},
        minItem: 3,
        maxItem: 5,
        minNumRange: 1,
        maxNumRange: 20,
        maxAbs: 1
    ),
  };
}

class ExpressionSeed {
  final int level;
  final Map<String, double> variables;
  final Map<String, double> constants;
  final Map<String, double> operators;
  final Map<String, double> functions;
  final Map<String, double> bigFunctions;
  final int minItem;
  final int maxItem;
  final int minNumRange;
  final int maxNumRange;
  final double maxAbs;

  final String? title;
  final String? description;

  ExpressionSeed({required this.level, required this.variables, required this.constants, required this.operators, required this.functions,
    required this.bigFunctions, required this.minItem, required this.maxItem, required this.minNumRange, required this.maxNumRange, required this.maxAbs,
    this.title, this.description
  });

  Expression generateExpression(double ansNum, bool up) {
    Expression exp = Constant(value: 0);
    double ans = 0;

    do {
      try {
        int itemCount = Random().nextInt(maxItem - minItem + 1) + minItem;
        exp = getExpression(itemCount);
        exp = getBigFunction(exp);
        ans = (simplifyConstant(exp) as Constant).value;
      } catch (e) {
        continue;
      }
    } while (ans > ansNum != up || (ans - ansNum).abs() >= maxAbs || ans == ansNum || ans.isNaN);

    return exp;
  }

  String randomGet(Map<String, double> items) {
    double random = Random().nextDouble();
    double sum = 0;
    for (int i = 0; i < items.length; i++) {
      sum += items.values.toList()[i];
      if (sum > random) return items.keys.toList()[i];
    }
    return "null";
  }

  Expression getItem() {
    String variable = randomGet(variables);
    Expression exp;
    if (variable != "null") {
      exp = Variable(symbol: variable);
    } else {
      exp = getConstant();
    }
    return exp;
  }

  Expression getConstant() {
    String constant = randomGet(constants);
    Expression exp;
    if (constant != "null") {
      exp = Variable(symbol: constant);
    } else {
      exp = Constant(value: (Random().nextDouble() * (maxNumRange - minNumRange) + minNumRange).roundToDouble());
    }
    return exp;
  }

  String getOperator() {
    String op = randomGet(operators);
    if (op == "null") {
      op = Expression.addition;
    }
    return op;
  }

  String getFunction() {
    return randomGet(functions);
  }

  Expression getBigFunction(Expression exp) {
    if (isConstant(exp, "x")) {
      return exp;
    } else {
      String function = randomGet(bigFunctions);
      switch (function) {
        case Expression.differentiate:
        case Expression.limit:
          return BigFunctionCall(bigFunctionName: function, argument: exp, symbol: "x", to: getConstant());
        case Expression.integrate:
          return BigFunctionCall(bigFunctionName: function, argument: exp, symbol: "x", to: getConstant(), from: getConstant());
        case Expression.sum:
          return BigFunctionCall(bigFunctionName: function, argument: exp, symbol: "x", to: Constant(value: Random().nextInt(maxNumRange - minNumRange) + minNumRange as double), from: Constant(value: Random().nextInt(maxNumRange - minNumRange) + minNumRange as double));
      }
    }
    return BigFunctionCall(bigFunctionName: Expression.differentiate, argument: exp, symbol: "x", to: getConstant());
  }

  Expression getExpression(int count) {
    if (count > 2) {
      int random = Random().nextInt(count - 1) + 1;
      String function = getFunction();
      if (function == "null") {
        return BinaryOperation(
            left: getExpression(random),
            right: getExpression(count - random),
            operator: getOperator()
        );
      } else {
        return FunctionCall(functionName: function, argument: getExpression(count - 1));
      }
    } else {
      if (count == 2) {
        return BinaryOperation(
            left: getItem(),
            right: getItem(),
            operator: getOperator()
        );
      } else {
        return getItem();
      }
    }
  }
}