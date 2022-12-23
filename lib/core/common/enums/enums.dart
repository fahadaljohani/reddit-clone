enum ThemeMode {
  light,
  dart,
}

enum Karma {
  shareText(1),
  shareLink(2),
  shareImage(3),
  comment(2),
  awardPost(5),
  delete(-1);

  final int karma;
  const Karma(this.karma);
}
