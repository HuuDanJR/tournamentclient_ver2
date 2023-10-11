import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:dio/dio.dart';


class ServiceAPIs {
  Dio dio = Dio();


Future fetchInit() async {

}

 Future<List<List<double>>> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:8090/api/finddata/'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    
    List<List<double>> result = [];

    for (var subArray in data) {
      List<double> creditValues = (subArray as List<dynamic>).map<double>((value) => value.toDouble()).toList();
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
    print('response data from request: ${response.data}');
    // final List<List<double>> list = response.data;
    // print('reponse: $list');
    return response.data;
  }
}
