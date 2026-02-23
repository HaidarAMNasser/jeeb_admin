part of 'add_category_bloc.dart';

abstract class AddCategoryState extends Equatable {
  const AddCategoryState();

  @override
  List<Object?> get props => [];
}

class AddCategoryInitial extends AddCategoryState {
  const AddCategoryInitial();
}

class AddCategoryLoading extends AddCategoryState {
  const AddCategoryLoading();
}

class AddCategorySuccess extends AddCategoryState {
  final CategoryEntity category;

  const AddCategorySuccess({required this.category});

  @override
  List<Object?> get props => [category];
}

class AddCategoryError extends AddCategoryState {
  final String message;

  const AddCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

