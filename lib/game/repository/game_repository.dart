import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'game_repository.g.dart';

@RestApi()
abstract class GameRepository {
  @GET('/start')
  @Headers({'accessToken': 'true'})
  Future<void> getGameQuestions({@Query('normal') required bool isNormal});
}
