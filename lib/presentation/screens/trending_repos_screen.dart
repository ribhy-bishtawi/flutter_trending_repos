import 'package:flutter/material.dart';
import 'package:trending_repositories/utils/palette.dart';
import 'package:trending_repositories/utils/text_style.dart';

class TrendingReposScreen extends StatefulWidget {
  const TrendingReposScreen({super.key});

  @override
  State<TrendingReposScreen> createState() => _TrendingReposScreenState();
}

class _TrendingReposScreenState extends State<TrendingReposScreen> {
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
      body: const Center(
        child: Text("Cards"),
      ),
    );
  }
}
