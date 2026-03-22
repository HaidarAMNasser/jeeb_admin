part of 'delete_category_bloc.dart';

abstract class DeleteCategoryState extends Equatable {
  const DeleteCategoryState();

  @override
  List<Object?> get props => [];
}

class DeleteCategoryInitial extends DeleteCategoryState {
  const DeleteCategoryInitial();
}

class DeleteCategoryLoading extends DeleteCategoryState {
  const DeleteCategoryLoading();
}

class DeleteCategorySuccess extends DeleteCategoryState {
  const DeleteCategorySuccess();
}

class DeleteCategoryError extends DeleteCategoryState {
  final String message;

  const DeleteCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
