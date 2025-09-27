import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mma_flutter/admin/news/repository/admin_news_repository.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/input_label.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/screen/root_tab.dart';

class NewsUploadScreen extends ConsumerStatefulWidget {
  static String get routeName => 'news_upload';

  const NewsUploadScreen({super.key});

  @override
  ConsumerState<NewsUploadScreen> createState() => _NewsUploadScreenState();
}

class _NewsUploadScreenState extends ConsumerState<NewsUploadScreen> {
  final picker = ImagePicker();
  String source = newsSources.first;
  String type = newsTypes.first;
  String? title, content;
  List<XFile?> imagesToSelect = List.filled(4, null);
  List<XFile?> imagesToShow = List.filled(4, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                // child 위젯의 크기를 정해주지 않은 경우 true로 지정해야 함
                children: [
                  imagesToShow[0] == null
                      ? _renderContainer(index: 0)
                      : _renderImage(index: 0),
                  imagesToShow[1] == null
                      ? _renderContainer(index: 1)
                      : _renderImage(index: 1),
                  imagesToShow[2] == null
                      ? _renderContainer(index: 2)
                      : _renderImage(index: 2),
                  imagesToShow[3] == null
                      ? _renderContainer(index: 3)
                      : _renderImage(index: 3),
                ],
              ),
              InputLabel(
                title: '제목',
                textStyle: defaultTextStyle.copyWith(color: Colors.black),
              ),
              AuthTextFormField(
                onChanged: (val) {
                  title = val;
                },
                textStyle: defaultTextStyle.copyWith(color: Colors.black),
              ),
              InputLabel(
                title: '내용',
                textStyle: defaultTextStyle.copyWith(color: Colors.black),
              ),
              AuthTextFormField(
                onChanged: (val) {
                  content = val;
                },
                textStyle: defaultTextStyle.copyWith(color: Colors.black),
              ),
              InputLabel(
                title: '출처',
                textStyle: defaultTextStyle.copyWith(color: Colors.black),
              ),
              _renderDropDownButton(source, newsSources),
              if (source == newsSources.last)
                AuthTextFormField(
                  onChanged: (val) {},
                  textStyle: defaultTextStyle.copyWith(color: Colors.black),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 16.0),
                child: OutlinedButton(
                  onPressed: () async {
                    if (title == null ||
                        title!.isEmpty ||
                        content == null ||
                        content!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('제목, 내용 모두 빠짐 없이 입력하셈')),
                      );
                    } else {
                      final validFiles =
                          imagesToShow.whereType<XFile>().toList();
                      final multipartFiles = await Future.wait(
                        validFiles.map((xfile) {
                          return MultipartFile.fromFile(
                            xfile.path,
                            filename: xfile.name,
                          );
                        }),
                      );
                      await ref
                          .read(adminNewsRepositoryProvider)
                          .save(
                            title: title!,
                            content: content!,
                            source: source,
                            files: multipartFiles,
                          );
                      context.goNamed(RootTab.routeName);
                    }
                  },
                  child: Text('업로드'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderContainer({required int index}) {
    return Stack(
      children: [
        Container(color: Colors.white),
        IconButton(
          onPressed: () async {
            imagesToSelect[index] = await picker.pickImage(
              source: ImageSource.gallery,
            );
            print('selectedImages = $imagesToSelect');
            setState(() {
              imagesToShow[index] = imagesToSelect[index];
            });
          },
          icon: Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.lightBlueAccent,
          ),
        ),
      ],
    );
  }

  _renderImage({required int index}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            image: DecorationImage(
              image: FileImage(File(imagesToShow[index]!.path)),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          //삭제 버튼
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(Icons.close, color: Colors.white, size: 15),
            onPressed: () {
              //버튼을 누르면 해당 이미지가 삭제됨
              setState(() {
                imagesToShow[index] = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _renderDropDownButton(String target, List<String> targetCategories) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
      child: DropdownButton(
        value: target == type ? type : source,
        items:
            targetCategories
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),
        onChanged: (value) {
          setState(() {
            if (target == type) {
              type = value!;
            } else {
              source = value!;
            }
          });
        },
      ),
    );
  }
}
