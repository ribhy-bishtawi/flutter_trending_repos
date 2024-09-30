import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trending_repositories/controller/repository_viewmodel.dart';
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
  TimeFilter _selectedTimeframe = TimeFilter.day;
  bool isLoading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repositoryViewModel =
          Provider.of<RepositoryViewmodel>(context, listen: false);
      await repositoryViewModel.getRepos(TimeFilter.day);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void _onFilterChanged(TimeFilter timeframe) {
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
        body: Consumer<RepositoryViewmodel>(builder: (BuildContext context,
            RepositoryViewmodel viewmodel, Widget? child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterButton(
                      label: 'Last Day',
                      isSelected: _selectedTimeframe == TimeFilter.day,
                      onTap: () async {
                        await viewmodel.getRepos(TimeFilter.day);
                        _onFilterChanged(TimeFilter.day);
                      },
                    ),
                    _buildFilterButton(
                        label: 'Last Week',
                        isSelected: _selectedTimeframe == TimeFilter.week,
                        onTap: () async {
                          await viewmodel.getRepos(TimeFilter.week);
                          _onFilterChanged(TimeFilter.week);
                        }),
                    _buildFilterButton(
                      label: 'Last Month',
                      isSelected: _selectedTimeframe == TimeFilter.month,
                      onTap: () async {
                        _onFilterChanged(TimeFilter.week);
                        await viewmodel.getRepos(TimeFilter.month);
                      },
                    ),
                  ],
                ),
              ),
              (viewmodel.isLoading || isLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: viewmodel.repos!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final repo = viewmodel.repos![index];

                          return RepoCard(repo: repo);
                        },
                      ),
                    ),
            ],
          );
        }));
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
