import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/event/component/schedule_card.dart';
import 'package:mma_flutter/event/model/schedule_model.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';

class FighterDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '/detail';
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
  IconData? _alert;

  @override
  void initState() {
    print('initialize detail screen');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fighterProvider.notifier).detail(widget.id);
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

    if (state is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is StateError) {
      final fState = state as StateError;
      return DefaultLayout(
        child: Center(child: Text(fState.message, style: defaultTextStyle)),
      );
    }

    final fighter = state as StateData<FighterModel>;
    final data = fighter.data;
    if (data == null) {
      return DefaultLayout(child: Center(child: Text('데이터 없음')));
    }
    return DefaultLayout(child: _renderInfo(data));
  }

  _renderInfo(FighterModel data) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    _headerText(data.name),
                    _alert != null
                        ? _headerIcon(icon: _alert!, isAlert: true)
                        : const SizedBox.shrink(),
                  ],
                ),
                Row(
                  children: [
                    _headerText('${data.weight} 파운드'),
                    _heart != null
                        ? _headerIcon(icon: _heart!, isAlert: false)
                        : const SizedBox.shrink(),
                  ],
                ),
                if (data.ranking != null)
                  Text('랭킹 ${data.ranking} 위', style: defaultTextStyle),
                _imageCard(data.imgPresignedUrl),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRecord('승', data.record.win),
                _buildRecord('패', data.record.loss),
                _buildRecord('무', data.record.draw),
              ],
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
    );
  }

  _imageCard(String presignedUrl) {
    return Image.network(
      height: 200,
      width: 200,
      presignedUrl,
      errorBuilder: (context, error, stackTrace) {
        return Container(color: MY_MIDDLE_GREY_COLOR, height: 70, width: 70);
      },
    );
  }

  _buildRecord(String name, int value) {
    return Column(
      children: [
        Text(name, style: defaultTextStyle.copyWith(fontSize: 30)),
        SizedBox(height: 4.0),
        Text(value.toString(), style: defaultTextStyle.copyWith(fontSize: 30)),
      ],
    );
  }

  _renderDetailInfo(FighterDetailModel fighter) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_alert == null && _heart == null) {
        setState(() {
          _alert =
              fighter.alert
                  ? FontAwesomeIcons.solidBell
                  : FontAwesomeIcons.bell;
          _heart =
              fighter.like
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart;
        });
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: MY_DARK_GREY_COLOR,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '신장: ${fighter.height}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '무게: ${fighter.weight}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '생일: ${fighter.birthday.year}-${fighter.birthday.month}-${fighter.birthday.day}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '팔길이: ${fighter.reach}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '나이: ${_calculateAge(fighter.birthday)}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '국적: ${fighter.nation}',
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
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

  Widget _headerText(String data) {
    return Expanded(
      child: Center(
        child: Text(data, style: defaultTextStyle.copyWith(fontSize: 40)),
      ),
    );
  }

  Widget _footer(FighterDetailModel data) {
    return Column(
      children: [
        Container(
          color: Colors.grey[800],
          child: TabBar(
            controller: controller,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            tabs: const [Tab(text: '최근 경기'), Tab(text: '다음 경기')],
          ),
        ),
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
                (ffe) => ScheduleCard(
                  ffe: ffe,
                  isDetail: true,
                  isUpcoming: isUpcoming,
                ),
              )
              .toList(),
    );
  }

  _headerIcon({required bool isAlert, required IconData icon}) {
    return GestureDetector(
      child: FaIcon(icon, size: 24.0, color: Colors.white),
      onTap: () {
        final category =
            isAlert ? PreferenceCategory.alert : PreferenceCategory.like;
        final isOn =
            icon == (isAlert ? FontAwesomeIcons.bell : FontAwesomeIcons.heart);
        print('isOn=$isOn');
        if (isOn && category == PreferenceCategory.alert) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이제부터 해당 선수에 대한 경기 알림을 받습니다.')),
          );
        }
        ref
            .read(fighterProvider.notifier)
            .updatePreference(
              UpdatePreferenceModel(
                category: category,
                targetId: widget.id,
                isOn: isOn,
              ),
            );
        setState(() {
          if (isAlert) {
            _alert = isOn ? FontAwesomeIcons.solidBell : FontAwesomeIcons.bell;
          } else {
            _heart =
                isOn ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart;
          }
        });
      },
    );
  }
}
