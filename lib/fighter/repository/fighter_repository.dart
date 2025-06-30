import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/dio/dio_provider.dart';
import 'package:mma_flutter/common/repository/pagination_base_repository.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'fighter_repository.g.dart';

final fighterRepositoryProvider = Provider<FighterRepository>((ref) {
  final dio = ref.read(dioProvider);
  return FighterRepository(dio, baseUrl: 'http://$ip/fighter');
});

@RestApi()
abstract class FighterRepository implements PaginationBaseRepository<FighterModel> {
  factory FighterRepository(Dio dio, {String baseUrl}) = _FighterRepository;

  @GET('/detail')
  @Headers({'accessToken': 'true'})
  Future<FighterDetailModel> detail({
    @Query('fighterId') required int fighterId,
  });

  @POST('/update_preference')
  @Headers({'accessToken': 'true'})
  Future<void> updatePreference({
    @Body() required UpdatePreferenceModel request,
  });

  @override
  @GET('/search')
  @Headers({'accessToken': 'true'})
  Future<Pagination<FighterModel>> paginate({@Queries() Map<String,dynamic>? params});
}
