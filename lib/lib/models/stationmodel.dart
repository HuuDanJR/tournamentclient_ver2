class ListStationModel {
  final List<StationModel> list;

  ListStationModel({required this.list});

  factory ListStationModel.fromJson(List<dynamic> json) {
    List<StationModel> list =
        json.map((data) => StationModel.fromJson(data)).toList();
    return ListStationModel(list: list);
  }
}

class StationModel {
  final int ip;
  final String machine;
  final String member;
  final int bet;
  final int credit;
  final int connect;
  final int status;
  final int aft;
  final int display;
  final DateTime lastupdate;

  StationModel({
    required this.ip,
    required this.machine,
    required this.member,
    required this.bet,
    required this.credit,
    required this.connect,
    required this.display,
    required this.status,
    required this.aft,
    required this.lastupdate,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) => StationModel(
        ip: json["ip"],
        machine: json["machine"],
        member: json["member"],
        bet: json["bet"],
        credit: json["credit"],
        connect: json["connect"],
        status: json["status"],
        aft: json["aft"],
        display: json["display"],
        lastupdate: DateTime.parse(json["lastupdate"]),
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "machine": machine,
        "member": member,
        "bet": bet,
        "credit": credit,
        "connect": connect,
        "status": status,
        "aft": aft,
        "display":display,
        "lastupdate": lastupdate.toIso8601String(),
      };
}
