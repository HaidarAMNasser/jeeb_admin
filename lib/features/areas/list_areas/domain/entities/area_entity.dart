import 'package:equatable/equatable.dart';

class AreaEntity extends Equatable {
  final String id;
  final String name;
  final int price;
  final String? description;

  const AreaEntity({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  double get priceDisplay => price / 100;

  String get formattedPrice => priceDisplay.toStringAsFixed(2);

  @override
  List<Object?> get props => [id, name, price, description];
}
