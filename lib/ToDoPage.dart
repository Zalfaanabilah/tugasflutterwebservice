import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToDo {
  int userId;
  int id;
  String title;
  bool completed;

  ToDo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  Future<List<ToDo>> fetchToDo() async {
    final response = await http.get(
      Uri.parse(
          'https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ToDo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load to-dos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      body: FutureBuilder<List<ToDo>>(
        future: fetchToDo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No to-do items found.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final todo = snapshot.data![index];
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(
                            todo.completed ? 'Completed' : 'Not completed'),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                  child: Text('Back'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
