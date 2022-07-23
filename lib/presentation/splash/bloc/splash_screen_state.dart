import 'package:equatable/equatable.dart';

enum SplashScreenStatus { idle, isLoading, isError, isSuccess }

extension XSplashScreenStatus on SplashScreenStatus {
  bool get isError => this == SplashScreenStatus.isError;
  bool get isSuccess => this == SplashScreenStatus.isSuccess;
  bool get isLoading => this == SplashScreenStatus.isLoading;
  bool get idle => this == SplashScreenStatus.idle;
}

class SplashScreenState extends Equatable {
  const SplashScreenState({
    this.status = SplashScreenStatus.idle,
    this.errorMessage = "",
  });
  final SplashScreenStatus status;
  final String errorMessage;
  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];

  SplashScreenState copyWith({
    SplashScreenStatus? status,
    String? errorMessage,
  }) {
    return SplashScreenState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
