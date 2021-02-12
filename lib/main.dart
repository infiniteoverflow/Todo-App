import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:todo_app/todoModel.dart';

import 'todoModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path.getApplicationDocumentsDirectory();
  print(directory.path);
  Hive.init(directory.path);

  Hive.registerAdapter<TodoModel>(TodoModelAdapter());
  await Hive.openBox('todo');
  await Hive.openBox('darkMode');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box('darkMode'),
        builder: (context,box) {
          bool dark = box.get(0,defaultValue: false);
          print("Dark : $dark");
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            themeMode: dark? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            home: MyHomePage(),
          );
        },
    );
  }
}
class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        actions: [
          Switch(
            onChanged: (value) {
              Hive.box('darkMode').put(0, value);
              print(Hive.box('darkMode').get(0,defaultValue: false));
            },
            value: Hive.box('darkMode').get(0,defaultValue: false),
          )
        ],
      ),
      body: WatchBoxBuilder(
        box: Hive.box('todo'),
        builder: (context, box) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todo = box.getAt(index) as TodoModel;
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.17,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Done',
                    color: Colors.green,
                    icon: Icons.done,
                    onTap: (){
                      Hive.box('todo').putAt(index, TodoModel(topic: "Write Assignment",description: "Done"));
                    },
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      Hive.box('todo').deleteAt(index);
                    },
                  ),
                ],
                child: ListTile(
                  title: Text(
                    todo.topic,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text(
                      todo.description
                  ),
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
