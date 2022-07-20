import 'package:block_todos/presentation/splash/viewmodels/splash_screen_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _splashVM = Provider((ref) => SpalshScreenViewModel(ref));

class SplashScreenView extends ConsumerStatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SplashScreenViewState();
}

class _SplashScreenViewState extends ConsumerState<SplashScreenView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ref.read(_splashVM).onModelReady(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_splashVM);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: model.viewState.when(
          idle: () => Stack(
                alignment: Alignment.center,
                children: const [
                  Text("Block -> Todos"),
                  // Positioned(
                  //   bottom: 20,
                  //   left: 0,
                  //   right: 0,
                  //   child: CircularProgressIndicator.adaptive(),
                  // )
                ],
              ),
          busy: () {
            return Stack(
              alignment: Alignment.center,
              children: const [
                Text("Block -> Todos"),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: CircularProgressIndicator.adaptive(),
                )
              ],
            );
          },
          error: (e) {
            return const SizedBox.shrink();
          }),
    );
  }
}
