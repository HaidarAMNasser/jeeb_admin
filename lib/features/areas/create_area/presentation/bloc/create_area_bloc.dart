import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/areas/create_area/data/repositories/create_area_repository.dart';
import 'package:jeeb_admin/features/areas/list_areas/domain/entities/area_entity.dart';

part 'create_area_event.dart';
part 'create_area_state.dart';

class CreateAreaBloc extends Bloc<CreateAreaEvent, CreateAreaState> {
  final CreateAreaRepository _createRepository;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreateAreaBloc(this._createRepository) : super(const CreateAreaInitial()) {
    on<CreateAreaEvent>((event, emit) async {
      if (event is InitializeAreaForm) {
        if (event.area != null) {
          nameController.text = event.area!.name;
          descriptionController.text = event.area!.description ?? '';
          priceController.text = event.area!.formattedPrice;
          emit(CreateAreaInitial(
            areaId: event.area!.id,
          ));
        } else {
          emit(const CreateAreaInitial());
        }
        add(const CheckAreaValidationEvent());
      } else if (event is UpdateAreaName) {
        nameController.text = event.name;
        emit(state.copyWith());
        add(const CheckAreaValidationEvent());
      } else if (event is UpdateAreaDescription) {
        descriptionController.text = event.description;
        emit(state.copyWith());
      } else if (event is UpdateAreaPrice) {
        priceController.text = event.price;
        emit(state.copyWith());
        add(const CheckAreaValidationEvent());
      } else if (event is CreateAreaSubmitted) {
        if (!state.isValid) {
          return;
        }
        emit(CreateAreaLoading(
          areaId: state.areaId,
          isValid: state.isValid,
        ));

        final priceInSmallestUnit =
            ((double.tryParse(priceController.text.trim()) ?? 0.0) * 100).toInt();

        final body = <String, dynamic>{
          'name': nameController.text.trim(),
          'price': priceInSmallestUnit,
          if (descriptionController.text.trim().isNotEmpty)
            'description': descriptionController.text.trim(),
        };

        final result = await _createRepository.createArea(body);
        result.fold(
          (failure) => emit(CreateAreaError(
            message: failure.message,
            areaId: state.areaId,
            isValid: state.isValid,
          )),
          (area) => emit(CreateAreaSuccess(area: area)),
        );
      } else if (event is CheckAreaValidationEvent) {
        final isValid = _isFormValid();
        emit(state.copyWith(isValid: isValid));
      } else if (event is ResetAreaForm) {
        nameController.clear();
        descriptionController.clear();
        priceController.clear();
        emit(const CreateAreaInitial());
      }
    });
  }

  bool _isFormValid() {
    if (nameController.text.trim().isEmpty) return false;
    if (priceController.text.trim().isEmpty) return false;
    if (double.tryParse(priceController.text.trim()) == null ||
        double.tryParse(priceController.text.trim())! <= 0) {
      return false;
    }
    return true;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    return super.close();
  }
}
