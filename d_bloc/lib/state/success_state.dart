part of 'd_state.dart';

class SuccessState<T> extends BlocState {
  final T? data;

  const SuccessState({
    this.data,
  });

  @override
  List<Object?> get props => [data];
}
