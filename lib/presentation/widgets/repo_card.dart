import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/utils/constants.dart';
import 'package:trending_repositories/utils/palette.dart';
import 'package:trending_repositories/utils/text_style.dart';

class RepoCard extends StatefulWidget {
  final Repository repo;

  const RepoCard({required this.repo, super.key});

  @override
  State<RepoCard> createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  late Repository repo;
  bool isFavored = false;
  @override
  void initState() {
    repo = widget.repo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 3,
        color: Palette.whiteColor,
        margin: Constants.marginVertical8Horizontal16,
        child: Stack(
          children: [
            Padding(
              padding: Constants.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: repo.avatarUrl ??
                              'https://api.dicebear.com/9.x/big-smile/svg?seed=${repo.ownerName}',
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                              child: SizedBox(
                                  width: 30.w,
                                  height: 30.w,
                                  child: const CircularProgressIndicator())),
                        ),
                      ),
                      Constants.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 40.w),
                              child: Text(
                                repo.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.primaryText,
                              ),
                            ),
                            Constants.gapH8,
                            Text(
                              repo.description ?? "No description available ",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.secondaryText,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Palette.text,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "@${repo.ownerName}",
                        style:
                            AppTextStyle.primaryText.copyWith(fontSize: 16.sp),
                      ),
                      Row(
                        children: [
                          Text(repo.starCount.toString(),
                              style: AppTextStyle.secondaryText),
                          Constants.gapW4,
                          Image.asset(
                            'assets/images/star_icon.png',
                            width: 25.w,
                            height: 20.h,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              right: -10.w,
              top: -10.h,
              child: IconButton(
                icon: Image.asset(
                  isFavored
                      ? 'assets/images/bookmark_filled.png'
                      : 'assets/images/bookmark.png',
                  width: 30.w,
                  height: 30.w,
                ),
                onPressed: () {
                  setState(() {
                    isFavored = !isFavored;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
