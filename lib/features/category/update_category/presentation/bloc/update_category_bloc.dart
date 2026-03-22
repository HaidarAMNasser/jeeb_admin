import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/category/update_category/data/repositories/update_category_repository.dart';

part 'update_category_event.dart';
part 'update_category_state.dart';

class UpdateCategoryBloc extends Bloc<UpdateCategoryEvent, UpdateCategoryState> {
  final UpdateCategoryRepository _repository;

  UpdateCategoryBloc(this._repository) : super(const UpdateCategoryInitial()) {
    on<UpdateCategoryEvent>((event, emit) async {
      if (event is UpdateCategorySubmitted) {
        emit(const UpdateCategoryLoading());
        final result = await _repository.updateCategory(
          id: event.id,
          name: event.name,
          imagePath: event.imagePath,
        );
        result.fold(
          (failure) => emit(UpdateCategoryError(message: failure.message)),
          (_) => emit(const UpdateCategorySuccess()),
        );
      }
    });
  }
}
