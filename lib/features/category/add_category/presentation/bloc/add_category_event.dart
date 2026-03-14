part of 'add_category_bloc.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object?> get props => [];
}

class AddCategorySubmitted extends AddCategoryEvent {
  final String name;
  final String? imagePath;

  const AddCategorySubmitted({required this.name, this.imagePath});

  @override
  List<Object?> get props => [name, imagePath];
}

