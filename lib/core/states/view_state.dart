import 'package:block_todos/core/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'view_state.freezed.dart';

@freezed
class ViewState with _$ViewState {
  const factory ViewState.idle() = _Idle;
  const factory ViewState.busy() = _Busy;
  const factory ViewState.error(Failure failure) = _Error;
}
