part of 'delete_area_bloc.dart';

abstract class DeleteAreaEvent extends Equatable {
  const DeleteAreaEvent();

  @override
  List<Object> get props => [];
}

class DeleteAreaSubmitted extends DeleteAreaEvent {
  final String areaId;

  const DeleteAreaSubmitted({required this.areaId});

  @override
  List<Object> get props => [areaId];
}
