# flutter_di_app

## DI(Dependency Injection) ???
依存性の注入とは何か？
本を読んだり、コードを書いたり、UdemyでNest.jsのチュートリアルをやっていたら、なんとなくわかってきました。

いや理解しているのか疑問ですが💦

依存関係を持つクラスを外部で、インスタンス化して、ロジックを実行するクラスのコンストラクタ引数に渡すだけです。

「コンストラク引数に渡す」これだけ😅
意外と単純だ。`Riverpod`だったら多分勝手にいい感じでやってくれている？？？

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
- `domain`は、人によって使い方が違う気がするのですが、モデルを置いてるだけの人もいれば、ロジックを書いたクラスを置いてるようです。昔携わったらプロジェクトだと、API, freezedのコードを置いてましたね....
  - `entity`はタダの入れ物だそうです。モデルクラスですね。データを保持します。これがあるから、ダミーでもAPIでもデータを表示できたり、他のページに渡せる。
  - `repository`は、インターフェースなのか？、抽象クラスを置くことが多い。今回は名前変ですが、interfaceとつけました。
  - `service`は、ロジックが書いてあるところです。今回だと、インターフェースを実装しています。

- `views`は、UIのコードを配置してます。screenでもいいかも。画面ですね。

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

## まとめ
今回は、依存性の注入について学んでみました。これであっているのかわかりませんが、依存性の注入とか、DIとか聞くと、難しそうだな〜と避けてしまいがちでした💦
最近読んだ本や参考にした他の技術の解説が正しければ、コンストラクタ引数に、外部でインスタンス化したクラスを渡しているだけでした。

ちょっと、DI理解できたかも知れません。プログミングの世界は奥が深い📚