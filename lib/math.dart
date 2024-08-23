import 'dart:math';

abstract class Expression {
  static const String addition = "+";
  static const String subtraction = "-";
  static const String multiplication = "*";
  static const String division = "/";
  static const String power = "^";

  static const String sin = "sin";
  static const String cos = "cos";
  static const String tan = "tan";
  static const String asin = "asin";
  static const String acos = "acos";
  static const String atan = "atan";
  static const String loge = "loge";
  static const String log2 = "log2";
  static const String log10 = "log10";

  static const String integrate = "integrate";
  static const String differentiate = "differentiate";
  static const String limit = "limit";
  static const String sum = "sum";

  /*switch (exp.functionName) {
      case Expression.sin:
      case Expression.cos:
      case Expression.tan:
      case Expression.asin:
      case Expression.acos:
      case Expression.atan:
      case Expression.loge:
      case Expression.log2:
      case Expression.log10:
    }*/

  String toLateX() {
    return toString();
  }
}

class Variable extends Expression {
  final String symbol;
  Variable({required this.symbol});

  @override
  String toString() {
    return symbol;
  }
}

class Constant extends Expression {
  final double value;
  Constant({required this.value});

  @override
  String toString() {
    return value.toString();
  }
}

class BinaryOperation extends Expression {
  final Expression left;
  final Expression right;
  final String operator;
  BinaryOperation({required this.left, required this.right, required this.operator});

  @override
  String toString() {
    if (operator == Expression.multiplication || operator == Expression.division) {
      if (left is BinaryOperation && right is BinaryOperation) {
        return "($left) $operator ($right)";
      } else if (left is BinaryOperation) {
        return "($left) $operator $right";
      } else if (right is BinaryOperation) {
        return "$left $operator ($right)";
      }
    } else if (operator == Expression.power) {
      if (left is BinaryOperation && right is BinaryOperation) {
        return "($left)$operator($right)";
      } else if (left is BinaryOperation) {
        return "($left)$operator$right";
      } else if (right is BinaryOperation) {
        return "$left$operator($right)";
      }
    }

    return "$left $operator $right";
  }

  @override
  String toLateX() {
    switch (operator) {
      case Expression.addition:
        return "${left.toLateX()} + ${right.toLateX()}";
      case Expression.subtraction:
        if (right is BinaryOperation) {
          return "${left.toLateX()} - \\left(${right.toLateX()}\\right)";
        } else {
          return "${left.toLateX()} - ${right.toLateX()}";
        }
      case Expression.multiplication:
        String leftString = left.toLateX();
        String rightString = right.toLateX();
        if (left is BinaryOperation) {
          if ((left as BinaryOperation).operator == Expression.addition || (left as BinaryOperation).operator == Expression.subtraction) {
            leftString = "\\left(${left.toLateX()}\\right)";
          }
        }
        if (right is BinaryOperation) {
          if ((right as BinaryOperation).operator == Expression.addition || (right as BinaryOperation).operator == Expression.subtraction) {
            rightString = "\\left(${right.toLateX()}\\right)";
          }
        }
        return "$leftString \\times $rightString";
      case Expression.division:
        return "\\frac{${left.toLateX()}}{${right.toLateX()}}";
      case Expression.power:
        if (left is BinaryOperation) {
          return "{\\left(${left.toLateX()}\\right)}^{${right.toLateX()}}";
        }
        return "{${left.toLateX()}}^{${right.toLateX()}}";
    }
    return toString();
  }
}

class UnaryOperation extends Expression {
  final Expression operand;
  final String operator;
  UnaryOperation({required this.operand, required this.operator});

  @override
  String toString() {
    return "$operator$operand";
  }
}

class FunctionCall extends Expression {
  final String functionName;
  final Expression argument;
  FunctionCall({required this.functionName, required this.argument});

  @override
  String toString() {
    return "$functionName($argument)";
  }

