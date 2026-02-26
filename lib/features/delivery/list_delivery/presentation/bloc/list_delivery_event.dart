part of 'list_delivery_bloc.dart';

abstract class ListDeliveryEvent extends Equatable {
  const ListDeliveryEvent();

  @override
  List<Object> get props => [];
}

class GetDeliveryMenEvent extends ListDeliveryEvent {
  final bool loadMore;
  final String? search;

  const GetDeliveryMenEvent({
    this.loadMore = false,
    this.search,
  });

  @override
  List<Object> get props => [loadMore, search ?? ''];
}
