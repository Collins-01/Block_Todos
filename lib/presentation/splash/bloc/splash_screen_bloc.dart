import 'package:bloc/bloc.dart';
import 'package:block_todos/core/domain_layer/domain_layer.dart';
import 'package:block_todos/presentation/splash/bloc/bloc.dart';
import 'package:block_todos/presentation/splash/bloc/splash_screen_events.dart';
import 'package:block_todos/utils/app_logger.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvents, SplashScreenState> {
  final TodosRepository _todosRepositoryImple;
  SplashScreenBloc({required TodosRepository todosRepositoryImple})
      : _todosRepositoryImple = todosRepositoryImple,
        super(
          const SplashScreenState(),
        ) {
    on<InitialiseEvent>(init);
  }

  Future<void> init(InitialiseEvent event, Emitter emit) async {
    try {
      emit(
        state.copyWith(status: SplashScreenStatus.isLoading),
      );
      await _todosRepositoryImple
          .initiateSetUp()
          .then((value) => AppLogger.log(state.status));
      state.copyWith(status: SplashScreenStatus.isSuccess);
    } catch (e) {
      print("Errror ::: $e");
      emit(
        state.copyWith(
          status: SplashScreenStatus.isError,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