  @override
  String toLateX() {
    switch (functionName) {
      case Expression.sin:
        return "\\sin\\left(${argument.toLateX()}\\right)";
      case Expression.cos:
        return "\\cos\\left(${argument.toLateX()}\\right)";
      case Expression.tan:
        return "\\tan\\left(${argument.toLateX()}\\right)";
      case Expression.asin:
        return "\\arcsin\\left(${argument.toLateX()}\\right)";
      case Expression.acos:
        return "\\arccos\\left(${argument.toLateX()}\\right)";
      case Expression.atan:
        return "\\arctan\\left(${argument.toLateX()}\\right)";
      case Expression.loge:
        return "\\ln{\\left(${argument.toLateX()}\\right)}";
      case Expression.log2:
        return "\\log_{2}{\\left(${argument.toLateX()}\\right)}";
      case Expression.log10:
        return "\\log_{10}{\\left(${argument.toLateX()}\\right)}";
    }
    return toString();
  }

}

class BigFunctionCall extends Expression {
  final String bigFunctionName;
  final Expression argument;
  final String symbol;
  final Expression? from;
  final Expression to;

  BigFunctionCall({required this.bigFunctionName, required this.argument, required this.symbol, this.from, required this.to});

  @override
  String toString() {
    switch (bigFunctionName) {
      case Expression.differentiate:
        return "d/d$symbol[$argument]$symbol=$to";
      case Expression.limit:
        return "limit[$argument]$symbol->$to";
      case Expression.integrate:
        return "$from~$to|∫$argument d$symbol";
      case Expression.sum:
        return "Σ[$argument]$symbol=$from->$to";
    }
    return "f[$argument]";
  }

  @override
  String toLateX() {
    switch (bigFunctionName) {
      case Expression.differentiate:
        return "\\frac{d}{d$symbol}_{$symbol=${to.toLateX()}}\\left[${argument.toLateX()}\\right]";
      case Expression.integrate:
        return "\\int_{${from!.toLateX()}}^{${to.toLateX()}} ${argument.toLateX()} d$symbol";
      case Expression.limit:
        return "\\lim_{$symbol \\to ${to.toLateX()}}\\left[${argument.toLateX()}\\right]";
      case Expression.sum:
        return "\\sum_{$symbol=${from!.toLateX()}}^{${to.toLateX()}}\\left[${argument.toLateX()}\\right]";
    }
    return toString();
  }
}


Constant operating(Constant a, Constant b, String operator) {
  switch (operator) {
    case Expression.addition:
      return Constant(value: a.value + b.value);
    case Expression.subtraction:
      return Constant(value: a.value - b.value);
    case Expression.multiplication:
      return Constant(value: a.value * b.value);
    case Expression.division:
      return Constant(value: a.value / b.value);
    case Expression.power:
      return Constant(value: pow(a.value, b.value) as double);
    default:
      throw UnsupportedError("非対応の算術演算子です。");
  }
}

