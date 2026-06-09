part of 'update_area_bloc.dart';

abstract class UpdateAreaEvent extends Equatable {
  const UpdateAreaEvent();

  @override
  List<Object?> get props => [];
}

class UpdateAreaSubmitted extends UpdateAreaEvent {
  final String id;
  final String name;
  final String? description;
  final double price;

  const UpdateAreaSubmitted({
    required this.id,
    required this.name,
    this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, description, price];
}
