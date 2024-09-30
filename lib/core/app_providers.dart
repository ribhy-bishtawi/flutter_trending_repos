import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trending_repositories/controller/repository_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RepositoryViewmodel()),
      ],
      child: child,
    );
  }
}
