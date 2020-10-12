import '../models/plan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Config {

  static final Config _config = Config._internal();
  List<Plan> plans;

  factory Config() {
    return _config;
  }

  Config._internal();

  void readProviderInfo(String country, String language) {
    final url = "https://instantink.hpconnected.com/api/landing_page/v1/settings?locale=$country%2F$language&page_name=";
    http.get(url).then((response) {
      final parsed = jsonDecode(response.body);
      plans = parsed["plans"].map<Plan>((json) => Plan.fromJson(json)).toList();
    });
  }

}
