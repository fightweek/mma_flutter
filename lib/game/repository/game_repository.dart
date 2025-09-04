import 'package:dio/dio.dart' hide Headers;
import 'package:mma_flutter/game/model/game_attempt_response_model.dart';
import 'package:mma_flutter/game/model/game_response_model.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'game_repository.g.dart';

@RestApi()
abstract class GameRepository {
  factory GameRepository(Dio dio, {String baseUrl}) = _GameRepository;

  @GET('/start')
  @Headers({'accessToken': 'true'})
  Future<GameResponseModel> getGameQuestions({
    @Query('isNormal') required bool isNormal,
    @Query('isImage') required bool isImage,
  });

  @GET('/attempt_count')
  @Headers({'accessToken': 'true'})
  Future<GameAttemptResponseModel> getGameAttemptCount();

  @POST('/update_attempt_count')
  @Headers({'accessToken': 'true'})
  Future<void> updateAttemptCount({
    @Query("isSubtract") required bool isSubtract
});

  @PATCH('/update_point')
  @Headers({'accessToken': 'true'})
  Future<int> updatePoint({@Query("newPoint") required String newPoint});
}
