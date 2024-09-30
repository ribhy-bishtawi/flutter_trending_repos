import 'package:flutter/material.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/presentation/widgets/repo_card.dart';
import 'package:trending_repositories/utils/palette.dart';
import 'package:trending_repositories/utils/text_style.dart';

class TrendingReposScreen extends StatefulWidget {
  const TrendingReposScreen({super.key});

  @override
  State<TrendingReposScreen> createState() => _TrendingReposScreenState();
}

class _TrendingReposScreenState extends State<TrendingReposScreen> {
  final dummyRepo = Repository(
    name: 'AzEnglish',
    ownerName: 'ribhi_bishtawi',
    avatarUrl:
        'https://gravatar.com/avatar/48413b0e4ab8e14df02a6193ecfe887b?s=400&d=robohash&r=x4',
    description:
        'A framework for building natively compiled apps A framework for building natively compiled apps',
    starCount: 12345,
    language: 'Dart',
    forksCount: 678,
    createdAt: DateTime.now(),
    htmlUrl: 'https://github.com/flutter/flutter',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Trending Repositories",
            style: AppTextStyle.headline,
          ),
        ),
        backgroundColor: Palette.primaryColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite,
                color: Palette.whiteColor,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return RepoCard(repo: dummyRepo);
        },
      ),
    );
  }
}
