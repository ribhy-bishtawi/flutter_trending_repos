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
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner': {
        'login': ownerName,
        'avatar_url': avatarUrl,
      },
      'description': description,
      'stargazers_count': starCount,
      'language': language,
      'forks_count': forksCount,
      'created_at': createdAt.toIso8601String(),
      'html_url': htmlUrl,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Repository) return false;

    return name == other.name &&
        ownerName == other.ownerName &&
        avatarUrl == other.avatarUrl &&
        description == other.description &&
        starCount == other.starCount &&
        language == other.language &&
        forksCount == other.forksCount &&
        createdAt == other.createdAt &&
        htmlUrl == other.htmlUrl;
  }
}
