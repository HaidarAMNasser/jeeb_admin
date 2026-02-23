part of 'list_product_bloc.dart';

abstract class ListProductEvent extends Equatable {
  const ListProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ListProductEvent {
  const GetProductsEvent();
}

