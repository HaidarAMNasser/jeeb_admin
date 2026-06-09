part of 'update_area_bloc.dart';

abstract class UpdateAreaState extends Equatable {
  const UpdateAreaState();

  @override
  List<Object?> get props => [];
}

class UpdateAreaInitial extends UpdateAreaState {
  const UpdateAreaInitial();
}

class UpdateAreaLoading extends UpdateAreaState {
  const UpdateAreaLoading();
}

class UpdateAreaSuccess extends UpdateAreaState {
  final AreaEntity area;

  const UpdateAreaSuccess({required this.area});

  @override
  List<Object?> get props => [area];
}

class UpdateAreaError extends UpdateAreaState {
  final String message;

  const UpdateAreaError({required this.message});

  @override
  List<Object?> get props => [message];
}
