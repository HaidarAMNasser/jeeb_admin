part of 'update_category_bloc.dart';

abstract class UpdateCategoryState extends Equatable {
  const UpdateCategoryState();

  @override
  List<Object?> get props => [];
}

class UpdateCategoryInitial extends UpdateCategoryState {
  const UpdateCategoryInitial();
}

class UpdateCategoryLoading extends UpdateCategoryState {
  const UpdateCategoryLoading();
}

class UpdateCategorySuccess extends UpdateCategoryState {
  const UpdateCategorySuccess();
}

class UpdateCategoryError extends UpdateCategoryState {
  final String message;

  const UpdateCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
