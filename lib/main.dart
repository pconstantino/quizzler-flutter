import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctAnswers = 0;

  void addResult(bool selection) {
    bool result = selection == quizBrain.getQuestionAnswer() ? true : false;
    scoreKeeper.add(
      Icon(
        result ? Icons.check : Icons.close,
        color: result ? Colors.green : Colors.red,
      ),
    );

    if(result)
      {
        correctAnswers++;
      }

    if (!quizBrain.nextQuestion()) {

      int totalQuestions = scoreKeeper.length;
      Alert(
        style: AlertStyle(isOverlayTapDismiss: false),
          type: correctAnswers/totalQuestions > 0.5 ? AlertType.success : AlertType.error,
          context: context,
          title: "Finished!",
          desc: "You've reached the end of the quiz with a score of $correctAnswers/$totalQuestions.",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ]).show();
      restartQuiz();
    }
  }

  void restartQuiz() {
    scoreKeeper.clear();
    quizBrain.restartQuestions();
    correctAnswers = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                setState(() {
                  addResult(true);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                setState(() {
                  addResult(false);
                });
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}
