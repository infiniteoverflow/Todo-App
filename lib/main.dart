import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:todo_app/todoModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path.getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  await Hive.openBox('todo');
  Hive.registerAdapter(TodoModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WatchBoxBuilder(
        box: Hive.box('todo'),
        builder: (context, box) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todo = box.getAt(index) as TodoModel;
              return ListTile(
                title: Text(
                  todo.topic,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                    todo.description
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Hive.box('todo').putAt(index, TodoModel(topic: "Write Assignment",description: "Done"));
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Hive.box('todo').deleteAt(index);
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: () {
          Hive.box('todo').add(TodoModel(
              topic: 'Write Assignment',
              description: 'You have to finish your assignments'));
        },
      ),
    );
  }
}
