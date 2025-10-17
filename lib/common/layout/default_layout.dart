import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/admin/common_update_screen.dart';
import 'package:mma_flutter/admin/news/screen/news_upload_screen.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/search/screen/search_screen.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/screen/setting_screen.dart';

class DefaultLayout extends ConsumerWidget {
  final BottomNavigationBar? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget child;
  final Color? backGroundColor;
  final bool? resizeToAvoidBottomInset;

  const DefaultLayout({
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backGroundColor,
    this.resizeToAvoidBottomInset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      drawer:
          user is UserModel && bottomNavigationBar?.currentIndex == 0
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
                              builder: (_) => RankingUpdateScreen(),
                            ),
                          );
                        },
                        title: Text('랭킹 업데이트 / 실시간 채팅방 활성화 / 차후 이벤트 업데이트'),
                      ),
                  ],
                ),
              )
              : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: renderAppBar(user, context, bottomNavigationBar),
      backgroundColor: backGroundColor ?? BLACK_COLOR,
      body: child,
    );
  }

  PreferredSize renderAppBar(
    UserModelBase? user,
    BuildContext context,
    BottomNavigationBar? bottomNavigationBar,
  ) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return PreferredSize(
      preferredSize: Size.fromHeight(56.h),
      child: AppBar(
        title:
            bottomNavigationBar?.currentIndex == 0 || canPop
                ? null
                : Text(
                  'FIGHT WEEK',
                  style: defaultTextStyle.copyWith(
                    fontFamily: 'Dalmation',
                    fontSize: 16.sp,
                  ),
                ),
        iconTheme: IconThemeData(color: WHITE_COLOR),
        backgroundColor: BLACK_COLOR,
        actions:
            user is UserModel
                ? [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  bottomNavigationBar?.currentIndex == 3
                                      ? SettingScreen()
                                      : SearchScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      bottomNavigationBar?.currentIndex == 3
                          ? Icons.settings
                          : Icons.search,
                    ),
                  ),
                ]
                : null,
      ),
    );
  }
}
