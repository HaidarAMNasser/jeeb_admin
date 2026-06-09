part of 'area_details_bloc.dart';

abstract class AreaDetailsEvent extends Equatable {
  const AreaDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetAreaDetailsEvent extends AreaDetailsEvent {
  final String id;

  const GetAreaDetailsEvent({required this.id});

  @override
  List<Object> get props => [id];
}
