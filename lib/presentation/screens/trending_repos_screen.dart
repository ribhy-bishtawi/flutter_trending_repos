import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/presentation/widgets/repo_card.dart';
import 'package:trending_repositories/utils/constants.dart';
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

  String _selectedTimeframe = 'day';

  void _onFilterChanged(String timeframe) {
    setState(() {
      _selectedTimeframe = timeframe;
    });
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton(
                  label: 'Last Day',
                  isSelected: _selectedTimeframe == 'day',
                  onTap: () => _onFilterChanged('day'),
                ),
                _buildFilterButton(
                  label: 'Last Week',
                  isSelected: _selectedTimeframe == 'week',
                  onTap: () => _onFilterChanged('week'),
                ),
                _buildFilterButton(
                  label: 'Last Month',
                  isSelected: _selectedTimeframe == 'month',
                  onTap: () => _onFilterChanged('month'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return RepoCard(repo: dummyRepo);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? Palette.primaryColor : Colors.grey[300],
          borderRadius: Constants.borderRadius8,
          border: Border.all(
            color: isSelected ? Palette.primaryColor : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Palette.whiteColor : Palette.header,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
