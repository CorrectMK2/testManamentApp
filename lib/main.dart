import 'package:flutter/material.dart';
import 'package:testdr/database/tables.dart';
import 'package:testdr/database/app_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const MyHomePage(title: 'スケジュール管理アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  int taskCount = 0;
  final tasks = {};
  String inputtext = "";
  String keyWord = "";
  List<Task> items = [];


  final appdatabase = AppDatabase();


  void _viewAll() async{
    final key = await appdatabase.countTasks();
    setState(() {
      taskCount = key;
    });
  }

  void addTask(String title) async{
    final key = await appdatabase.addTask(title);
    _viewAll();
  }


  void delete() async{
    final key = await appdatabase.deleteAll();
    _viewAll();
  }


  Future<void> getTask() async {
    final row = await appdatabase.getTaskById(taskCount); // Task?
    setState(() {
      keyWord = row?.title ?? '(not found)'; // String にして代入
    });
  }

  Future<void> loadAll() async {
    final list = await appdatabase.getTasks(); // ← DBから全部
    setState(() {
      items = list;              // リスト表示用
      // taskCount は今のままでもOK。件数も合わせたいなら↓も追加
      // taskCount = list.length;
    });
  }

  void setText(String title){
    this.inputtext = title;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '現在のタスクの総数: $taskCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              onChanged: (String title) {
                //_viewAll(title);
                setText(title);
              }
            ),
           ElevatedButton(
                onPressed: loadAll,
              child: const Text('全てのタスクを見る'),
           ),
            ElevatedButton(
              onPressed: () {
                addTask(this.inputtext);
              },
              child: Text(
                '追加',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                delete();
              },
              child: Text(
                '全削除',
              ),
            ),
            const Text('Todoリスト'),
            Expanded(
              child: Container(
                color: Colors.white, // ← 一覧部分の背景を白に
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final t = items[index];
                    return ListTile(
                      leading: const Icon(Icons.circle),
                      title: Text(t.title),
                      // （必要なら各行も白に）tileColor: Colors.white,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
