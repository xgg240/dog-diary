// ============================================================
//  养狗百科 - 静态数据加载器
// ============================================================

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataLoader {
  static Map<String, dynamic>? _breeds;
  static Map<String, dynamic>? _symptoms;
  static Map<String, dynamic>? _diseases;
  static Map<String, dynamic>? _training;
  static Map<String, dynamic>? _humanFoods;
  static Map<String, dynamic>? _vaccine;
  static Map<String, dynamic>? _spay;
  static Map<String, dynamic>? _adoption;
  static Map<String, dynamic>? _insurance;
  static Map<String, dynamic>? _bcs;
  static Map<String, dynamic>? _breeding;

  static Future<Map<String, dynamic>> _load(String path) async {
    final s = await rootBundle.loadString(path);
    return json.decode(s) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> breeds() async {
    _breeds ??= await _load('assets/data/breeds.json');
    return _breeds!['breeds'] as List<dynamic>;
  }

  static Future<List<dynamic>> symptoms() async {
    _symptoms ??= await _load('assets/data/symptoms.json');
    return _symptoms!['symptoms'] as List<dynamic>;
  }

  static Future<List<dynamic>> diseases() async {
    _diseases ??= await _load('assets/data/diseases.json');
    return _diseases!['diseases'] as List<dynamic>;
  }

  static Future<List<dynamic>> tricks() async {
    _training ??= await _load('assets/data/training.json');
    return _training!['tricks'] as List<dynamic>;
  }

  static Future<List<dynamic>> humanFoods() async {
    _humanFoods ??= await _load('assets/data/human_foods.json');
    return _humanFoods!['foods'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> vaccine() async {
    _vaccine ??= await _load('assets/data/vaccine_deworm.json');
    return _vaccine!;
  }

  static Future<Map<String, dynamic>> spay() async {
    _spay ??= await _load('assets/data/spay_neuter.json');
    return _spay!;
  }

  static Future<Map<String, dynamic>> adoption() async {
    _adoption ??= await _load('assets/data/adoption_buying.json');
    return _adoption!;
  }

  static Future<Map<String, dynamic>> insurance() async {
    _insurance ??= await _load('assets/data/insurance_costs.json');
    return _insurance!;
  }

  static Future<List<dynamic>> bcsLevels() async {
    _bcs ??= await _load('assets/data/bcs.json');
    return _bcs!['levels'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> breeding() async {
    _breeding ??= await _load('assets/data/breeding.json');
    return _breeding!;
  }
}
