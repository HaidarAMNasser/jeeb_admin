part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object> get props => [];
}

class AddCategorySubmitted extends AddCategoryEvent {
  final String name;

  const AddCategorySubmitted({required this.name});

  @override
  List<Object> get props => [name];
}

