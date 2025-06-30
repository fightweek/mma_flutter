import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';

abstract class PaginationBaseRepository<T extends ModelWithId>{
  Future<Pagination<T>> paginate({Map<String,dynamic>? params});
}