Expression simplify(Expression exp) {
  if (exp is BinaryOperation) {
    Expression leftAns = simplify(exp.left);
    Expression rightAns = simplify(exp.right);
    String operator = exp.operator;
    if (leftAns is Constant && rightAns is Constant) {
      return operating(leftAns, rightAns, operator);
    } else if (leftAns is Constant) {
      if (leftAns.value == 0) {
        if (operator == Expression.multiplication || operator == Expression.division) {
          return Constant(value: 0);
        } else if (operator == Expression.addition) {
          return rightAns;
        } else if (operator == Expression.subtraction) {
          return UnaryOperation(operand: rightAns, operator: Expression.subtraction);
        }
      } else if (leftAns.value == 1) {
        if (operator == Expression.multiplication) {
          return rightAns;
        }
      }
    } else if (rightAns is Constant) {
      if (rightAns.value == 0) {
        if (operator == Expression.multiplication) {
          return Constant(value: 0);
        } else if (operator == Expression.addition || operator == Expression.subtraction) {
          return leftAns;
        }
      } else if (rightAns.value == 1) {
        if (operator == Expression.multiplication ||
            operator == Expression.division) {
          return leftAns;
        }
      }
    }
    return BinaryOperation(
      left: leftAns,
      right: rightAns,
      operator: exp.operator
    );
  } else if (exp is FunctionCall) {
    Expression e = simplify(exp.argument);
    if (e is Constant) {
      switch (exp.functionName) {
        case Expression.sin:
          return Constant(value: sin(e.value));
        case Expression.cos:
          return Constant(value: cos(e.value));
        case Expression.tan:
          return Constant(value: tan(e.value));
        case Expression.asin:
          return Constant(value: asin(e.value));
        case Expression.acos:
          return Constant(value: acos(e.value));
        case Expression.atan:
          return Constant(value: atan(e.value));
        case Expression.loge:
          return Constant(value: log(e.value));
        case Expression.log2:
          return Constant(value: log(e.value) / ln2);
        case Expression.log10:
          return Constant(value: log(e.value) / ln10);
      }
    } else {
      return FunctionCall(functionName: exp.functionName, argument: e);
    }

  } else if (exp is BigFunctionCall) {
    switch (exp.bigFunctionName) {
      case Expression.differentiate:
        return simplify(assignmentDifferentiate(simplify(exp.argument), (simplify(exp.to) as Constant).value, exp.symbol));
      case Expression.limit:
        return Constant(value: limit(exp.argument, (simplify(exp.to) as Constant).value, exp.symbol));
      case Expression.integrate:
        return Constant(value: assignmentIntegrate(exp.argument, (simplify(exp.from!) as Constant).value, (simplify(exp.to) as Constant).value, exp.symbol));
      case Expression.sum:
        return Constant(value: sum(exp.argument, (simplify(exp.from!) as Constant).value.toInt(), (simplify(exp.to) as Constant).value.toInt(), exp.symbol));
    }

  } else if (exp is Variable) {
    if (exp.symbol == "e") {
      return Constant(value: e);
    } else if (exp.symbol == "π") {
      return Constant(value: pi);
    }
  }
  return exp;
}

Expression simplifyConstant(Expression exp) {
  int count = 0;
  while (exp is! Constant && count < 100) {
    exp = simplify(exp);
    count ++;
  }
  return exp;
}

Expression expand(Expression exp) {
  return exp;
}

