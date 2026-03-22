part of 'list_category_bloc.dart';

abstract class ListCategoryEvent extends Equatable {
  const ListCategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends ListCategoryEvent {
  /// When true, loads a large first page for the categories admin list (not paginated in UI).
  final bool fullList;

  /// When true, appends the next page (dropdown / infinite scroll).
  final bool loadMore;

  /// Server-side search (dropdown). Ignored when [fullList] is true.
  final String? search;

  const GetCategoriesEvent({
    this.fullList = false,
    this.loadMore = false,
    this.search,
  });

  @override
  List<Object?> get props => [fullList, loadMore, search];
}

