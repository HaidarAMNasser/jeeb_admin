part of 'delete_area_bloc.dart';

abstract class DeleteAreaState extends Equatable {
  const DeleteAreaState();

  @override
  List<Object?> get props => [];
}

class DeleteAreaInitial extends DeleteAreaState {
  const DeleteAreaInitial();
}

class DeleteAreaLoading extends DeleteAreaState {
  const DeleteAreaLoading();
}

class DeleteAreaSuccess extends DeleteAreaState {
  const DeleteAreaSuccess();
}

class DeleteAreaError extends DeleteAreaState {
  final String message;

  const DeleteAreaError({required this.message});

  @override
  List<Object?> get props => [message];
}
