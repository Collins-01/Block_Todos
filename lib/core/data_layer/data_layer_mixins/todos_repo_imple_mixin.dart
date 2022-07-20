import 'package:flutter/services.dart';

mixin TodosRepositoryImpleMixin {
  Future<void> getAbi() async {
    String abiFileString =
        await rootBundle.loadString('src/abis/BlockTodos.json');
    print(abiFileString);
  }
}
