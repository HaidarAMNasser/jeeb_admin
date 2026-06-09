import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/areas/delete_area/data/repositories/delete_area_repository.dart';

part 'delete_area_event.dart';
part 'delete_area_state.dart';

class DeleteAreaBloc extends Bloc<DeleteAreaEvent, DeleteAreaState> {
  final DeleteAreaRepository _deleteRepository;

  DeleteAreaBloc(this._deleteRepository) : super(const DeleteAreaInitial()) {
    on<DeleteAreaEvent>((event, emit) async {
      if (event is DeleteAreaSubmitted) {
        emit(const DeleteAreaLoading());
        final result = await _deleteRepository.deleteArea(event.areaId);
        result.fold(
          (failure) => emit(DeleteAreaError(message: failure.message)),
          (_) => emit(const DeleteAreaSuccess()),
        );
      }
    });
  }
}
