import 'package:blooper_client/domain/entities/posting_list_item_entity.dart';
import 'package:equatable/equatable.dart';

class PaginationState extends Equatable {
  const PaginationState();

  @override
  List<Object?> get props => [];
}

/// No query has been searched yet
class PaginationStateInitial extends PaginationState {
  const PaginationStateInitial();
}

class PaginationStateLoaded extends PaginationState {
  late List<PostingListItemEntity> results;
  late int index;

  PaginationStateLoaded({
    required this.results,
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}
