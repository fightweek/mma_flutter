import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';
import 'package:mma_flutter/fighter/component/fighter_card.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/user/model/user_profile_model.dart';
import 'package:mma_flutter/user/provider/user_profile_provider.dart';

class Footer extends ConsumerWidget {
  final StateBase<UserProfileModel> profileState;

  const Footer({required this.profileState, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (profileState is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final profile = profileState as StateData<UserProfileModel>;
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        width: 362.w,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 38.h, bottom: 10.h),
              child: SizedBox(
                height: 45.h,
                child: TabBar(
                  indicatorColor: BLUE_COLOR,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: GREY_COLOR,
                  tabs: const [Tab(text: '즐겨 찾는 선수'), Tab(text: '관심 있는 이벤트')],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.separated(
                    itemCount: profile.data!.alertFighters.length,
                    itemBuilder: (context, index) {
                      return _dismissibleWidget(
                        objectKey: ValueKey<FighterModel>(
                          profile.data!.alertFighters[index],
                        ),
                        onDismissed: (direction) {
                          ref
                              .read(userProfileProvider.notifier)
                              .deleteCard(
                                fighterCardToDelete:
                                    profile.data!.alertFighters[index],
                              );
                          ref
                              .read(fighterProvider.notifier)
                              .updatePreference(
                                model: UpdatePreferenceModel(
                                  targetId:
                                      profile.data!.alertFighters[index].id,
                                  on: false,
                                ),
                              );
                        },
                        cardToRemove: FighterCard(
                          fighter: profile.data!.alertFighters[index],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 11.h);
                    },
                  ),
                  ListView.separated(
                    itemCount: profile.data!.alertEvents.length,
                    itemBuilder: (context, index) {
                      return _dismissibleWidget(
                        objectKey: ValueKey<FighterFightEventModel>(
                          profile.data!.alertEvents[index],
                        ),
                        onDismissed: (direction) {
                          ref
                              .read(userProfileProvider.notifier)
                              .deleteCard(
                                fighterFightEventCardToDelete:
                                    profile.data!.alertEvents[index],
                              );
                          ref
                              .read(fightEventProvider.notifier)
                              .updatePreference(
                                model: UpdatePreferenceModel(
                                  targetId:
                                      profile.data!.alertEvents[index].eventId,
                                  on: false,
                                ),
                              );
                        },
                        cardToRemove: FighterFightEventCard(
                          ffe: profile.data!.alertEvents[index],
                          isFightEventCard: true,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 11.h);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dismissibleWidget({
    required ValueKey objectKey,
    required DismissDirectionCallback? onDismissed,
    required Widget cardToRemove,
  }) {
    return Dismissible(
      key: objectKey,
      background: Container(
        decoration: BoxDecoration(
          color: GREY_COLOR,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 12.w),
        child: Icon(Icons.delete_forever, color: WHITE_COLOR),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: cardToRemove,
    );
  }
}
