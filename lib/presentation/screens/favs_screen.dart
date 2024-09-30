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
        body: Column(
          children: [
            if (viewmodel.favoriteRepos.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (query) {
                    viewmodel.searchFavoriteRepos(query); // Filter favorites
                  },
                  decoration: InputDecoration(
                    hintText: 'Search favorites...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            // Favorite Repos List
            Expanded(
              child: viewmodel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewmodel.filteredFavoriteRepos.isEmpty
                      ? Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            viewmodel.favoriteRepos.isEmpty
                                ? "No favorites added yet."
                                : "No repositories found matching your search.",
                            style: AppTextStyle.headline,
                          ),
                        )
                      : ListView.builder(
                          itemCount: viewmodel.filteredFavoriteRepos.length,
                          itemBuilder: (context, index) {
                            final repo = viewmodel.filteredFavoriteRepos[index];
                            return RepoCard(
                              repo: repo,
                              key: ObjectKey(repo),
                            );
                          },
                        ),
            ),
          ],
        ),
      );
    });
  }
}
