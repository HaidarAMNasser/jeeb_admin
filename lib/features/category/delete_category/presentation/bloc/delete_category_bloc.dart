import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/category/delete_category/data/repositories/delete_category_repository.dart';

part 'delete_category_event.dart';
part 'delete_category_state.dart';

class DeleteCategoryBloc extends Bloc<DeleteCategoryEvent, DeleteCategoryState> {
  final DeleteCategoryRepository _repository;

  DeleteCategoryBloc(this._repository) : super(const DeleteCategoryInitial()) {
    on<DeleteCategoryEvent>((event, emit) async {
      if (event is DeleteCategorySubmitted) {
        emit(const DeleteCategoryLoading());
        final result = await _repository.deleteCategory(event.categoryId);
        result.fold(
          (failure) => emit(DeleteCategoryError(message: failure.message)),
          (_) => emit(const DeleteCategorySuccess()),
        );
      }
    });
  }
}
