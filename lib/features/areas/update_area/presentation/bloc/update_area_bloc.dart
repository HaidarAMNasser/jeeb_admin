import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';
import 'package:jeeb_admin/features/areas/update_area/data/repositories/update_area_repository.dart';

part 'update_area_event.dart';
part 'update_area_state.dart';

class UpdateAreaBloc extends Bloc<UpdateAreaEvent, UpdateAreaState> {
  final UpdateAreaRepository _updateRepository;

  UpdateAreaBloc(this._updateRepository) : super(const UpdateAreaInitial()) {
    on<UpdateAreaEvent>((event, emit) async {
      if (event is UpdateAreaSubmitted) {
        emit(const UpdateAreaLoading());

        final priceInSmallestUnit = (event.price * 100).toInt();

        final body = <String, dynamic>{
          'name': event.name,
          'price': priceInSmallestUnit,
          if (event.description != null && event.description!.isNotEmpty)
            'description': event.description,
        };

        final result = await _updateRepository.updateArea(
          id: event.id,
          body: body,
        );
        result.fold(
          (failure) => emit(UpdateAreaError(message: failure.message)),
          (area) => emit(UpdateAreaSuccess(area: area)),
        );
      }
    });
  }
}
