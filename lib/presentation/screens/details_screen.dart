import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/utils/constants.dart';
import 'package:trending_repositories/utils/palette.dart';
import 'package:trending_repositories/utils/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoDetailScreen extends StatelessWidget {
  final Repository repo;

  const RepoDetailScreen({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repo.name, style: AppTextStyle.headline),
        centerTitle: true,
        forceMaterialTransparency: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(repo.avatarUrl ??
                      'https://api.dicebear.com/9.x/big-smile/svg?seed=${repo.ownerName}'),
                  radius: 40.r,
                ),
                Constants.gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(repo.ownerName, style: AppTextStyle.primaryText),
                      Constants.gapH8,
                      Text(repo.description ?? "No description available",
                          style: AppTextStyle.secondaryText),
                    ],
                  ),
                ),
              ],
            ),
            Constants.gapH16,
            const Divider(thickness: 1),
            if (repo.language != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: Text(
                  "Language: ${repo.language}",
                  style: AppTextStyle.secondaryText,
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Text(
                "Forks: ${repo.forksCount}",
                style: AppTextStyle.secondaryText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Text(
                "Stars: ${repo.starCount}",
                style: AppTextStyle.secondaryText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Text(
                "Created on: ${DateFormat.yMMMd().format(repo.createdAt)}",
                style: AppTextStyle.secondaryText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: OutlinedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(repo.htmlUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(50.w, 30.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Text(
                  "View on GitHub",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decorationColor: Colors.blue,
                    decorationThickness: 1.5,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
