import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tournament_client/lib/models/rankingmodel.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/service/format.date.factory.dart';
import 'package:tournament_client/utils/mystring.dart';

class ServiceAPIs {
  Dio dio = Dio();

  Future fetchInit() async {}

//List report
  Future<ListStationModel?> listStationData() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        MyString.list_station,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return ListStationModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<List<List<double>>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8090/api/finddata/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<List<double>> result = [];

      for (var subArray in data) {
        List<double> creditValues = (subArray as List<dynamic>)
            .map<double>((value) => value.toDouble())
            .toList();
        result.add(creditValues);
      }

      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<List<double>>> getData() async {
    final response = await dio.get(
      'http://localhost:8090/api/finddata/',
      options: Options(
        contentType: Headers.jsonContentType,
        // receiveTimeout: const Duration(seconds: 10000),
        // sendTimeout: const Duration(seconds: 10000),
        // followRedirects: false,
        // validateStatus: (status) {
        //   return true;
        // },
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // print('response data from request: ${response.data}');
    // final List<List<double>> list = response.data;
    // print('reponse: $list');
    return response.data;
  }

//List report
  Future<RankingModel?> listRanking() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        MyString.list_ranking,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      // print(response.data);
      return RankingModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

//create new ranking
  //List report
  Future<dynamic> createRanking({customer_name, customer_number, point}) async {
    final Dio dio = Dio();
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
      "point": point
    };
    try {
      final response = await dio.post(
        MyString.create_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //update display station data
  Future<dynamic> updateDisplayStatus({ip, display}) async {
    Map<String, dynamic> body = {
      "ip": ip,
      "display": display,
    };
    try {
      final response = await dio.post(
        MyString.update_station_status,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> updateRanking({customer_name, customer_number, point}) async {
    final Dio dio = Dio();
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
      "point": point
    };
    try {
      final response = await dio.put(
        MyString.update_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

//delete report by customer_name & customer_number
  Future<dynamic> deleteRanking({customer_name, customer_number}) async {
    final Dio dio = Dio();
    Map<String, dynamic> body = {
      "customer_name": customer_name,
      "customer_number": customer_number,
    };
    try {
      final response = await dio.delete(
        MyString.delete_ranking,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> createStation({machine, member}) async {
    final format_date = StringFormat();
    final Dio dio = Dio();
    Map<String, dynamic> body = {
      "machine": machine,
      "member": member,
      "bet": 0,
      "credit": 0,
      "connect": 0,
      "status": 0,
      "aft": 0,
      "lastupdate": DateTime.now().toString(),
      "display": 0
    };
    try {
      final response = await dio.post(
        MyString.create_station,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> deleteStation({machine, member}) async {
    final Dio dio = Dio();
    Map<String, dynamic> body = {
      "machine": machine,
      "member": member,
    };
    try {
      final response = await dio.delete(
        MyString.delete_station,
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }

  Future<dynamic> deleteRankingAllAndAddDefault() async {
    final Dio dio = Dio();

    try {
      final response = await dio.delete(
        MyString.delete_ranking_all_and_add,
        options: Options(
          contentType: Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 10000),
          sendTimeout: const Duration(seconds: 10000),
          followRedirects: false,
          validateStatus: (status) {
            return true;
          },
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      print(response.data);
      return (response.data);
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