Expression differentiate(Expression exp, String symbol) {
  if (isConstant(exp, symbol)) {

    return Constant(value: 0);
  } else if (exp is BinaryOperation) {

    if (exp.operator == Expression.addition || exp.operator == Expression.subtraction) {
      return BinaryOperation(
        left: differentiate(exp.left, symbol),
        right: differentiate(exp.right, symbol),
        operator: exp.operator
      );

    } else if (exp.operator == Expression.multiplication) {
      return BinaryOperation(
        left: BinaryOperation(
          left: differentiate(exp.left, symbol),
          right: exp.right,
          operator: Expression.multiplication
        ),
        right: BinaryOperation(
          left: exp.left,
          right: differentiate(exp.right, symbol),
          operator: Expression.multiplication
        ),
        operator: Expression.addition
      );

    } else if (exp.operator == Expression.division) {
      return BinaryOperation(
        left: BinaryOperation(
            left: BinaryOperation(
                left: differentiate(exp.left, symbol),
                right: exp.right,
                operator: Expression.multiplication
            ),
            right: BinaryOperation(
                left: exp.left,
                right: differentiate(exp.right, symbol),
                operator: Expression.multiplication
            ),
            operator: Expression.subtraction
        ),
        right: BinaryOperation(
          left: exp.right,
          right: Constant(value: 2),
          operator: Expression.power
        ),
        operator: Expression.division
      );

    } else if (exp.operator == Expression.power) {
      if (!isConstant(exp.left, symbol) && !isConstant(exp.right, symbol)) {
        throw UnsupportedError("対数微分は実装されていません。");
      } else if (isConstant(exp.left, symbol)) {
        return BinaryOperation(
          left: BinaryOperation(
            left: BinaryOperation(
              left: exp.left,
              right: exp.right,
              operator: Expression.power
            ),
            right: FunctionCall(
              functionName: Expression.loge,
              argument: exp.left
            ),
            operator: Expression.multiplication
          ),
          right: differentiate(exp.right, symbol),
          operator: Expression.multiplication
        );
      } else if (isConstant(exp.right, symbol)) {
        return BinaryOperation(
          left: BinaryOperation(
            left: exp.right,
            right: BinaryOperation(
              left: exp.left,
              right: BinaryOperation(
                left: exp.right,
                right: Constant(value: 1),
                operator: Expression.subtraction
              ),
              operator: Expression.power
            ),
            operator: Expression.multiplication
          ),
          right: differentiate(exp.left, symbol),
          operator: Expression.multiplication
        );
      } else {
        return Constant(value: 0);
      }
    }

  } else if (exp is Variable) {
    return Constant(value: 1);

  } else if (exp is FunctionCall) {
    switch (exp.functionName) {
      case Expression.sin:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: FunctionCall(functionName: Expression.cos, argument: exp.argument),
          operator: Expression.multiplication
        );
      case Expression.cos:
        return BinaryOperation(
          left: UnaryOperation(operand: differentiate(exp.argument, symbol), operator: Expression.subtraction),
          right: FunctionCall(functionName: Expression.sin, argument: exp.argument),
          operator: Expression.multiplication
        );
      case Expression.tan:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: BinaryOperation(
            left: FunctionCall(functionName: Expression.cos, argument: exp.argument),
            right: Constant(value: 2),
            operator: Expression.power
          ),
          operator: Expression.division
        );
      case Expression.asin:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: BinaryOperation(
            left: BinaryOperation(
              left: Constant(value: 1),
              right: BinaryOperation(
                left: exp.argument,
                right: Constant(value: 2),
                operator: Expression.power
              ),
              operator: Expression.subtraction
            ),
            right: Constant(value: 0.5),
            operator: Expression.power
          ),
          operator: Expression.division
        );
      case Expression.acos:
        return UnaryOperation(
          operand: BinaryOperation(
              left: differentiate(exp.argument, symbol),
              right: BinaryOperation(
                  left: BinaryOperation(
                      left: Constant(value: 1),
                      right: BinaryOperation(
                          left: exp.argument,
                          right: Constant(value: 2),
                          operator: Expression.power
                      ),
                      operator: Expression.subtraction
                  ),
                  right: Constant(value: 0.5),
                  operator: Expression.power
              ),
              operator: Expression.division
          ),
          operator: Expression.subtraction
        );
      case Expression.atan:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: BinaryOperation(
            left: Constant(value: 1),
            right: BinaryOperation(
              left: exp.argument,
              right: Constant(value: 2),
              operator: Expression.power
            ),
            operator: Expression.subtraction
          ),
          operator: Expression.division
        );
      case Expression.loge:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: exp.argument,
          operator: Expression.division
        );
      case Expression.log2:
        return BinaryOperation(
          left: differentiate(exp.argument, symbol),
          right: BinaryOperation(
            left: exp.argument,
            right: FunctionCall(functionName: Expression.loge, argument: Constant(value: 2)),
            operator: Expression.multiplication
          ),
          operator: Expression.division
        );
      case Expression.log10:
        return BinaryOperation(
            left: differentiate(exp.argument, symbol),
            right: BinaryOperation(
                left: exp.argument,
                right: FunctionCall(functionName: Expression.loge, argument: Constant(value: 10)),
                operator: Expression.multiplication
            ),
            operator: Expression.division
        );
    }
  }

  return exp;
}

