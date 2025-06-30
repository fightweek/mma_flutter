import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/component/custom_text_form_field.dart';
import 'package:mma_flutter/common/component/pagination_list_view.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/fighter/component/fighter_card.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_pagination_provider.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textController = TextEditingController();
  String _prevText = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fighterPaginationProvider);

    return Column(children: [_searchBar(), _renderFighterCards(state)]);
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextFormField(
        controller: _textController,
        onChanged: onChanged,
        hintText: '검색어를 입력하세요.',
        borderRadiusSize: 12.0,
        suffixIcon: IconButton(onPressed: () {
          context.pushNamed("");
        }, icon: Icon(Icons.search)),
      ),
    );
  }

  void onChanged(String value) {
    print('changed');
    if (_prevText.length > value.length) {
      ref
          .read(fighterPaginationProvider.notifier)
          .paginate(params: {'name': value}, forceRefetch: true);
    } else {
      ref
          .read(fighterPaginationProvider.notifier)
          .paginate(params: {'name': value});
    }
    setState(() {
      _prevText = value;
    });
  }

  _renderFighterCards(PaginationBase state) {
    return Expanded(
      child: PaginationListView<FighterModel, FighterRepository>(
        provider: fighterPaginationProvider,
        itemBuilder: (context, index, model) {
          return InkWell(
            onTap: () {
              ref.read(fighterProvider.notifier).updateFighter(model);
              context.pushNamed(
                FighterDetailScreen.routeName,
                pathParameters: {'id': model.id.toString()},
              );
            },
            child: FighterCard(fighter: model),
          );
        },
        params: {'name': _prevText},
      ),
    );
  }
}
