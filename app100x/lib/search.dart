import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class searchdata extends StatefulWidget {
  const searchdata({Key? key}) : super(key: key);

  @override
  State<searchdata> createState() => _searchdataState();
}

class _searchdataState extends State<searchdata> {
  var value1 = 'Search';

  @override
  Widget build(BuildContext context) {
    print(value1);
    TextEditingController _titleController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              value1 = _titleController.text;
            });
          }),
      appBar: AppBar(
        title: Text('$value1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLength: 70,
          controller: _titleController,
          decoration: InputDecoration(
            labelText: "Search bar",
            labelStyle: TextStyle(color: Colors.green, fontSize: 20),
            hintText: "Search here ...",
            hintStyle: TextStyle(fontSize: 20),
            prefix: Icon(Icons.search),
            suffixIcon: Icon(Icons.check),
            fillColor: Colors.black12,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
