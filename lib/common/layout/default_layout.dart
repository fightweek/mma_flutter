import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/admin/event/repository/admin_event_repository.dart';
import 'package:mma_flutter/admin/event/screen/upcoming_event_save_screen.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/admin/fighter/screen/ranking_update_screen.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class DefaultLayout extends ConsumerWidget {
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget child;
  final Color? backGroundColor;

  const DefaultLayout({
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backGroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return Scaffold(
      drawer:
          user is UserModel
              ? Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        print(user.role);
                      },
                      title: Text('게임'),
                    ),
                    if (user.role == 'ROLE_ADMIN')
                      ListTile(
                        onTap: () {
                          context.pushNamed(NewsUploadScreen.routeName);
                        },
                        title: Text('뉴스 업로드'),
                      ),
                    if (user.role == 'ROLE_ADMIN')
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UpcomingEventSaveScreen(),
                            ),
                          );
                        },
                        title: Text('차후 이벤트 업데이트'),
                      ),
                    if (user.role == 'ROLE_ADMIN')
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RankingUpdateScreen(),
                            ),
                          );
                        },
                        title: Text('랭킹 업데이트'),
                      ),
                  ],
                ),
              )
              : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: renderAppBar(),
      backgroundColor: backGroundColor ?? BACKGROUND_COLOR,
      body: child,
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      title: Image.asset('asset/img/logo/fight_week.png', width: 50),
      centerTitle: true,
    );
  }
}
