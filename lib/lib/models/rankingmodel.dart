import 'dart:convert';

RankingModel rankingModelFromJson(String str) =>
    RankingModel.fromJson(json.decode(str));

String rankingModelToJson(RankingModel data) => json.encode(data.toJson());

class RankingModel {
  final bool? status;
  final String? message;
  final int? totalResult;
  final List<Datum>? data;

  RankingModel({
    required this.status,
    required this.message,
    required this.totalResult,
    required this.data,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      status: json["status"],
      message: json["message"],
      totalResult: json["totalResult"],
      data: (json["data"] as List)
          .map((x) => Datum.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalResult": totalResult,
        "data": data?.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  final String? id;
  final int? datumId;
  final String? customerName;
  final String? customerNumber;
  final double? point;
  final DateTime? createdAt;
  final int? v;

  Datum({
    required this.id,
    required this.datumId,
    required this.customerName,
    required this.customerNumber,
    required this.point,
    required this.createdAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"],
      datumId: json["id"],
      customerName: json["customer_name"],
      customerNumber: json["customer_number"],
      point: json["point"]?.toDouble(),
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": datumId,
        "customer_name": customerName,
        "customer_number": customerNumber,
        "point": point,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}