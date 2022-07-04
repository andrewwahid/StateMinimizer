import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:implication_solver/Objects/TTEntry.dart';
import 'package:implication_solver/Pages/Analyzer/ImplicationTablePage.dart';
import 'package:implication_solver/Pages/TruthTable/StateChangerWidget.dart';
import 'package:implication_solver/Pages/TruthTable/TruthTableInfoPage.dart';
import 'package:implication_solver/Utilities/Routing.dart';
import 'package:implication_solver/Utilities/Utils.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TruthTablePage extends StatefulWidget {
  final int totalVariables;
  final String jsonTable;

  TruthTablePage({this.totalVariables, this.jsonTable});

  @override
  _TruthTablePageState createState() => _TruthTablePageState();
}

class _TruthTablePageState extends State<TruthTablePage> {
  _StackedHeaderDataGridSource _stackedHeaderDataGridSource;
  List<TTEntry> _ttEntriesList = new List();
  int _stateLimit;

  List ttList = [
    ["A", "D,C", "0,0"],
    ["B", "F,H", "0,0"],
    ["C", "E,D", "1,0"],
    ["D", "A,E", "0,0"],
    ["E", "C,A", "1,0"],
    ["F", "F,B", "1,0"],
    ["G", "B,H", "0,0"],
    ["H", "C,G", "1,0"],
  ];



  List<GridColumn> _getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'presentState',
        width: 140,
        label: Center(child: Text("Present State")),
      ),
      GridColumn(
        columnName: 'nextX0',
        //cellStyle: DataGridCellStyle(backgroundColor: Color(0xFF2E2946)),
        //headerStyle: DataGridHeaderCellStyle(backgroundColor: Color(0xFF2E2946)),
        width: 140,
        label: Center(child: Text("X=0")),
        //headerText: 'X=0'
      ),
      GridColumn(
        columnName: 'nextX1',
        //cellStyle: DataGridCellStyle(backgroundColor: Color(0xFF2E2946)),
        //headerStyle: DataGridHeaderCellStyle(backgroundColor: Color(0xFF2E2946)),
        width: 140,
        label: Center(child: Text("X=1")),
        //headerText: 'X=1'
      ),
      GridColumn(
        columnName: 'presentX0',
        //cellStyle: DataGridCellStyle(backgroundColor: Color(0XFF462933)),
        //headerStyle: DataGridHeaderCellStyle(backgroundColor: Color(0XFF462933)),
        width: 150,
        label: Center(child: Text("X=0")),
        //headerText: 'X=0'
      ),
      GridColumn(
        columnName: 'presentX1',
        //cellStyle: DataGridCellStyle(backgroundColor: Color(0xFF462933)),
        //headerStyle: DataGridHeaderCellStyle(backgroundColor: Color(0XFF462933)),
        width: 150,
        label: Center(child: Text("X=1")),
        //headerText: 'X=1'
      ),
    ];
    return columns;
  }

  Color _getHeaderCellBackgroundColor() {
        return const Color(0xFF3A3A3A);
  }

  Widget _getWidgetForStackedHeaderCell(String title) {
    return Container(
        padding: EdgeInsets.all(16.0),
        color: _getHeaderCellBackgroundColor(),
        alignment: Alignment.center,
        child: Text(title));
  }

  List<StackedHeaderRow> _getStackedHeaderRows() {
    List<StackedHeaderRow> _stackedHeaderRows;
    _stackedHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(
          columnNames: [
            'nextX0',
            'nextX1',
          ],
          child: _getWidgetForStackedHeaderCell('Next State')
        ),
        StackedHeaderCell(
          columnNames: [
            'presentX0',
            'presentX1',
          ],
          child: _getWidgetForStackedHeaderCell('Present Output')
        ),
      ])
    ];
    return _stackedHeaderRows;
  }

  @override
  void initState() {
    //_ttEntriesList = generateTruthTable();
    if (widget.totalVariables != null) {
      for (int i = 0; i < widget.totalVariables; i++) {
        _ttEntriesList.add(TTEntry(
            presentState: String.fromCharCode(65 + i),
            nextState: "A,A",
            presentOutput: "0,0"
        ));
      }
    }else{
      _ttEntriesList = Utils.generateTruthTable(widget.jsonTable ?? jsonEncode(ttList));
    }
    _stateLimit = _ttEntriesList.length - 1;
    _stackedHeaderDataGridSource = _StackedHeaderDataGridSource(ttEntries: _ttEntriesList, stateLimit: _stateLimit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 75,),
          Text("ENTER YOUR STATE TRUTH TABLE", style: Theme.of(context).textTheme.headline3,),
          SizedBox(height: 30,),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenSize.width*0.25,),
                Expanded(
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(headerColor: Colors.grey[900]),
                    child: SfDataGrid(
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      source: _stackedHeaderDataGridSource,
                      columns: _getColumns(),
                      stackedHeaderRows: _getStackedHeaderRows(),
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width*0.25,),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                      SharedAxisRoute(builder: (context) => TruthTableInfoPage())
                  );
                },
                color: Colors.red[900],
                child: Text("Cancel"),
              ),
              SizedBox(width: 10,),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).push(
                      SharedAxisRoute(builder: (context) => ImplicationTablePage(truthTable: _ttEntriesList))
                  );
                },
                child: Text("Analyze"),
              ),
            ],
          ),
          SizedBox(height: 100,),
        ],
      ),
    );
  }
}

class _StackedHeaderDataGridSource extends DataGridSource {
  List<TTEntry> ttEntries;
  int stateLimit;
  _StackedHeaderDataGridSource({this.ttEntries, this.stateLimit}){
    dataGridRows = ttEntries
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'presentState', value: dataGridRow.presentState),
      DataGridCell<String>(columnName: 'nextX0', value: dataGridRow.getNextState(0)),
      DataGridCell<String>(columnName: 'nextX1', value: dataGridRow.getNextState(1)),
      DataGridCell<String>(columnName: 'presentX0', value: dataGridRow.getPresentOutput(0)),
      DataGridCell<String>(columnName: 'presentX1', value: dataGridRow.getPresentOutput(1)),
    ])).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;


  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          switch (dataGridCell.columnName){
            case "presentState":
              return Center(child: Text(ttEntries[rowIndex].presentState));
            case "nextX0":
              return Center(child: StateChangerWidget(
                initialState: ttEntries[rowIndex].getNextState(0),
                basePoint: 65,
                stateLimit: stateLimit,
                onChanged: (val){
                  ttEntries[rowIndex].setNextState(0, val);
                },
              ));
              break;
            case "nextX1":
              return Center(child: StateChangerWidget(
                initialState: ttEntries[rowIndex].getNextState(1),
                basePoint: 65,
                stateLimit: stateLimit,
                onChanged: (val){
                  ttEntries[rowIndex].setNextState(1, val);
                },
              ));
              break;
            case "presentX0":
              return Center(child: StateChangerWidget(
                initialState: ttEntries[rowIndex].getPresentOutput(0),
                basePoint: 48,
                stateLimit: 1,
                onChanged: (val){
                  ttEntries[rowIndex].setPresentOutput(0, val);
                },
              ));
              break;
            case "presentX1":
              return Center(child: StateChangerWidget(
                initialState: ttEntries[rowIndex].getPresentOutput(1),
                basePoint: 48,
                stateLimit: 1,
                onChanged: (val){
                  ttEntries[rowIndex].setPresentOutput(1, val);
                },
              ));
              break;
            default:
              return Text("ERROR HERE");
          }
        }).toList());
  }

}
