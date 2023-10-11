import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  // final List<Map<String, dynamic>> data;

  // ExamplePage({required this.data});

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<Map<String, dynamic>> _animatedData;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // _animatedData = List<Map<String, dynamic>>.from(widget.data);
  }

  void _moveItemWithAnimation() {
  //   final item = _animatedData.removeAt(3);
  // _animatedData.insert(0, item);

  // int fromIndex = 3;
  // int toIndex = 0;
  // if (fromIndex > toIndex) {
  //   for (int i = fromIndex; i > toIndex; i--) {
  //     _listKey.currentState!.insertItem(i, duration: const Duration(milliseconds: 300));
  //     _listKey.currentState!.removeItem(i + 1, (context, animation) => SizedBox(), duration: Duration.zero);
  //   }
  // } else {
  //   for (int i = fromIndex; i < toIndex; i++) {
  //     _listKey.currentState!.insertItem(i, duration: const Duration(milliseconds: 300));
  //     _listKey.currentState!.removeItem(i, (context, animation) => SizedBox(), duration: Duration.zero);
  //   }
  // }// Move item from index 3 to index 0
   final item0 = _animatedData[0];
  final item3 = _animatedData[3];

  _animatedData[0] = item3;
  _animatedData[3] = item0;

  _listKey.currentState!.removeItem(
    3,
    (context, animation) => const SizedBox(),
    duration: const Duration(milliseconds: 300),
  );
  _listKey.currentState!.removeItem(
    0,
    (context, animation) => const SizedBox(),
    duration: const Duration(milliseconds: 300),
  );
  _listKey.currentState!.insertItem(
    3,
    duration: const Duration(milliseconds: 300),
  );
  _listKey.currentState!.insertItem(
    0,
    duration: const Duration(milliseconds: 300),
  );
  }

  Widget _buildItem(Map<String, dynamic> item, Animation<double> animation,) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.star, color: Colors.redAccent),
          title: Text('Member: ${item['member']}'),
          subtitle: Text('credit: ${item['credit']}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated ListView')),
      body: Column(
        children: [
          TextButton(onPressed: (){
            _moveItemWithAnimation();
          }, child: const Text('move ')),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              physics: const BouncingScrollPhysics(),
              initialItemCount: _animatedData.length,
              itemBuilder: (context, index, animation) {
                final item = _animatedData[index];
                return _buildItem(item, animation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _moveItemWithAnimation();
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}