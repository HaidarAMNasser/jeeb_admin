part of 'create_area_bloc.dart';

abstract class CreateAreaEvent extends Equatable {
  const CreateAreaEvent();

  @override
  List<Object?> get props => [];
}

class InitializeAreaForm extends CreateAreaEvent {
  final AreaEntity? area;

  const InitializeAreaForm({this.area});

  @override
  List<Object?> get props => [area];
}

class UpdateAreaName extends CreateAreaEvent {
  final String name;

  const UpdateAreaName({required this.name});

  @override
  List<Object> get props => [name];
}

class UpdateAreaDescription extends CreateAreaEvent {
  final String description;

  const UpdateAreaDescription({required this.description});

  @override
  List<Object> get props => [description];
}

class UpdateAreaPrice extends CreateAreaEvent {
  final String price;

  const UpdateAreaPrice({required this.price});

  @override
  List<Object> get props => [price];
}

class CreateAreaSubmitted extends CreateAreaEvent {
  const CreateAreaSubmitted();
}

class CheckAreaValidationEvent extends CreateAreaEvent {
  const CheckAreaValidationEvent();
}

class ResetAreaForm extends CreateAreaEvent {
  const ResetAreaForm();
}
