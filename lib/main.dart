import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({Key? key}) : super(key: key);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = '0';
  String result = '0';
  String expression = '';
  double resultFontSize = 45.0;
  double equationFontSize = 35.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        resultFontSize = 45.0;
        equationFontSize = 35.0;
        equation = '0';
        result = '0';
      } else if (buttonText == '⌫') {
        resultFontSize = 35.0;
        equationFontSize = 45.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == '') {
          equation = '0';
        }
      } else if (buttonText == '=') {
        resultFontSize = 45.0;
        equationFontSize = 35.0;
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = new Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = 'Syntax Error';
        }
      } else {
        if (equation == '0') {
          equation = buttonText;
        } else {
          resultFontSize = 35.0;
          equationFontSize = 45.0;
          equation += buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * .1 * buttonHeight,
      color: buttonColor,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid),
            ),
          ),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.blueGrey[900],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton('C', 1, Colors.black54),
                        buildButton('⌫', 1, Colors.blueGrey),
                        buildButton('÷', 1, Colors.black12)
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('7', 1, Colors.black45),
                        buildButton('8', 1, Colors.black45),
                        buildButton('9', 1, Colors.black45)
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('4', 1, Colors.black45),
                        buildButton('5', 1, Colors.black45),
                        buildButton('6', 1, Colors.black45)
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('1', 1, Colors.black45),
                        buildButton('2', 1, Colors.black45),
                        buildButton('3', 1, Colors.black45)
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('.', 1, Colors.black45),
                        buildButton('0', 1, Colors.black45),
                        buildButton('00', 1, Colors.black45)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .25,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton('×', 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('-', 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('+', 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton('=', 2, Colors.blueGrey),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
