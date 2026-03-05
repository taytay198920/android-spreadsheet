import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spreadsheet.dart';
import '../widgets/cell_widget.dart';

class SpreadsheetScreen extends StatelessWidget {
  const SpreadsheetScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SpreadsheetModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('简易表格编辑器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMenu(context),
            tooltip: '添加行/列',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteMenu(context),
            tooltip: '删除行/列',
          ),
        ],
      ),
      body: Column(
        children: [
          // 列标题
          Container(
            height: 40,
            color: Colors.grey[200],
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Center(
                    child: Text(
                      '行/列',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.columnCount,
                    itemBuilder: (context, col) {
                      return Container(
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Text(
                            '列 ${col + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // 表格内容
          Expanded(
            child: ListView.builder(
              itemCount: model.rowCount,
              itemBuilder: (context, row) {
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      // 行标题
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          color: Colors.grey[100],
                        ),
                        child: Center(
                          child: Text(
                            '行 ${row + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      
                      // 单元格内容
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: model.columnCount,
                          itemBuilder: (context, col) {
                            return SizedBox(
                              width: 100,
                              child: CellWidget(row: row, col: col),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('添加新行'),
                onTap: () {
                  Provider.of<SpreadsheetModel>(context, listen: false).addRow();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: const Text('添加新列'),
                onTap: () {
                  Provider.of<SpreadsheetModel>(context, listen: false).addColumn();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('取消'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showDeleteMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('删除最后一行'),
                onTap: () {
                  final model = Provider.of<SpreadsheetModel>(context, listen: false);
                  if (model.rowCount > 1) {
                    model.deleteRow(model.rowCount - 1);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('删除最后一列'),
                onTap: () {
                  final model = Provider.of<SpreadsheetModel>(context, listen: false);
                  if (model.columnCount > 1) {
                    model.deleteColumn(model.columnCount - 1);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('取消'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}