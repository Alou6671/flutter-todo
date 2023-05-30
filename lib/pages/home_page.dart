import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;

  final List<String> todos = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> todos = ['Buy milk', 'Buy eggs', 'Buy bread'];
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTodos().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  void addTodo() {
    if (_todoController.text.isNotEmpty) {
      setState(() {
        todos.add(_todoController.text);
        _todoController.clear();
      });
      saveTodos(todos);
    }
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveTodos(todos);
  }

  void editTodo(int index) {
    setState(() {
      todos[index] = _todoController.text;
      _todoController.clear();
    });
    saveTodos(todos);
  }

  Future<void> saveTodos(List<String> todos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todos', todos);
  }

  Future<List<String>> getTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('todos') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Todo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView(
                children: [
                  TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add a todo',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addTodo,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(todos[index]),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removeTodo(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editTodo(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
