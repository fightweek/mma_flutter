import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/admin/component/fighter_name_check_box_for_game.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/admin/provider/common_update_provider.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/pagination_list_view.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/fighter/component/fighter_card.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_pagination_provider.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';
import 'package:mma_flutter/fighter/screen/fighter_detail_screen.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textController = TextEditingController();
  String _prevText = '';
  List<String> selectedNames = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fighterPaginationProvider);

    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            _renderFighterCards(state),
            if ((ref.read(userProvider) as UserModel).role == 'ROLE_ADMIN' &&
                selectedNames.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(adminFighterRepositoryProvider)
                        .saveGameFighters(chosenFighters: selectedNames);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          titleMsg: '에러',
                          contentMsg: 'reason : $e',
                        );
                      },
                    );
                  }
                },
                child: Text('저장'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: SizedBox(
        height: 38.h,
        width: 362.w,
        child: TextFormField(
          controller: _textController,
          onChanged: onChanged,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 5.h,bottom: 5.h,left: 16.w),
            hintText: '검색어를 입력하세요.',
            hintStyle: TextStyle(
              color: GREY_COLOR,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            border: linearGradientInputBorder,
            prefixIcon: IconButton(
              onPressed: () {
                context.pushNamed("");
              },
              icon: Icon(Icons.search, color: WHITE_COLOR),
            ),
          ),
        ),
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
          return Row(
            children: [
              InkWell(
                onTap: () {
                  ref.read(fighterProvider.notifier).updateFighter(model);
                  context.pushNamed(
                    FighterDetailScreen.routeName,
                    pathParameters: {'id': model.id.toString()},
                  );
                },
                child: FighterCard(fighter: model),
              ),
              if ((ref.read(userProvider) as UserModel).role == 'ROLE_ADMIN')
                FighterNameCheckBoxForGame(
                  name: model.name,
                  isSelected: selectedNames.contains(model.name),
                  onChanged: (isChecked) {
                    if (isChecked) {
                      setState(() {
                        selectedNames.add(model.name);
                      });
                    } else {
                      setState(() {
                        selectedNames.remove(model.name);
                      });
                    }
                  },
                ),
            ],
          );
        },
        params: {'name': _prevText},
      ),
    );
  }
}
