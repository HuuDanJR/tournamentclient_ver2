import 'package:flutter/foundation.dart';

class MyString {
  static const int DEFAULTNUMBER = 111111;
  static const String ADRESS_LOCAL = "localhost";
  static const String ADRESS_SERVER = "30.0.0.82";
  static const String BASE = 'http://$ADRESS_LOCAL:8090/api/';
  static const String BASEURL = 'http://localhost:8090';
  // static const String BASEURL = 'http://30.0.0.82:8090';

  static const String list_ranking = '${BASE}list_ranking';
  static const String create_ranking = '${BASE}add_ranking';
  static const String update_ranking = '${BASE}update_ranking';
  static const String delete_ranking = '${BASE}delete_ranking';
  static const String delete_ranking_all_and_add =
      '${BASE}delete_ranking_all_create_default';

  static const String list_station = '${BASE}list_station';
  static const String create_station = '${BASE}create_station';
  static const String delete_station = '${BASE}delete_station';
  static const String update_station_status = '${BASE}update_station';

  static const double DEFAULT_HEIGHT_LINE = kIsWeb ? 44 : 44;
  static const double DEFAULT_ROW = 10;
  static const double DEFAULT_SPACING_LING = kIsWeb ? 34 : 22;
  static const double DEFAULT_OFFSETX = 5.0;
  static const double DEFAULT_OFFSETX_TEXT = 3.5;
  static const double DEFAULT_OFFSETX_TITLE = 3.5;

  static const double padding08 = 08.0;
}
