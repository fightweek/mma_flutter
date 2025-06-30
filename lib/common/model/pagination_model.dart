import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

abstract class PaginationBase {}

class PaginationError extends PaginationBase {
  final String message;

  PaginationError({required this.message});
}

class PaginationLoading extends PaginationBase {}

@JsonSerializable(genericArgumentFactories: true)
class Pagination<T> extends PaginationBase {
  @JsonKey(fromJson: PaginationMeta.fromRootJson,toJson: PaginationMeta.toRootJson)
  final PaginationMeta meta;

  final List<T> content;

  Pagination({required this.meta, required this.content});

  Pagination copyWith({PaginationMeta? meta, List<T>? content}) {
    return Pagination<T>(
      meta: meta ?? this.meta,
      content: content ?? this.content,
    );
  }

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return Pagination(
      content: (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      meta: PaginationMeta.fromRootJson(json),
    );
  }
}

class PaginationMeta {
  final bool last;

  // 모든 페이지 토탈 element 개수
  final int totalElements;
  final int totalPages;

  // 현재 페이지 element 개수
  final int size;

  // 페이지 번호
  final int number;
  final bool first;
  final int numberOfElements;
  final bool empty;

  PaginationMeta({
    required this.last,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory PaginationMeta.fromRootJson(Map<String, dynamic> json) {
    return PaginationMeta(
      last: json['last'] as bool,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      first: json['first'] as bool,
      numberOfElements: json['numberOfElements'] as int,
      empty: json['empty'] as bool,
    );
  }

  static Map<String, dynamic> toRootJson(PaginationMeta meta) => {
    'last': meta.last,
    'totalElements': meta.totalElements,
    'totalPages': meta.totalPages,
    'size': meta.size,
    'number': meta.number,
    'first': meta.first,
    'numberOfElements': meta.numberOfElements,
    'empty': meta.empty,
  };
}

// 데이터가 존재하는 상황에서 새로고침할 때 => 따라서 meta와 data field가 있을 것임
/// instance is CursorPaginarion & instance is CursorPaginationBase
class PaginationRefetching<T> extends Pagination<T> {
  PaginationRefetching({required super.meta, required super.content});
}

// 이미 데이터가 있는 상태에서 추가 데이터를 요청하는 상태
class PaginationFetchingMore<T> extends Pagination<T> {
  PaginationFetchingMore({required super.meta, required super.content});
}
