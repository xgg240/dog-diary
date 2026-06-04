// ============================================================
//  养狗百科 - 静态数据加载器
// ============================================================

import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
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
  static Map<String, dynamic>? _emergency;
  static Map<String, dynamic>? _seniorCare;
  static Map<String, dynamic>? _grooming;
  static Map<String, dynamic>? _homeSafety;
  static Map<String, dynamic>? _toysTreats;
  static Map<String, dynamic>? _travel;

  static Future<Map<String, dynamic>> _load(String path) async {
    final s = await rootBundle.loadString(path);
    try {
      final decoded = json.decode(s);
      // 如果 JSON 顶层是 list (如 breeds.json), 包成 {data: list}
      if (decoded is List) {
        return {'data': decoded};
      }
      return decoded as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ DataLoader JSON parse FAILED: $path → $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> breeds() async {
    _breeds ??= await _load('assets/data/breeds.json');
    // _load() 会把 list JSON 包成 {data: list}
    return _breeds!['data'] as List<dynamic>;
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

  static Future<List<dynamic>> emergencies() async {
    _emergency ??= await _load('assets/data/emergency.json');
    return _emergency!['emergencies'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> seniorCare() async {
    _seniorCare ??= await _load('assets/data/senior_care.json');
    return _seniorCare!;
  }

  static Future<Map<String, dynamic>> grooming() async {
    _grooming ??= await _load('assets/data/grooming.json');
    return _grooming!;
  }

  static Future<Map<String, dynamic>> homeSafety() async {
    _homeSafety ??= await _load('assets/data/home_safety.json');
    return _homeSafety!;
  }

  static Future<Map<String, dynamic>> toysTreats() async {
    _toysTreats ??= await _load('assets/data/toys_treats.json');
    return _toysTreats!;
  }

  static Future<Map<String, dynamic>> travel() async {
    _travel ??= await _load('assets/data/travel.json');
    return _travel!;
  }
}
