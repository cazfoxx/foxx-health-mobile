// string_extensions.dart

extension HashtagExtraction on String {
  /// Extracts a list of hashtags from the string.
  /// The regular expression looks for '#' followed by one or more
  /// word characters (letters, numbers, or underscore).
  ///
  /// Set [includeHash] to false to return tags without the '#' prefix.
  List<String> extractHashtags({bool includeHash = true}) {
    // Regex: r"#(\w+)" - Finds '#' followed by one or more word characters.
    final RegExp hashtagRegExp = RegExp(r"#(\w+)");

    // Find all matches in the string
    final Iterable<Match> matches = hashtagRegExp.allMatches(this);

    // Map the matches to a list of strings
    if (includeHash) {
      // m.group(0) returns the full match, e.g., "#flutter"
      return matches.map((m) => m.group(0)!).toList();
    } else {
      // m.group(1) returns the content of the first capturing group, e.g., "flutter"
      return matches.map((m) => m.group(1)!).toList();
    }
  }
}