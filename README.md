## DI(Dependency Injection) ???
依存性の注入とは何か？
本を読んだり、コードを書いたり、UdemyでNest.jsのチュートリアルをやっていたら、なんとなくわかってきました。

いや理解しているのか疑問ですが💦

依存関係を持つクラスを外部で、インスタンス化して、ロジックを実行するクラスのコンストラクタ引数に渡すだけです。

「コンストラク引数に渡す」これだけ😅
意外と単純だ。`Riverpod`だったら多分勝手にいい感じでやってくれている？？？

[こちらが完成品です](https://github.com/sakurakotubaki/flutter_di_app)

### こんな感じでサンプル作ってみた☀️
一つのクラスは、一つの責務を持たせるという。二つ以上持っていてはいけないのか？？？

今回は、抽象クラスを定義して、実装して、そのまま使わずに、コントローラークラスのコンストラクタ引数に渡して、追加・表示・削除を実現しています。

なんか無駄にコード多くないか？？？

これにも意味があるそうです。メリットは、本番用とテスト用のモック注入用に、ロジックを分けるとか？

フォルダ構成:
```
lib
├── common
│   └── color.dart
├── controller
│   └── todo_controller.dart
├── domain
│   ├── entity
│   │   └── todo_state.dart
│   ├── repository
│   │   └── todo_interface.dart
│   └── service
│       └── todo_service.dart
├── main.dart
└── views
    └── todo_view.dart
```

- `common` はアプリ全体で使うコード。今回は、色を指定するだけの`static`なクラスですが。
- `controller`は、ロジックを持たず、ロジックを持つサービスクラスを呼び出します。`Riverpod`を使っていればこれはいらないかな。
- `domain`は、人によって使い方が違う気がするのですが、モデルを置いてるだけの人もいれば、ロジックを書いたクラスを置いてるようです。昔携わったプロジェクトだと、API, freezedのコードを置いてましたね....
  - `entity`はタダの入れ物だそうです。モデルクラスですね。データを保持します。これがあるから、ダミーでもAPIでもデータを表示できたり、他のページに渡せる。
  - `repository`は、インターフェースなのか？、抽象クラスを置くことが多い。今回は名前変ですが、interfaceとつけました。
  - `service`は、ロジックが書いてあるところです。今回だと、インターフェースを実装しています。

- `views`は、UIのコードを配置してます。screenでもいいかも。画面ですね。

## ソースコード
### common
アプリのテーマカラーを変えるだけですが、`common`のコード。
```dart
import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color red = Color(0xFFE57373);
}
```

### domain
値オブジェクトを保持するモデルクラス
```dart
class TodoState {
  int? id;
  String? body;

  TodoState({this.id, this.body});

  // fromJSON
  factory TodoState.fromJson(Map<String, dynamic> json) {
    return TodoState(
      id: json['id'],
      body: json['body'],
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
    };
  }
}
```

### interfaceとして使う抽象クラス
機能は実装してない。
```dart
import 'package:flutter_di_app/domain/entity/todo_state.dart';

// 実装がされていないinterface
abstract interface class TodoInterface {
  void addTodo(TodoState todo);
  List<TodoState> getTodo();
  void deleteTodo(int id);
}
```

### 抽象クラス実装したクラス
ロジックを持っているクラスは、ビジネスクラス、ビジネス層？？？なるところに置くので、この位置に配置しました。
```dart
import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/repository/todo_interface.dart';

class TodoService implements TodoInterface {

  List<TodoState> _todoList = [];

  @override
  void addTodo(TodoState todo) {
    _todoList.add(todo);
  }

  @override
  List<TodoState> getTodo() {
    return List.from(_todoList);
  }

  @override
  void deleteTodo(int id) {
    _todoList.removeWhere((element) => element.id == id);
  }
}
```

### Controller
ロジックは書かずに、ロジックを持っているクラスを外部で、インスタンス化して、コンストラクタ引数で渡します。テストを書くときに、モック用のクラスを渡す、本番用は、DBを操作するクラスを渡すのを分けて使えるようになるというメリットがあります。
`Riverpod`だったら、`Notifier`がやってくれる感じですかね。あれが、コントローラーの役割を持っているらしい。

```dart
import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/service/todo_service.dart';

class TodoController {
  final TodoService _todoService;

  TodoController(this._todoService);

  void addTodo(TodoState todo) {
    _todoService.addTodo(todo);
  }

  List<TodoState> getTodo() {
    return _todoService.getTodo();
  }

  void deleteTodo(int id) {
    _todoService.deleteTodo(id);
  }
}
```

### Views
UIを配置するところですね。画面に関係したコードがあります。
```dart
import 'package:flutter/material.dart';
import 'package:flutter_di_app/common/color.dart';
import 'package:flutter_di_app/controller/todo_controller.dart';

import '../domain/entity/todo_state.dart';
import '../domain/service/todo_service.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final bodyController = TextEditingController();
  late TodoController todoController;

  @override
  void initState() {
    super.initState();
    final todoService = TodoService();
    todoController = TodoController(todoService);
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                todoController.addTodo(
                TodoState(
                  id: DateTime.now().millisecondsSinceEpoch,
                  body: bodyController.text,
                ),
              );
              bodyController.clear();
              });
            },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoController.getTodo().length,
              itemBuilder: (context, index) {
                final todo = todoController.getTodo()[index];
                return ListTile(
                  title: Text(todo.body ?? 'Not body'),
                  subtitle: Text('${todo.id ?? 'Not id'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      todoController.deleteTodo(todo.id!);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
```

`main.dart`で、importすれば実行できます。お試しあれ。
```dart
import 'package:flutter/material.dart';
import 'package:flutter_di_app/views/todo_view.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoView(),
    );
  }
}
```

![](https://storage.googleapis.com/zenn-user-upload/6914680edada-20240620.png =250x)
![](https://storage.googleapis.com/zenn-user-upload/f1ecc0a852bb-20240620.png =250x)
![](https://storage.googleapis.com/zenn-user-upload/a1eec64989bd-20240620.png =250x)


テストコードも書いてみました。`mockit`は使ってないですが、ダミーの値を入れて、テストが通るか実験できるコードを書きました。DIした方が、書きやすいらしいから、ついつい試してみました✨

```dart
import 'package:flutter_di_app/controller/todo_controller.dart';
import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/service/todo_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('todo test code', () {
    // DIして、ダミーのデータを入れて、期待しているデータが返ってくるか確認
    final todoService = TodoService();
    final todoController = TodoController(todoService);
    
    // mockのデータを入れて、期待しているデータが返ってくるか確認
    final todo = TodoState(
      id: 1,
      body: 'test',
    );

    // mockのデータを入れて、期待しているデータが返ってくるか確認
    todoController.addTodo(todo);
    // 期待する値が１になるか確認
    expect(todoController.getTodo().length, 1);

    // mockのデータを削除して、期待している値が０になるか確認
    todoController.deleteTodo(1);
    // 期待する値が０になるか確認
    expect(todoController.getTodo().length, 0);
  });
}
```

![](https://storage.googleapis.com/zenn-user-upload/26bae066ab4c-20240620.png)

## まとめ
今回は、依存性の注入について学んでみました。これであっているのかわかりませんが、依存性の注入とか、DIとか聞くと、難しそうだな〜と避けてしまいがちでした💦
最近読んだ本や参考にした他の技術の解説が正しければ、コンストラクタ引数に、外部でインスタンス化したクラスを渡しているだけでした。

ちょっと、DI理解できたかも知れません。プログミングの世界は奥が深い📚

多分学習の参考になった教材。難易度高そうなので、自信がない人はご遠慮ください😇

https://www.udemy.com/course/nestjs-t/?couponCode=JPOF62224

https://book.mynavi.jp/ec/products/detail/id=143373