Expression integrate(Expression exp, String symbol) {
  if (isConstant(exp, symbol)) {
    return BinaryOperation(
      left: exp,
      right: Variable(symbol: symbol),
      operator: Expression.multiplication
    );

  } else if (exp is Variable) {
    return BinaryOperation(
      left: Constant(value: 0.5),
      right: BinaryOperation(
        left: exp,
        right: Constant(value: 2),
        operator: Expression.power
      ),
      operator: Expression.multiplication
    );
  } else if (exp is FunctionCall) {
    switch (exp.functionName) {
      case Expression.sin:
      case Expression.cos:
      case Expression.tan:
      case Expression.asin:
      case Expression.acos:
      case Expression.atan:
      case Expression.loge:
      case Expression.log2:
      case Expression.log10:
    }
  }

  throw UnsupportedError("未実装の不定積分です。");
}

Expression assignmentDifferentiate(Expression exp, double argument, String symbol) {
  return simplify(assignment(differentiate(exp, symbol), argument, symbol));
}

double assignmentIntegrate(Expression exp, double from, double to, String symbol) {
  double sum = 0;

  List<double> x = [-0.9491079123427585, -0.7415311855993945, -0.4058451513773972, 0.0, 0.4058451513773972, 0.7415311855993945, 0.9491079123427585];
  List<double> w = [0.1294849661688697, 0.2797053914892767, 0.3818300505051189, 0.4179591836734694, 0.3818300505051189, 0.2797053914892767, 0.1294849661688697];

  double mid = 0.5 * (from + to);
  double halfLength = 0.5 * (to - from);

  for (int i = 0; i < x.length; i++) {
    double xi = mid + halfLength * x[i];
    sum += w[i] * (simplify(assignment(exp, xi, "x")) as Constant).value;
  }

  return sum * halfLength;
}

double limit(Expression exp, double x, String symbol, {double h = 1e-50, int maxInter = 10000}) {
  double a = x;
  double previousValue = (simplify(assignment(exp, a, symbol)) as Constant).value;
  for (int i = 0; i < maxInter; i++) {
    a = x + pow(0.5, i);
    double currentValue = (simplify(assignment(exp, a, symbol)) as Constant).value;
    if ((currentValue - previousValue).abs() < h) {
      return currentValue;
    }
    previousValue = currentValue;
  }

  if (previousValue == double.infinity || previousValue == double.negativeInfinity) {
    return previousValue;
  }

  throw Exception("収束しませんでした。");
}

double sum(Expression exp, int k, int n, String symbol) {
  double sum = 0;
  for (int i = k; i <= n; i++) {
    sum += (simplify(assignment(exp, i.toDouble(), symbol)) as Constant).value;
  }
  return sum;
}

Expression assignment(Expression exp, double argument, String symbol) {
  if (exp is BinaryOperation) {
    return BinaryOperation(
      left: assignment(exp.left, argument, symbol),
      right: assignment(exp.right, argument, symbol),
      operator: exp.operator
    );
  } else if (exp is FunctionCall) {
    return FunctionCall(functionName: exp.functionName, argument: assignment(exp.argument, argument, symbol));
  } else if (exp is Variable) {
    if (exp.symbol == symbol) return Constant(value: argument);
  } else if (exp is BigFunctionCall) {
    return BigFunctionCall(
      bigFunctionName: exp.bigFunctionName,
      argument: assignment(exp.argument, argument, symbol),
      symbol: exp.symbol,
      from: exp.from == null ? exp.from : assignment(exp.from!, argument, symbol),
      to: assignment(exp.to, argument, symbol)
    );
  }
  return exp;
}

bool isConstant(Expression exp, String symbol) {
  if (exp is Variable) {
    if (exp.symbol == symbol) return false;
  } else if (exp is BinaryOperation) {
    return isConstant(exp.left, symbol) && isConstant(exp.right, symbol);
  } else if (exp is UnaryOperation) {
    return isConstant(exp.operand, symbol);
  } else if (exp is FunctionCall) {
    return isConstant(exp.argument, symbol);
  } else if (exp is BigFunctionCall) {
    return isConstant(exp.argument, symbol);
  }
  return true;
}