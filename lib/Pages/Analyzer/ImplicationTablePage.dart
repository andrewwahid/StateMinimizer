import 'package:flutter/material.dart';
import 'package:implication_solver/Objects/TTEntry.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTableInfoPage.dart';
import 'package:implication_solver/Utilities/Routing.dart';
import 'package:implication_solver/Utilities/Utils.dart';

class ImplicationTablePage extends StatefulWidget {
  final List<TTEntry> truthTable;

  ImplicationTablePage({@required this.truthTable});

  @override
  _ImplicationTablePageState createState() => _ImplicationTablePageState();
}

class _ImplicationTablePageState extends State<ImplicationTablePage> {
  bool _analyzePreviousStates = false;
  Map _analyzedStates = new Map();
  bool _showSets = false;

  void adjustImplications(List<String> implications){
    for (int i=0; i<implications.length; i++){
      if (implications[i].contains("-"))
        continue;
      implications[i] = implications[i][0] + "-" + implications[i][1];
    }
  }

  List getImpliedSets(){
    List impliedSets = new List();
    for (MapEntry entry in _analyzedStates.entries){
      if (entry.value[0] == false)
        continue;
      var vars = entry.key.toString().split("");
      var insertFlag = true;
      for (var currentSet in impliedSets){
        if (currentSet.contains(vars[0])) {
          insertFlag = false;
          if (!currentSet.contains(vars[1])) {
            currentSet.add(vars[1]);
          }
        }else if (currentSet.contains(vars[1])){
          insertFlag = false;
          if (!currentSet.contains(vars[0])) {
            currentSet.add(vars[0]);
          }
        }
      }
      if (insertFlag)
        impliedSets.add([vars[0], vars[1]]);
    }
    return impliedSets;
  }

  analyzeStates(String firstState, String secondState, bool deepAnalyze){
    var implicationState = firstState+secondState;
    for (TTEntry state1 in widget.truthTable){
      if (state1.presentState == firstState){
        for (TTEntry state2 in widget.truthTable){
          if (state2.presentState == secondState){
            if (state2.presentOutput != state1.presentOutput){
              _analyzedStates[implicationState] = [false, "Output is not valid!"];
            }else{
              List<String> implications = new List();
              var firstImplication = state1.getNextState(0)+state2.getNextState(0);
              var secondImplication = state1.getNextState(1)+state2.getNextState(1);
              /// if the implied next states are same as implied present states then skip (Present States AD or DA and implied states AD)
              /// if the implied next states are the same (AA or HH or BB) then skip
              if (!(firstImplication == implicationState || firstImplication == Utils.reverse(implicationState)))
                if (!Utils.isStringEqualChars(firstImplication))
                  implications.add(firstImplication);
              if (!(secondImplication == implicationState || secondImplication == Utils.reverse(implicationState)))
                if (!Utils.isStringEqualChars(secondImplication))
                  implications.add(secondImplication);
              /// if we are deep analyzing then we will check all previous noted implied states, if anytime it was false, then change current implication to false!
              if (deepAnalyze) {
                for (MapEntry entry in _analyzedStates.entries) {
                  if (implications.contains(entry.key) ||
                      implications.contains(Utils.reverse(entry.key))) {
                    if (entry.value[0] == false) {
                      adjustImplications(implications);
                      _analyzedStates[implicationState] = [false, entry.key + " is not implied!", implications.join(",")];
                      return _analyzedStates[implicationState];
                    }
                  }
                }
              }
              adjustImplications(implications);
              _analyzedStates[implicationState] = [true, implications.join(",")];
            }
          }
        }
      }
    }
    return _analyzedStates[implicationState];
  }

  Widget generateImplication(){
    int length = widget.truthTable.length - 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i=0; i<length; i++)
                  Container(
                    height: 64,
                    child: Center(child: Text(widget.truthTable[i+1].presentState))
                  )
              ],
            ),
            SizedBox(width: 25,),
            for (int k=0; k<length; k++)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 64.0 * k,),
                  for (int i=0; i<length-k; i++)
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).accentColor, width: 1)
                      ),
                      /// widget.truthTable[k] -> Column
                      /// widget.truthTable[i+1+k] -> Row
                      child: Builder(
                        builder: (BuildContext _){
                          var stateResult = analyzeStates(widget.truthTable[k].presentState, widget.truthTable[i+1+k].presentState, _analyzePreviousStates);
                          if (stateResult[0] == false) {
                            if (stateResult.length == 3) {
                              return Center(
                                child: Stack(
                                  children: [
                                    Center(child: Opacity(opacity: 0.5, child: Icon(Icons.close, color: Colors.red,))),
                                    Center(child: Opacity(opacity: 0.25, child: Text(stateResult[2].toString().replaceAll(",", "\n"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 17, fontWeight: FontWeight.bold),))),
                                  ],
                                ),
                              );
                            }
                            return Icon(Icons.close, color: Colors.red,);
                          }
                          if (stateResult[1].toString().isEmpty)
                            return Icon(Icons.check, color: Colors.greenAccent,);
                          return Center(child: Text(stateResult[1].toString().replaceAll(",", "\n"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 17, fontWeight: FontWeight.bold),));
                        },
                      ),
                    ),
                ],
              ),
          ],
        ),
        SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30,),
            for (int i=0; i<length; i++)
              Container(
                width: 64,
                child: Center(child: Text(widget.truthTable[i].presentState))
              )
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    _analyzedStates.clear();
    _analyzePreviousStates = false;
    Future.delayed(Duration(seconds: 1), () async{
      setState(() {
        _analyzePreviousStates = true;
      });
      for (int i=0; i<20; i++){
        if (i == 19)
          _showSets = true;
        await Future.delayed(Duration(milliseconds: 50));
        setState(() {

        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenSize.width*0.1,),
              IconButton(
                splashRadius: 1.0,
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                      SharedAxisRoute(builder: (context) => TruthTableInfoPage())
                  );
                },
                icon: Icon(Icons.close, size: 30, color: Colors.white54,),
              ),
            ],
          ),
          Container(
            child: generateImplication(),
          ),
          SizedBox(height: 30,),
          _showSets ? Text(getImpliedSets().join(", ").replaceAll("[", "{").replaceAll("]", "}"), style: Theme.of(context).textTheme.headline4,) : Container(),
        ],
      ),
    );
  }
}
