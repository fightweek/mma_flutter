import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/common/model/base_state.dart';
import 'package:mma_flutter/event/component/schedule_card.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(fighterProvider(widget.id).notifier).detail();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fighterProvider(widget.id))[widget.id];

    if (state is StateLoading) {
      return CircularProgressIndicator();
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
            Text(
              '${data.name}\nUFC ${weightMap[int.parse(data.weight)] ?? '헤비급'}',
              style: defaultTextStyle.copyWith(fontSize: 40),
            ),
            _imageCard(data.imgPresignedUrl),
            if (data.ranking != null) Text('랭킹 ${data.ranking} 위'),
            // _imageCard(data.imgPresignedUrl),
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
        return Container(color: MY_MIDDLE_GREY_COLOR, height: 150, width: 150);
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
            ? Column(
              children:
                  (data.fighterFightEvents ?? [])
                      .map((event) => ScheduleCard(ffe: event, isDetail: true))
                      .toList(),
            )
            : Text('hello ufc',style: defaultTextStyle,),
      ],
    );
  }
}
