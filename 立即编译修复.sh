#!/bin/bash

echo "🚨 立即修复编译错误"
echo "=================="

echo "🔧 修复方案：使用简化颜色选择器"

# 备份原文件
cp lib/widgets/cell_widget.dart lib/widgets/cell_widget.dart.backup

# 创建简化的颜色选择器版本
cat > lib/widgets/cell_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spreadsheet.dart';

class CellWidget extends StatelessWidget {
  final int row;
  final int col;
  
  const CellWidget({
    super.key,
    required this.row,
    required this.col,
  });
  
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SpreadsheetModel>(context);
    final cell = model.getCell(row, col);
    final hasComment = model.hasComment(row, col);
    
    return GestureDetector(
      onTap: () => _showEditDialog(context, row, col),
      onLongPress: () => _showSimpleColorPicker(context, row, col),
      child: Container(
        decoration: BoxDecoration(
          color: cell.backgroundColor,
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Text(
              cell.text,
              style: TextStyle(
                color: _getContrastColor(cell.backgroundColor),
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (hasComment)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.comment,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
  
  void _showEditDialog(BuildContext context, int row, int col) {
    final model = Provider.of<SpreadsheetModel>(context, listen: false);
    final cell = model.getCell(row, col);
    final textController = TextEditingController(text: cell.text);
    final commentController = TextEditingController(text: cell.comment ?? '');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑单元格'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: '文本内容',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: '备注 (可选)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                model.setCellText(row, col, textController.text);
                model.setCellComment(row, col, commentController.text);
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
  
  void _showSimpleColorPicker(BuildContext context, int row, int col) {
    final model = Provider.of<SpreadsheetModel>(context, listen: false);
    final cell = model.getCell(row, col);
    
    final colors = [
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.grey,
    ];
    
    final colorNames = [
      '白色',
      '红色',
      '绿色',
      '蓝色',
      '黄色',
      '橙色',
      '紫色',
      '灰色',
    ];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择单元格颜色'),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    model.setCellColor(row, col, colors[index]);
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors[index],
                          border: Border.all(
                            color: colors[index] == cell.backgroundColor 
                              ? Colors.black 
                              : Colors.grey,
                            width: colors[index] == cell.backgroundColor ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        colorNames[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}
EOF

echo "✅ 已创建简化颜色选择器"

# 检查修复
echo ""
echo "🔍 检查修复结果："
echo "1. 检查Color导入..."
if grep -q "import.*material.dart" lib/models/spreadsheet.dart; then
    echo "   ✅ spreadsheet.dart有Material导入"
else
    echo "   ❌ spreadsheet.dart缺少Material导入"
fi

echo "2. 检查ColorPicker使用..."
if grep -q "ColorPicker" lib/widgets/cell_widget.dart; then
    echo "   ❌ 仍有ColorPicker引用"
else
    echo "   ✅ 已移除ColorPicker"
fi

echo ""
echo "📝 执行以下命令："
echo "1. git add ."
echo "2. git commit -m '修复编译错误：使用简化颜色选择器'"
echo "3. git push"
echo ""
echo "🚀 修复说明："
echo "- 移除了对flutter_colorpicker包的依赖"
echo "- 使用内置的Grid颜色选择器"
echo "- 提供8种基本颜色选择"
echo "- 确保编译能通过"