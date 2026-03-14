part of 'update_category_bloc.dart';

abstract class UpdateCategoryEvent extends Equatable {
  const UpdateCategoryEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCategorySubmitted extends UpdateCategoryEvent {
  final String id;
  final String name;
  final String? imagePath;

  const UpdateCategorySubmitted({
    required this.id,
    required this.name,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, imagePath];
}
