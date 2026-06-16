import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metadata_service.g.dart';

class LinkMetadata {
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? faviconUrl;

  LinkMetadata({
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.faviconUrl,
  });
}

/// Detects which social platform a URL belongs to.
enum SocialPlatform { twitter, instagram, threads, none }

SocialPlatform _detectPlatform(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return SocialPlatform.none;
  final host = uri.host.toLowerCase();
  if (host.contains('twitter.com') || host.contains('x.com')) return SocialPlatform.twitter;
  if (host.contains('instagram.com')) return SocialPlatform.instagram;
  if (host.contains('threads.net')) return SocialPlatform.threads;
  return SocialPlatform.none;
}

/// Extracts the profile name / username from a social URL.
/// Returns e.g. "@elonmusk" for profiles, or null for posts.
String? _extractSocialTitle(String url, SocialPlatform platform) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) return null;

  switch (platform) {
    case SocialPlatform.twitter:
      // twitter.com/username  OR  x.com/username
      // Ignore known non-profile paths
      const nonProfile = {'search', 'explore', 'notifications', 'messages', 'home', 'i', 'settings'};
      if (segments.length == 1 && !nonProfile.contains(segments[0].toLowerCase())) {
        return '@${segments[0]}';
      }
      // For tweet URLs like /username/status/123 → show @username's Tweet
      if (segments.length >= 2 && segments[1] == 'status') {
        return '@${segments[0]}\'s post';
      }
      return '@${segments[0]}';

    case SocialPlatform.instagram:
      // instagram.com/username  (profiles)
      // instagram.com/p/SHORTCODE (posts)
      // instagram.com/reel/SHORTCODE
      if (segments[0] == 'p' || segments[0] == 'reel' || segments[0] == 'tv') {
        return 'Instagram post';
      }
      if (segments.length == 1) {
        return '@${segments[0]}';
      }
      return '@${segments[0]}';

    case SocialPlatform.threads:
      // threads.net/@username  OR  threads.net/@username/post/ID
      final username = segments[0].startsWith('@') ? segments[0] : '@${segments[0]}';
      if (segments.length == 1) return username;
      if (segments.length >= 3 && segments[1] == 'post') {
        return '$username\'s post';
      }
      return username;

    case SocialPlatform.none:
      return null;
  }
}

/// Fixed favicons for known social platforms.
String? _platformFavicon(SocialPlatform platform) {
  switch (platform) {
    case SocialPlatform.twitter:
      return 'https://abs.twimg.com/favicons/twitter.3.ico';
    case SocialPlatform.instagram:
      return 'https://www.instagram.com/static/images/ico/favicon-192.png/68d99ba29cc8.png';
    case SocialPlatform.threads:
      return 'https://static.cdninstagram.com/rsrc.php/v3/yK/r/ATdOYNi1oFi.png';
    case SocialPlatform.none:
      return null;
  }
}

@riverpod
class MetadataService extends _$MetadataService {
  @override
  void build() {}

  Future<LinkMetadata?> fetchMetadata(String url) async {
    try {
      final platform = _detectPlatform(url);

      // ── Step 1: Try to get social metadata via microlink.io (free tier) ──
      // Microlink renders the page server-side, bypassing bot detection.
      if (platform != SocialPlatform.none) {
        final social = await _fetchViaMicrolink(url, platform);
        if (social != null) return social;
      }

      // ── Step 2: Standard HTML scraping for normal sites ──
      return await _fetchFromHtml(url, platform);
    } catch (e) {
      return null;
    }
  }

  /// Fetches metadata via the microlink.io free API.
  Future<LinkMetadata?> _fetchViaMicrolink(String url, SocialPlatform platform) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.microlink.io',
        queryParameters: {
          'url': url,
          'screenshot': false,
          'meta': true,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200) return null;
      final data = response.data;
      if (data == null || data['status'] != 'success') return null;

      final meta = data['data'] as Map<String, dynamic>?;
      if (meta == null) return null;

