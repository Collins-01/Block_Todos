import 'package:flutter/material.dart';

class CreateTodosView extends StatelessWidget {
  const CreateTodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc Todos"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.separated(
              itemBuilder: (_, index) => const Text("Hello"),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 30,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: TextField(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 70,
                      color: Colors.grey,
                      child: const Text("Add"),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
