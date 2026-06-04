// 百科页面"真实加载数据"检查 - 找关键中文文字
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// 用 mock rootBundle
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  // 在 main 启动时 mock rootBundle
  TestWidgetsFlutterBinding.ensureInitialized();
  // 不行, rootBundle 是 final, 没法替换
  // 改用 TestDefaultBinaryMessengerBinding
  // 实际方案: 让 .json 走 defaultAssetBundle (test 模式默认没有)
  // 用文件 API 在 setUp 时读 JSON, 然后 widget 里替换 DataLoader
}
