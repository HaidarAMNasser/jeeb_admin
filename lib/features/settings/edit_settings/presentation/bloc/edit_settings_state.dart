part of 'edit_settings_bloc.dart';

abstract class EditSettingsState extends Equatable {
  const EditSettingsState();

  @override
  List<Object?> get props => [];
}

class EditSettingsInitial extends EditSettingsState {
  const EditSettingsInitial();
}

class EditSettingsLoading extends EditSettingsState {
  const EditSettingsLoading();
}

class EditSettingsSuccess extends EditSettingsState {
  const EditSettingsSuccess();
}

class EditSettingsError extends EditSettingsState {
  final String message;

  const EditSettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
