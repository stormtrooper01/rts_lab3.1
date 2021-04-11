import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './Fermat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rts_lab3.1',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(title: 'Fermat factorization'),
    );
  }
}

class HomePage extends StatelessWidget{
  final String title;
  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                InputForm(
                  verticalPadding: 20.0,
                  decompositionNumberHint: "Enter your number",
                  decompositionNumberLabel: "Factorization number",
                  stepsHint: "Enter the amount of steps",
                  stepsLabel: "Amount of calculation steps",
                  firstMultiplierLabel: "First multiplier",
                  secondMultiplierLabel: "Second multiplier",
                ),
              ],
            ),
          ),
        )
    );
  }
}

class _InputData{
  int decompositionNumber;
  int steps;
}

class InputForm extends StatefulWidget {
  final double verticalPadding;
  final String decompositionNumberHint;
  final String decompositionNumberLabel;
  final String stepsHint;
  final String stepsLabel;
  final String firstMultiplierLabel;
  final String secondMultiplierLabel;

  InputForm({Key key,
    @required this.verticalPadding,
    @required this.decompositionNumberLabel,
    @required this.decompositionNumberHint,
    @required this.stepsLabel,
    @required this.stepsHint,
    @required this.firstMultiplierLabel,
    @required this.secondMultiplierLabel,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _InputFormState(
    verticalPadding: verticalPadding,
    decompositionNumberHint: decompositionNumberHint,
    decompositionNumberLabel: decompositionNumberLabel,
    stepsHint: stepsHint,
    stepsLabel: stepsLabel,
    firstMultiplierLabel: firstMultiplierLabel,
    secondMultiplierLabel: secondMultiplierLabel,
  );

}

class _InputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _InputData data = _InputData();

  final double verticalPadding;
  final String decompositionNumberHint;
  final String decompositionNumberLabel;
  final String stepsHint;
  final String stepsLabel;
  final String firstMultiplierLabel;
  final String secondMultiplierLabel;
  TextEditingController textPController = TextEditingController();
  TextEditingController textQController = TextEditingController();

  _InputFormState({
    @required this.verticalPadding,
    @required this.decompositionNumberLabel,
    @required this.decompositionNumberHint,
    @required this.stepsLabel,
    @required this.stepsHint,
    @required this.firstMultiplierLabel,
    @required this.secondMultiplierLabel,
  }) : super();

  void submit() async{
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      var map = {
        "decompositionNumber": data.decompositionNumber,
        "steps": data.steps
      };
      List<int> result = await compute(fermatDecomposition, map);
      if(result == null){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Can't find multipliers in this amount of steps"),
        ));
      }
      else{
        int p = result[0];
        int q = result[1];
        int stepsToPerform = result[2];
        textPController.text = p.toString();
        textQController.text = q.toString();
      }
    }
  }

  int _validateInt(String value) {
    int iValue;
    try {
      iValue = int.parse(value);
    } catch (e) {
      return null;
    }
    return iValue;
  }

  String _validateN(String value){
    int iValue = _validateInt(value);
    if (iValue == null){
      return 'The number should be integer';
    }
    if (iValue < 1){
      return 'The number should be bigger than 1';
    }
    if (iValue % 2 == 0){
      return 'The number should be odd';
    }
    return null;
  }

  String _validateSteps(String value){
    int iValue = _validateInt(value);
    if (iValue == null){
      return 'The number should be integer';
    }
    if(iValue < 0){
      return 'The number should be bigger than 1';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [
      TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          validator: this._validateN,
          onSaved: (String value) {
            this.data.decompositionNumber = int.parse(value);
          },
          decoration: InputDecoration(
              hintText: this.decompositionNumberHint,
              labelText: this.decompositionNumberLabel
          )
      ),
      TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          validator: this._validateSteps,
          onSaved: (String value) {
            this.data.steps = int.parse(value);
          },
          decoration: InputDecoration(
              hintText: this.stepsHint,
              labelText: this.stepsLabel
          )
      ),
      TextFormField(
          enabled: false,
          controller: textPController,
          decoration: InputDecoration(
            labelText: this.firstMultiplierLabel,
          )
      ),
      TextFormField(
          enabled: false,
          controller: textQController,
          decoration: InputDecoration(
            labelText: this.secondMultiplierLabel,
          )
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          child: Text(
            'Calculate',
            style: TextStyle(
                color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: this.submit,
          color: Colors.teal,
        ),
      ),
    ];
    return Container(
        child: Form(
            key: this._formKey,
            child: Expanded(
              child: ListView(
                children: rows,
              ),
            )
        )
    );
  }
}

class Title extends StatelessWidget{
  final String title;
  final String description;
  Title({Key key, @required this.title, @required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  this.description,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
