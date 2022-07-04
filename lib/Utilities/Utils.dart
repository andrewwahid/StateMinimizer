import 'dart:convert';

import 'package:implication_solver/Objects/TTEntry.dart';

class Utils{

  static String reverse(String input){
    return String.fromCharCodes(input.runes.toList().reversed);
  }

  static List<TTEntry> generateTruthTable(String jsonTable){
    List<TTEntry> returnList = new List();
    for (var entry in json.decode(jsonTable)){
      try {
        TTEntry ttEntry = new TTEntry(
          presentState: entry[0],
          nextState: entry[1],
          presentOutput: entry[2],
        );
        returnList.add(ttEntry);
      } catch (e) {
        return null;
      }
    }
    return returnList;
  }

  static bool isNumericInt(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  static bool isStringEqualChars(String input){
    if (input.length < 1)
      return false;
    String comparingChar = input[0];
    for (int i=0; i<input.length; i++){
      if (input[i] != comparingChar)
        return false;
    }
    return true;
  }

}