import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/category/list_category/domain/entities/category_entity.dart';
import 'package:jeeb_admin/features/category/add_category/data/repositories/add_category_repository.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final AddCategoryRepository _repository;

  AddCategoryBloc(this._repository) : super(const AddCategoryInitial()) {
    on<AddCategoryEvent>((event, emit) async {
      if (event is AddCategorySubmitted) {
        emit(const AddCategoryLoading());
        final result = await _repository.addCategory(name: event.name, imagePath: event.imagePath);
        result.fold(
          (failure) => emit(AddCategoryError(message: failure.message)),
          (category) => emit(AddCategorySuccess(category: category)),
        );
      }
    });
  }
}

