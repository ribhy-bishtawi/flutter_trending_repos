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
  bool _isFilterVisible = false;
  final ScrollController _scrollController = ScrollController();
  int favCount = 0;
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    final viewmodel = Provider.of<RepositoryViewmodel>(context, listen: false);
    favCount = viewmodel.favoriteRepos.length;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewmodel.getRepos(TimeFilter.day);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !viewmodel.isLoading) {
        viewmodel.loadMoreRepos(_selectedTimeframe);
      }
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
    return Consumer<RepositoryViewmodel>(builder:
        (BuildContext context, RepositoryViewmodel viewmodel, Widget? child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "Trending Repositories",
              style: AppTextStyle.headline,
            ),
            forceMaterialTransparency: true,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  setState(() {
                    _isFilterVisible = !_isFilterVisible;
                  });
                },
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: Palette.iconColor,
                  size: Constants.iconSizeWidth30,
                )),
            actions: [
              Stack(
                children: [
                  IconButton.filledTonal(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Palette.red), // Button color
                    ),
                    color: Palette.whiteColor, // Icon color
                    onPressed: () {
                      Navigator.pushNamed(context, '/fav');
                    },
                    icon: const Icon(Icons.favorite_border),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${viewmodel.favoriteRepos.length}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: _isFilterVisible,
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchQueryController,
                        onChanged: (query) {
                          viewmodel.searchRepos(query);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search repositories...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                      Constants.gapH16,
                      Wrap(
                        spacing: 8.0.w,
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
                              _onFilterChanged(TimeFilter.month);
                              await viewmodel.getRepos(TimeFilter.month);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              (viewmodel.isLoading && viewmodel.filteredRepos.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: viewmodel.filteredRepos.length +
                            (viewmodel.isLoading ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == viewmodel.filteredRepos.length &&
                              viewmodel.isLoading) {
                            return Center(
                              child: viewmodel.isLoading
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.h),
                                      child: const CircularProgressIndicator(),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          }

                          final repo = viewmodel.filteredRepos[index];
                          return RepoCard(
                              repo: repo,
                              key: ObjectKey(viewmodel.filteredRepos[index]));
                        },
                      ),
                    ),
            ],
          ));
    });
  }

  Widget _buildFilterButton(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: () {
        onTap();
      },
      style: OutlinedButton.styleFrom(
        minimumSize: Size(50.w, 30.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        backgroundColor: isSelected ? Palette.primaryColor : null,
        side: BorderSide(
          color: isSelected ? Palette.primaryColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: isSelected ? Palette.whiteColor : Palette.blackColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
