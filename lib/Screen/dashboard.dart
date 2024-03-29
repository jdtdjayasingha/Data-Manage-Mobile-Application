import 'package:data_manage_mobile_application/Screen/new.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();
  final TextEditingController _locationEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  late CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = FirebaseFirestore.instance.collection('items');
  }

  void _addItem() async {
    await _collectionReference.add(
      {
        'name': _nameEditingController.text,
        'age': _ageEditingController.text,
        'location': _locationEditingController.text,
        'email': _emailEditingController.text,
      },
    );
  }

  void _updateItem(DocumentSnapshot doc) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController namecontroller =
            TextEditingController(text: doc['name']);
        final TextEditingController agecontroller =
            TextEditingController(text: doc['age']);
        final TextEditingController locationcontroller =
            TextEditingController(text: doc['location']);
        final TextEditingController emailcontroller =
            TextEditingController(text: doc['email']);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
            ),
            child: AlertDialog(
              title: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Update ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Student",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: namecontroller,
                  ),
                  TextField(
                    controller: agecontroller,
                  ),
                  TextField(
                    controller: locationcontroller,
                  ),
                  TextField(
                    controller: emailcontroller,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await doc.reference.delete();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await doc.reference.update({
                      'name': namecontroller.text,
                      'age': agecontroller.text,
                      'location': locationcontroller.text,
                      'email': emailcontroller.text,
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const New()),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Student ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Database",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _collectionReference.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DocumentSnapshot doc = snapshot.data!.docs[index];
                      return ListTile(
                        title: Column(
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ' + doc['name'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Age: ' + doc['age'],
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Location: ' + doc['location'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Email: ' + doc['email'],
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _updateItem(doc),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
