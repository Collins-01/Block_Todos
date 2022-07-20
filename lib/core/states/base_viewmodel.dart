import 'package:block_todos/core/states/view_state.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _viewState = const ViewState.idle();
  ViewState get viewState => _viewState;

  ///Returns true if the state is BUSY
  bool get isBusy =>
      _viewState.maybeWhen<bool>(busy: () => true, orElse: () => false);

  ///Returns true if the state is Idle
  bool get isIdle =>
      _viewState.maybeWhen(idle: () => true, orElse: () => false);

  ///Returns true if the state has an Error
  bool get isError =>
      _viewState.maybeWhen<bool>(error: (value) => true, orElse: () => false);

  /// A getter to return the Error for the Current State
  String getError() => _viewState.maybeWhen(
      error: (failure) => failure.message, orElse: () => "");
  setViewState(ViewState newState) {
    _viewState = newState;
    // notify listeners if viewmodel is still active
    if (!isDisposed) notifyListeners();
  }

  bool _disposed = false;

  /// Returns True,  if the current State has been disposed
  bool get isDisposed => _disposed;
  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }
}
