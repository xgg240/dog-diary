// ============================================================
//  养狗日记 - 单元测试 (path 验证)
// ============================================================

import 'package:flutter_test/flutter_test.dart';

bool isValidDbPath(String path) {
  if (path.trim().isEmpty) return false;
  return path.toLowerCase().endsWith('.db');
}

bool isValidXlsxPath(String path) {
  if (path.trim().isEmpty) return false;
  return path.toLowerCase().endsWith('.xlsx');
}

void main() {
  group('DB path validation', () {
    test('valid .db path passes', () {
      expect(isValidDbPath('/Users/test/backup.db'), isTrue);
      expect(isValidDbPath('C:\\Users\\test\\backup.DB'), isTrue);  // 大写
    });

    test('empty path fails', () {
      expect(isValidDbPath(''), isFalse);
      expect(isValidDbPath('   '), isFalse);
    });

    test('wrong extension fails', () {
      expect(isValidDbPath('/test/backup.txt'), isFalse);
      expect(isValidDbPath('/test/backup'), isFalse);
    });
  });

  group('Excel path validation', () {
    test('valid .xlsx path passes', () {
      expect(isValidXlsxPath('/Users/test/export.xlsx'), isTrue);
      expect(isValidXlsxPath('D:\\export.XLSX'), isTrue);
    });

    test('empty path fails', () {
      expect(isValidXlsxPath(''), isFalse);
    });

    test('wrong extension fails', () {
      expect(isValidXlsxPath('/test/export.xls'), isFalse);
      expect(isValidXlsxPath('/test/export'), isFalse);
    });
  });

  group('Date format', () {
    test('DateFormat yyyyMMdd_HHmmss produces 15 chars', () {
      // 验证我们用的时间格式长度
      final now = DateTime(2026, 6, 4, 3, 30, 0);
      final formatted = '${now.year}${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}'
          '${now.second.toString().padLeft(2, '0')}';
      expect(formatted.length, 15);
      expect(formatted, '20260604_033000');
    });
  });
}
