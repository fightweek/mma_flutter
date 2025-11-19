import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/pagination_notifier.dart';
import 'package:mma_flutter/common/repository/pagination_base_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockPaginationRepo extends Mock
    implements PaginationBaseRepository<_PaginationTestModel> {}

class TestPaginationNotifier
    extends PaginationNotifier<_PaginationTestModel, MockPaginationRepo> {
  TestPaginationNotifier({
    required super.repository,
    required super.autoRefetch,
  });

  PaginationBase get exposedState => state;

  set newState(PaginationBase newState) => state = newState;

  @override
  Future<void> paginateWithThrottle({
    int fetchCount = 10,
    bool fetchMore = false,
    bool forceRefetch = false,
    Map<String, dynamic>? params,
  }) {
    // throttle 타지 않고 바로 실행
    return throttledPagination(
      PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
        params: params,
      ),
    );
  }
}

void main() {
  late MockPaginationRepo mockRepo;
  late TestPaginationNotifier notifier;
  late Pagination<_PaginationTestModel> fakeResp;

  setUp(() {
    fakeResp = Pagination<_PaginationTestModel>(
      meta: PaginationMeta(
        last: false,
        totalElements: 207,
        totalPages: 21,
        size: 10,
        number: 0,
        // page number
        first: true,
        numberOfElements: 10,
        empty: false,
      ),
      content: List.generate(10, (index) {
        return _PaginationTestModel(
          name: 'name$index',
          age: index + 1,
          id: index + 1,
        );
      }),
    );
    mockRepo = MockPaginationRepo();
  });

  test(
    "Pagination state test "
    "(PaginationLoading -> Pagination<Model> -"
    "-paginate(forceRefetch)--> PaginationLoading -> Pagination<Model>) -"
    "-paginate(fetchMore)--> PaginationFetchingMore -> Pagination<Model>",
    () async {
      // given
      when(() => mockRepo.paginate(params: null)).thenAnswer((_) async {
        return fakeResp;
      });
      final paginationStateHistory = <PaginationBase>[];

      // when
      notifier = TestPaginationNotifier(
        repository: mockRepo,
        autoRefetch: false,
      ); // automatically paginate
      notifier.addListener((state) {
        paginationStateHistory.add(state);
      });
      await notifier.paginateWithThrottle();
      await notifier.paginateWithThrottle(forceRefetch: true);
      await notifier.paginateWithThrottle(fetchMore: true);

      // then
      expect(paginationStateHistory[0], isA<PaginationLoading>());
      expect(
        paginationStateHistory[1],
        isA<Pagination<_PaginationTestModel>>(),
      );
      expect(paginationStateHistory[2], isA<PaginationLoading>());
      expect(
        paginationStateHistory[3],
        isA<Pagination<_PaginationTestModel>>(),
      );
      expect(
        paginationStateHistory[4],
        isA<PaginationFetchingMore<_PaginationTestModel>>(),
      );
      expect(
        paginationStateHistory[5],
        isA<Pagination<_PaginationTestModel>>(),
      );
      expect(paginationStateHistory.length, equals(6));
      expect(
        (notifier.exposedState as Pagination<_PaginationTestModel>)
            .content
            .length,
        20,
      );
    },
  );
}

class _PaginationTestModel implements ModelWithId {
  @override
  final int id;
  final String name;
  final int age;

  _PaginationTestModel({
    required this.id,
    required this.name,
    required this.age,
  });
}
