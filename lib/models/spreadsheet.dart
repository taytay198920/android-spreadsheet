import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CellData {
  String text;
  Color backgroundColor;
  String? comment;
  
  CellData({
    this.text = '',
    this.backgroundColor = Colors.white,
    this.comment,
  });
  
  CellData copyWith({
    String? text,
    Color? backgroundColor,
    String? comment,
  }) {
    return CellData(
      text: text ?? this.text,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      comment: comment ?? this.comment,
    );
  }
}

class SpreadsheetModel extends ChangeNotifier {
  List<List<CellData>> _cells = [];
  int _rows = 10;
  int _cols = 5;
  
  SpreadsheetModel() {
    _initializeCells();
  }
  
  void _initializeCells() {
    _cells = List.generate(_rows, (row) {
      return List.generate(_cols, (col) {
        return CellData(
          text: 'R${row + 1}C${col + 1}',
          backgroundColor: Colors.white,
        );
      });
    });
  }
  
  int get rowCount => _rows;
  int get columnCount => _cols;
  
  CellData getCell(int row, int col) {
    return _cells[row][col];
  }
  
  void updateCell(int row, int col, CellData newData) {
    _cells[row][col] = newData;
    notifyListeners();
  }
  
  void addRow() {
    _rows++;
    _cells.add(List.generate(_cols, (col) => CellData()));
    notifyListeners();
  }
  
  void addColumn() {
    _cols++;
    for (var row in _cells) {
      row.add(CellData());
    }
    notifyListeners();
  }
  
  void deleteRow(int rowIndex) {
    if (_rows > 1) {
      _rows--;
      _cells.removeAt(rowIndex);
      notifyListeners();
    }
  }
  
  void deleteColumn(int colIndex) {
    if (_cols > 1) {
      _cols--;
      for (var row in _cells) {
        row.removeAt(colIndex);
      }
      notifyListeners();
    }
  }
  
  void setCellText(int row, int col, String text) {
    _cells[row][col] = _cells[row][col].copyWith(text: text);
    notifyListeners();
  }
  
  void setCellColor(int row, int col, Color color) {
    _cells[row][col] = _cells[row][col].copyWith(backgroundColor: color);
    notifyListeners();
  }
  
  void setCellComment(int row, int col, String comment) {
    _cells[row][col] = _cells[row][col].copyWith(comment: comment);
    notifyListeners();
  }
  
  bool hasComment(int row, int col) {
    return _cells[row][col].comment != null && _cells[row][col].comment!.isNotEmpty;
  }
}