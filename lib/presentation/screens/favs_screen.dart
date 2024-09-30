import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trending_repositories/controller/repository_viewmodel.dart';
import 'package:trending_repositories/presentation/widgets/repo_card.dart';
import 'package:trending_repositories/utils/text_style.dart';

class FavoriteReposScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RepositoryViewmodel>(builder:
        (BuildContext context, RepositoryViewmodel viewmodel, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Favorite Repositories",
            style: AppTextStyle.headline,
          ),
        ),
        body: viewmodel.isLoading
            ? const CircularProgressIndicator()
            : viewmodel.favoriteRepos.isEmpty
                ? Center(
                    child: Text(
                    "No favorites added yet.",
                    style: AppTextStyle.headline,
                  ))
                : ListView.builder(
                    itemCount: viewmodel.favoriteRepos.length,
                    itemBuilder: (context, index) {
                      final repo = viewmodel.favoriteRepos[index];
                      return RepoCard(
                          repo: repo,
                          key: ObjectKey(viewmodel.favoriteRepos[index]));
                    },
                  ),
      );
    });
  }
}
