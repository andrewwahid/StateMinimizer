class TTEntry {
  String presentState;
  String nextState;
  String presentOutput;

  TTEntry({this.presentState, this.nextState, this.presentOutput});

  void setNextState(int x, String val){
    var stateItems = nextState.split(",");
    stateItems[x] = val;
    this.nextState = stateItems[0] + "," + stateItems[1];
  }

  String getNextState(int x){
    return nextState.split(",")[x];
  }

  void setPresentOutput(int x, String val){
    var outputItems = presentOutput.split(",");
    outputItems[x] = val;
    this.presentOutput = outputItems[0] + "," + outputItems[1];
  }

  String getPresentOutput(int x){
    return presentOutput.split(",")[x];
  }

}