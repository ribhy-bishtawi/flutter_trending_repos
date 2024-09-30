class Repository {
  final String name;
  final String ownerName;
  final String? avatarUrl;
  final String? description;
  final int starCount;
  final String? language;
  final int forksCount;
  final DateTime createdAt;
  final String htmlUrl;

  Repository(
      {required this.name,
      required this.ownerName,
      required this.avatarUrl,
      required this.description,
      required this.starCount,
      required this.language,
      required this.forksCount,
      required this.createdAt,
      required this.htmlUrl});

  factory Repository.fromMap(Map<String, dynamic> map) {
    return Repository(
      name: map['name'] ?? '',
      ownerName: map["owner"]['login'] ?? '',
      avatarUrl: map['owner']['avatar_url'],
      description: map['description'],
      starCount: map['stargazers_count'] ?? 0,
      language: map['language'],
      forksCount: map['forks_count'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      htmlUrl: map['html_url'] ?? '',
    );
  }
}
