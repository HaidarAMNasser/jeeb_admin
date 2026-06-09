part of 'create_area_bloc.dart';

abstract class CreateAreaState extends Equatable {
  final String? areaId;
  final bool isValid;

  const CreateAreaState({
    this.areaId,
    this.isValid = false,
  });

  CreateAreaState copyWith({
    String? areaId,
    bool? isValid,
  });

  @override
  List<Object?> get props => [areaId, isValid];
}

class CreateAreaInitial extends CreateAreaState {
  const CreateAreaInitial({super.areaId, super.isValid});

  @override
  CreateAreaState copyWith({String? areaId, bool? isValid}) {
    return CreateAreaInitial(
      areaId: areaId ?? this.areaId,
      isValid: isValid ?? this.isValid,
    );
  }
}

class CreateAreaLoading extends CreateAreaState {
  const CreateAreaLoading({super.areaId, required super.isValid});

  @override
  CreateAreaState copyWith({String? areaId, bool? isValid}) {
    return CreateAreaLoading(
      areaId: areaId ?? this.areaId,
      isValid: isValid ?? this.isValid,
    );
  }
}

class CreateAreaError extends CreateAreaState {
  final String message;

  const CreateAreaError({
    required this.message,
    super.areaId,
    required super.isValid,
  });

  @override
  CreateAreaState copyWith({String? areaId, bool? isValid}) {
    return CreateAreaError(
      message: message,
      areaId: areaId ?? this.areaId,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [message, ...super.props];
}

class CreateAreaSuccess extends CreateAreaState {
  final AreaEntity area;

  CreateAreaSuccess({required this.area}) : super(areaId: area.id, isValid: true);

  @override
  CreateAreaState copyWith({String? areaId, bool? isValid}) {
    return CreateAreaInitial(
      areaId: areaId ?? this.areaId,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [area, ...super.props];
}
