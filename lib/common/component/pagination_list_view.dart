import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/pagination_provider.dart';
import 'package:mma_flutter/common/repository/pagination_base_repository.dart';

class PaginationListView<
  T extends ModelWithId,
  U extends PaginationBaseRepository<T>
>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider<T, U>, PaginationBase>
  provider;
  final Widget Function(BuildContext context, int index, T model) itemBuilder;
  final Map<String, dynamic>? params;
  // final Widget loadingWidget;

  const PaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
    // required this.loadingWidget,
    this.params,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends ModelWithId>
    extends ConsumerState<PaginationListView<T, PaginationBaseRepository<T>>> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(listener);
  }

  void listener() {
    if (_controller.offset > _controller.position.maxScrollExtent - 300) {
      final state = ref.read(widget.provider) as Pagination;
      print(state.meta.number);
      final updatedParams = {'page': state.meta.number + 1, ...?widget.params};
      ref
          .read(widget.provider.notifier)
          .paginate(fetchMore: true, params: updatedParams);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    if (state is PaginationLoading) {
      return Center(child: CircularProgressIndicator(),);
      // return ListView.separated(
      //   itemBuilder: (context, index) {
      //     return widget.loadingWidget;
      //   },
      //   separatorBuilder: (context, index) {
      //     return SizedBox(height: 16.h);
      //   },
      //   itemCount: 10,
      // );
    }
    if (state is PaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message, textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시 시도'),
          ),
        ],
      );
    }
    final page = state as Pagination<T>;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(widget.provider.notifier).paginate(forceRefetch: true);
      },
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: page.content.length + 1,
        itemBuilder: (_, index) {
          if (index == page.content.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child:
                    page is PaginationFetchingMore
                        ? CircularProgressIndicator()
                        : SizedBox.shrink(),
              ),
            );
          }
          final pItem = page.content[index];
          return widget.itemBuilder(context, index, pItem);
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.h);
        },
      ),
    );
  }
}
