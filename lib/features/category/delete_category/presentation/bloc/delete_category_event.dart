part of 'delete_category_bloc.dart';

abstract class DeleteCategoryEvent extends Equatable {
  const DeleteCategoryEvent();

  @override
  List<Object> get props => [];
}

class DeleteCategorySubmitted extends DeleteCategoryEvent {

  final int categoryId;

  const DeleteCategorySubmitted({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
