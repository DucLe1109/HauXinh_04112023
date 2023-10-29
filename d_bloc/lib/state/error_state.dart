part of 'd_state.dart';

class ErrorState<E> extends BlocState {
  final E error;

  const ErrorState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}