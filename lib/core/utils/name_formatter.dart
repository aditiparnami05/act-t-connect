/// Derives a readable display name from an email address.
abstract final class NameFormatter {
  static String fromEmail(String email) {
    final local = email.split('@').first.trim();
    if (local.isEmpty) return 'User';

    final cleaned = local.replaceAll(RegExp(r'[._\-\d]+'), ' ').trim();
    if (cleaned.isEmpty) return _capitalize(local);

    return cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(_capitalize)
        .join(' ');
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }
}
