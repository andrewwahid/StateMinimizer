import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTableImportPage.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTablePage.dart';
import 'package:implication_solver/Utilities/Routing.dart';
import 'package:implication_solver/Utilities/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TruthTableInfoPage extends StatefulWidget {
  @override
  _TruthTableInfoPageState createState() => _TruthTableInfoPageState();
}

class _TruthTableInfoPageState extends State<TruthTableInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String _variablesCount;


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text("How many variables do you have ?", style: Theme.of(context).textTheme.headline2,),
              SizedBox(height: 120,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.4),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if (val.isEmpty)
                      return 'required.';
                    if (!Utils.isNumericInt(val))
                      return "invalid input.";
                    if (int.parse(val) < 3)
                      return "minimum number of inputs is 3";
                    if (int.parse(val) > 10)
                      return "maximum number of inputs is 10";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "No of variables"
                  ),
                  onChanged: (val) => _variablesCount = val,
                ),
              ),
              SizedBox(height: 75,),
              RaisedButton(
                onPressed: (){
                  if (!_formKey.currentState.validate())
                    return;
                  Navigator.of(context).push(
                      SharedAxisRoute(builder: (context) => TruthTablePage(totalVariables: int.parse(_variablesCount),))
                  );
                },
                child: Text("Next"),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50,),
                  Column(
                    children: [
                      IconButton(
                        onPressed: (){
                          launchUrl(Uri.parse("https://github.com/andrewwahid/StateMinimizer"));
                        },
                        iconSize: 50,
                        splashRadius: 0.1,
                        icon: Icon(FontAwesomeIcons.github),
                      ),
                      Text("@andrewwahid", style: TextStyle(color: Colors.white54),)
                    ],
                  ),
                  Spacer(),
                  RaisedButton(
                    color: Colors.yellow[700],
                    onPressed: (){
                      Navigator.of(context).push(
                          SharedAxisRoute(builder: (context) => TruthTableImportPage())
                      );
                    },
                    child: Text("Import", style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(width: 50,),
                ],
              ),
              SizedBox(height: 25,),
            ],
          ),
        ),
      ),
    );
  }
}
