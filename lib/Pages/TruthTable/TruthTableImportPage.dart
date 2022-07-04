import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTablePage.dart';
import 'package:implication_solver/Utilities/PreconfiguredTT.dart';
import 'package:implication_solver/Utilities/Routing.dart';

class TruthTableImportPage extends StatefulWidget {
  @override
  _TruthTableImportPageState createState() => _TruthTableImportPageState();
}

class _TruthTableImportPageState extends State<TruthTableImportPage> {
  final _formKey = GlobalKey<FormState>();
  final _jsonController = TextEditingController();
  String _truthTableJSON;


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
              //Spacer(),
              Text("INSERT YOUR TRUTH TABLE INFO", style: Theme.of(context).textTheme.headline2,),
              SizedBox(height: 70,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenSize.height*0.35,
                    width: screenSize.width*0.1,
                    child: ListView.builder(
                      itemCount: PreconfiguredTT.configurations.length,
                      itemBuilder: (BuildContext context, int index){
                        MapEntry entry = PreconfiguredTT.configurations.entries.elementAt(index);
                        return ListTile(
                          title: Text(entry.key),
                          onTap: (){
                            _truthTableJSON = json.encode(entry.value);
                            _jsonController.text = _truthTableJSON;
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: screenSize.width*0.4,
                    //margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.25),
                    child: TextFormField(
                      controller: _jsonController,
                      style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLines: 15,
                      validator: (val){
                        if (val.isEmpty)
                          return 'required.';
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Insert here",
                        border: OutlineInputBorder()
                      ),
                      onChanged: (val) => _truthTableJSON = val,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    color: Colors.red[900],
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 15,),
                  RaisedButton(
                    onPressed: (){
                      if (!_formKey.currentState.validate())
                        return;
                      _truthTableJSON = _truthTableJSON.replaceAll(" ", "");
                      try {
                        json.decode(_truthTableJSON);
                      } catch (e) {
                        print(e);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          headerAnimationLoop: false,
                          width: screenSize.width*0.5,
                          title: "Cannot parse input",
                          desc: "Couldn't parse your input, please make sure to enter a 'RFC 8259' formatted input",
                          btnCancelOnPress: (){},
                        ).show();
                        return;
                      }
                      Navigator.of(context).push(
                          SharedAxisRoute(builder: (context) => TruthTablePage(jsonTable: _truthTableJSON,))
                      );
                    },
                    child: Text("Next"),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text("*NOTE: your input is not validated against a truth table scheme, if you input a wrong scheme you will get a wrong output!", style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.red),),
            ],
          ),
        ),
      ),
    );
  }
}
