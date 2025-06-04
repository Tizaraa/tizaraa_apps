import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Hiev_DB extends StatefulWidget {
  const Hiev_DB({super.key});

  @override
  State<Hiev_DB> createState() => _Hiev_DBState();
}

class _Hiev_DBState extends State<Hiev_DB> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final Box box = Hive.box("database");

  Future<void> saveData() async {
    final String name = nameController.text.trim();
    final String designation = designationController.text.trim();

    if (name.isEmpty || designation.isEmpty) return;

    Map<String, String> newData = {
      'name': name,
      'designation': designation,
    };

    await box.add(newData); // Add to Hive database

    nameController.clear();
    designationController.clear();
    setState(() {}); // Refresh the UI
  }

  void deleteData(int index) {
    box.deleteAt(index);
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Data")),
      body: Column(
        children: [
          // Input Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: designationController,
                  decoration: InputDecoration(
                    labelText: "Designation",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveData,
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),

          // List View
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return Center(child: Text("No data available"));
                } else {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final data = box.getAt(index) as Map;
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: Text(data['name'] ?? ''),
                          subtitle: Text(data['designation'] ?? ''),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteData(index),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}