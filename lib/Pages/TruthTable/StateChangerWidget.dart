import 'package:flutter/material.dart';

class StateChangerWidget extends StatefulWidget {
  final String initialState;
  final int stateLimit;
  final int basePoint;
  final Function(String) onChanged;

  StateChangerWidget({@required this.initialState, @required this.stateLimit, @required this.basePoint, this.onChanged});

  @override
  _StateChangerWidgetState createState() => _StateChangerWidgetState();
}

class _StateChangerWidgetState extends State<StateChangerWidget> {
  int _currentState;

  @override
  void initState() {
    _currentState = widget.initialState.codeUnitAt(0) ?? widget.basePoint;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              _currentState = _currentState == widget.basePoint ? widget.basePoint + widget.stateLimit : _currentState - 1;
              widget.onChanged(String.fromCharCode(_currentState));
              setState(() {
              });
            },
            icon: Icon(Icons.arrow_drop_down_sharp),
          ),
          SizedBox(width: 5,),
          Text(String.fromCharCode(_currentState)),
          SizedBox(width: 5,),
          IconButton(
            onPressed: (){
              _currentState = _currentState == widget.basePoint+widget.stateLimit ? widget.basePoint : _currentState + 1;
              widget.onChanged(String.fromCharCode(_currentState));
              setState(() {
              });
            },
            icon: Icon(Icons.arrow_drop_up_sharp),
          ),
        ],
      ),
    );
  }
}
