import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class New extends StatelessWidget {
  const New({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  late CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = FirebaseFirestore.instance.collection('items');
  }

  void _addItem() async {
    await _collectionReference.add({'name': _textEditingController.text});
    _textEditingController.clear();
  }

  void _updateItem(DocumentSnapshot doc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller =
            TextEditingController(text: doc['name']);
        return AlertDialog(
          title: Text('Update Item'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await doc.reference.update({'name': controller.text});
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                await doc.reference.delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
