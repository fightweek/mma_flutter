import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class FighterDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'fighter_detail';
  final int id;

  const FighterDetailScreen({required this.id, super.key});

  @override
  ConsumerState<FighterDetailScreen> createState() =>
      _FighterDetailScreenState();
}

class _FighterDetailScreenState extends ConsumerState<FighterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  IconData? _heart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fighterProvider.notifier).detail(id: widget.id);
    });
    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    controller.dispose();
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fighterProvider)[widget.id];

    if (state == null || state is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is StateError) {
      return DefaultLayout(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(fighterProvider.notifier).detail(id: widget.id);
            },
            child: Text('다시시도'),
          ),
        ),
      );
    }

    final fighter = state as StateData;
    final data = fighter.data;
    if (data == null) {
      return Center(child: Text('데이터 없음'));
    }
    return DefaultLayout(child: _renderInfo(data));
  }

  _renderInfo(FighterModel data) {
    return RefreshIndicator(
      onRefresh: () async {
        ref
            .read(fighterProvider.notifier)
            .detail(id: data.id, forceRefetch: true);
      },
      child: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Column(
                  children: [
                    if (data is FighterDetailModel && data.weight != null)
                      Text(
                        '${weightClassFromWeight(data.weight!)} ${data.ranking == 0 ? '챔피언' : '파이터'}',
                        style: TextStyle(
                          color: GREY_COLOR,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    SizedBox(
                      width: 292.w,
                      child: Row(
                        children: [
                          if (data.ranking != null && data.ranking! > 0)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              color: WHITE_COLOR,
                              child: Text(
                                '# ${data.ranking}',
                                style: TextStyle(
                                  color: BLACK_COLOR,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              data.name,
                              style: defaultTextStyle.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          _heart != null
                              ? _headerIcon(icon: _heart!)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    if (data is FighterDetailModel)
                      _imageCard(data.bodyUrl, data.name.replaceAll(' ', '-')),
                  ],
                ),
                Container(
                  height: 116.h,
                  width: 362.w,
                  decoration: BoxDecoration(
                    color: DARK_GREY_COLOR,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRecord(
                        name: '승',
                        value: data.record.win,
                        color: BLUE_COLOR,
                      ),
                      _buildRecord(
                        name: '패',
                        value: data.record.loss,
                        color: RED_COLOR,
                      ),
                      _buildRecord(
                        name: '무',
                        value: data.record.draw,
                        color: GREY_COLOR,
                      ),
                    ],
                  ),
                ),
                data is FighterDetailModel
                    ? _renderDetailInfo(data)
                    : Center(child: CircularProgressIndicator()),
                data is FighterDetailModel
                    ? _footer(data)
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imageCard(String imgUrl, String name) {
    final role = (ref.read(userProvider) as UserModel).role;
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: GestureDetector(
        onTap:
            role == 'ROLE_ADMIN'
                ? () async {
                  try {
                    await ref
                        .read(adminFighterRepositoryProvider)
                        .updateImage(fighterNameMap: {'fighterName': name});
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('이미지 업데이트 성공')));
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
                }
                : null,
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          height: 246.h,
          width: 223.w,
          errorWidget: (context, url, error) {
            return Image.asset(
              'asset/img/component/default-headshot.png',
              height: 200.h,
              width: 200.w,
            );
          },
        ),
      ),
    );
  }

  _buildRecord({
    required String name,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: Text(name, style: TextStyle(color: color, fontSize: 18.sp)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 17.h),
          child: Container(color: color, height: 2.h, width: 65.w),
        ),
        Text(
          value.toString(),
          style: defaultTextStyle.copyWith(fontSize: 24.sp),
        ),
      ],
    );
  }

  _renderDetailInfo(FighterDetailModel fighter) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_heart == null) {
        setState(() {
          _heart =
              fighter.alert
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart;
        });
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 31.h, bottom: 16.h),
      child: SizedBox(
        width: 300.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderLabelWithValue(
                  label: '출생',
                  value:
                      fighter.birthday != null
                          ? DataUtils.formatDateTime(fighter.birthday!)
                          : '-',
                ),
                _renderLabelWithValue(
                  label: '나이',
                  value:
                      '${fighter.birthday != null ? _calculateAge(fighter.birthday!) : '-'}',
                ),
                _renderLabelWithValue(label: '국적', value: '${fighter.nation}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderLabelWithValue(
                  label: '신장',
                  value: '${fighter.height} cm',
                ),
                _renderLabelWithValue(
                  label: '무게',
                  value: '${fighter.weight} Kg',
                ),
                _renderLabelWithValue(
                  label: '리치',
                  value: '${fighter.reach} cm',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderLabelWithValue({required String label, required String value}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: defaultTextStyle.copyWith(
                color: GREY_COLOR,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(width: 22.w),
            Text(
              value,
              style: defaultTextStyle.copyWith(
                color: WHITE_COLOR,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  int _calculateAge(DateTime birthday) {
    DateTime now = DateTime.now();
    int age = now.year - birthday.year;
    if (birthday.month < now.month ||
        (birthday.month == now.month && birthday.day < now.day)) {
      age--;
    }
    return age;
  }

  Widget _footer(FighterDetailModel data) {
    return Column(
      children: [
        Container(
          color: DARK_GREY_COLOR,
          child: TabBar(
            controller: controller,
            indicatorColor: BLUE_COLOR,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: GREY_COLOR,
            tabs: const [Tab(text: '최근 경기'), Tab(text: '다음 경기')],
          ),
        ),
        SizedBox(height: 9.h),
        index == 0
            ? _filterFightEvent(data: data, isUpcoming: false)
            : _filterFightEvent(data: data, isUpcoming: true),
      ],
    );
  }

  Widget _filterFightEvent({
    required FighterDetailModel data,
    required bool isUpcoming,
  }) {
    return Column(
      children:
          (data.fighterFightEvents ?? [])
              .where(
                (ffe) => isUpcoming ? ffe.result == null : ffe.result != null,
              )
              .map(
                (ffe) =>
                    FighterFightEventCard(ffe: ffe, isFightEventCard: true),
              )
              .toList(),
    );
  }

  _headerIcon({required IconData icon}) {
    return GestureDetector(
      child: FaIcon(icon, size: 24.0, color: GREY_COLOR),
      onTap: () {
        final isOn = icon == FontAwesomeIcons.heart;
        print('isOn=$isOn');
        if (isOn) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이제부터 해당 선수에 대한 경기 알림을 받습니다.')),
          );
        }
        ref
            .read(fighterProvider.notifier)
            .updatePreference(
              model: UpdatePreferenceModel(targetId: widget.id, on: isOn),
              alert: isOn,
            );
        setState(() {
          _heart = isOn ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
        });
      },
    );
  }
}
