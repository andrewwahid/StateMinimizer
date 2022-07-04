import 'package:flutter/cupertino.dart';

enum ErrorType{
  LOADING,
  TIMEOUT,
  CONNECTION,
}

class Errors{
  static BuildContext context;

  static void showError({ErrorType errorType=ErrorType.CONNECTION, String title="", String message="", bool dismissable=false, BuildContext context}){
    Errors.context = context;
    if (errorType == ErrorType.CONNECTION)
      _showConnectionError(title, message, dismissable);
  }

  static void _showConnectionError(String title, String message, bool dismissable){

  }
}