import 'package:flutter/material.dart';

Widget listview(stationData) {
  return ListView.builder(
    padding: const EdgeInsets.all(32),
    // shrinkWrap: true,
    itemCount: stationData.length,
    itemBuilder: (context, index) {
      // Use the station data to build your UI here
      final data = stationData[index];
      return Card(
        child: ListTile(
          leading: index == 1 || index == 2 || index == 0
              ? const Icon(Icons.star, color: Colors.redAccent)
              : const SizedBox(
                  width: 1,
                  height: 1,
                ),
          title: Text('Member: ${data['member']}'),
          subtitle: Text('credit: ${data['credit']}'),
        ),
      );
    },
  );
}
