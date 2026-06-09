part of 'area_details_bloc.dart';

abstract class AreaDetailsState extends Equatable {
  const AreaDetailsState();

  @override
  List<Object?> get props => [];
}

class AreaDetailsInitial extends AreaDetailsState {
  const AreaDetailsInitial();
}

class AreaDetailsLoading extends AreaDetailsState {
  const AreaDetailsLoading();
}

class AreaDetailsLoaded extends AreaDetailsState {
  final AreaEntity area;

  const AreaDetailsLoaded({required this.area});

  @override
  List<Object?> get props => [area];
}

class AreaDetailsError extends AreaDetailsState {
  final String message;

  const AreaDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