      // Try to get title from response, fallback to our social title extractor
      String title = meta['title'] as String? ?? '';
      if (title.isEmpty) {
        title = _extractSocialTitle(url, platform) ?? url;
      } else {
        // For profiles, prefer the @username format for conciseness
        final socialTitle = _extractSocialTitle(url, platform);
        if (socialTitle != null && _isProfileUrl(url, platform)) {
          title = '$socialTitle ($title)';
        }
      }

      final description = meta['description'] as String?;
      final image = (meta['image'] as Map<String, dynamic>?)?['url'] as String?;
      final logo = (meta['logo'] as Map<String, dynamic>?)?['url'] as String?;

      return LinkMetadata(
        title: title.trim(),
        description: description?.trim(),
        thumbnailUrl: image,
        faviconUrl: logo ?? _platformFavicon(platform),
      );
    } catch (_) {
      return null;
    }
  }

  bool _isProfileUrl(String url, SocialPlatform platform) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    switch (platform) {
      case SocialPlatform.twitter:
        return segments.length == 1;
      case SocialPlatform.instagram:
        return segments.length == 1 && !['p', 'reel', 'tv', 'stories'].contains(segments[0]);
      case SocialPlatform.threads:
        return segments.length == 1;
      case SocialPlatform.none:
        return false;
    }
  }

  /// Standard HTML scraping for non-social or fallback.
  Future<LinkMetadata?> _fetchFromHtml(String url, SocialPlatform platform) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
            'Accept-Language': 'en-US,en;q=0.9',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode != 200) {
        // For social sites where HTML fetch fails, return minimal metadata
        if (platform != SocialPlatform.none) {
          final socialTitle = _extractSocialTitle(url, platform);
          if (socialTitle != null) {
            return LinkMetadata(
              title: socialTitle,
              faviconUrl: _platformFavicon(platform),
            );
          }
        }
        return null;
      }

      final document = parser.parse(response.data);

      // Title — prefer OG title
      String? title = document.head
          ?.querySelector('meta[property="og:title"]')
          ?.attributes['content'];
      title ??= document.head?.querySelector('title')?.text;

      // For social platforms, extract clean profile name
      if (platform != SocialPlatform.none) {
        final socialTitle = _extractSocialTitle(url, platform);
        if (socialTitle != null) {
          // Use social title as primary; append og title if different and meaningful
          if (title != null && title.isNotEmpty && !title.toLowerCase().contains(socialTitle.toLowerCase().replaceAll('@', ''))) {
            title = '$socialTitle ($title)';
          } else {
            title = socialTitle;
          }
        }
      }

      title ??= url;

      // Description
      String? description = document.head
          ?.querySelector('meta[property="og:description"]')
          ?.attributes['content'];
      description ??= document.head
          ?.querySelector('meta[name="description"]')
          ?.attributes['content'];

      // Thumbnail
      String? thumbnail = document.head
          ?.querySelector('meta[property="og:image"]')
          ?.attributes['content'];

      // Favicon
      String? favicon = _platformFavicon(platform);
      if (favicon == null) {
        favicon = document.head
            ?.querySelector('link[rel="apple-touch-icon"]')
            ?.attributes['href'];
        favicon ??= document.head
            ?.querySelector('link[rel="icon"]')
            ?.attributes['href'];
        favicon ??= document.head
            ?.querySelector('link[rel="shortcut icon"]')
            ?.attributes['href'];

        if (favicon != null && !favicon.startsWith('http')) {
          final uri = Uri.parse(url);
          favicon = '${uri.scheme}://${uri.host}${favicon.startsWith('/') ? '' : '/'}$favicon';
        }
      }

      return LinkMetadata(
        title: title.trim(),
        description: description?.trim(),
        thumbnailUrl: thumbnail,
        faviconUrl: favicon,
      );
    } catch (e) {
      // Absolute fallback for social platforms
      if (platform != SocialPlatform.none) {
        final socialTitle = _extractSocialTitle(url, platform);
        if (socialTitle != null) {
          return LinkMetadata(
            title: socialTitle,
            faviconUrl: _platformFavicon(platform),
          );
        }
      }
      return null;
    }
  }
}
