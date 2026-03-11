import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

class AssetLoaderService {
  Future<Map<String, dynamic>> _loadJson() async {
    final String response = await rootBundle.loadString('assets/init_data.json');
    return json.decode(response);
  }

  Future<List<Prefix>> getDefaultPrefixes() async {
    final data = await _loadJson();
    return (data['prefixes'] as List)
        .map((e) => Prefix.fromJson(e))
        .toList();
  }

  Future<List<Preference>> getDefaultPreferences() async {
    final data = await _loadJson();
    return (data['preferences'] as List)
        .map((e) => Preference.fromJson(e))
        .toList();
  }
}