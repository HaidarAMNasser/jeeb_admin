import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/areas/area_details/data/repositories/area_details_repository.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

part 'area_details_event.dart';
part 'area_details_state.dart';

class AreaDetailsBloc extends Bloc<AreaDetailsEvent, AreaDetailsState> {
  final AreaDetailsRepository _repository;

  AreaDetailsBloc(this._repository) : super(const AreaDetailsInitial()) {
    on<AreaDetailsEvent>((event, emit) async {
      if (event is GetAreaDetailsEvent) {
        emit(const AreaDetailsLoading());

        final result = await _repository.getAreaDetails(event.id);
        result.fold(
          (failure) => emit(AreaDetailsError(message: failure.message)),
          (area) => emit(AreaDetailsLoaded(area: area)),
        );
      }
    });
  }
}
