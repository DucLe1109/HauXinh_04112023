part of 'information_collection_cubit.dart';

@Freezed()
class InformationCollectionState with _$InformationCollectionState {
  const factory InformationCollectionState({
    @Default(UIInitial()) UIStatus status,
  }) = _InformationCollectionState;
}
