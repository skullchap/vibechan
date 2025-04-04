import 'package:vibechan/features/fourchan/domain/models/generic_list_item.dart'; // Path to GenericListItem
import 'package:vibechan/features/reddit/domain/models/reddit_post.dart';

extension RedditPostAdapter on RedditPost {
  GenericListItem toGenericListItem() {
    // Determine media type based on available data
    MediaType mediaType = MediaType.none;
    String? finalMediaUrl = url;
    String? displayUrl =
        url; // URL to display (might be different from media URL)

    // Basic check: Reddit often links directly to images/gifs or pages
    // More sophisticated checks (e.g., for specific domains like imgur, gfycat) could be added.
    // isVideo is a hint, but the actual URL might be needed for playback
    final isDirectImage =
        url != null &&
        (url!.endsWith('.jpg') ||
            url!.endsWith('.png') ||
            url!.endsWith('.gif') ||
            url!.endsWith('.jpeg'));
    final isDirectVideoHint = isVideo; // Using the hint from Reddit API

    if (isDirectVideoHint) {
      mediaType = MediaType.video;
      // finalMediaUrl might need adjustment based on Reddit's video hosting later
    } else if (isDirectImage) {
      mediaType = MediaType.image;
    } else if (selftext.isEmpty && url != null) {
      // If no selftext, the URL is likely the main content (link post)
      // Keep mediaType as none, but use displayUrl.
    } else {
      // Self-post or complex link, clear displayUrl if it's same as permalink
      if (displayUrl == fullPermalink) {
        displayUrl = null;
      }
    }

    // Populate metadata map
    final metadata = <String, dynamic>{
      'score': score,
      'numComments': numComments,
      'author': author,
      'subreddit': subreddit, // Include subreddit name
      'isStickied': stickied,
      'isOver18': over18,
      'linkFlairText': linkFlairText,
      'authorFlairText': authorFlairText,
      'domain':
          (displayUrl != null && Uri.tryParse(displayUrl)?.hasAuthority == true)
              ? Uri.parse(displayUrl).host
              : null, // Extract domain for link posts
      'permalink': permalink, // Include permalink for navigation/sharing
      'displayUrl': displayUrl, // URL to display for link posts
    };

    return GenericListItem(
      id: id, // Use Reddit post ID
      source: ItemSource.reddit,
      title: title,
      // Use selftext as body, could potentially render Markdown later
      body: selftext,
      // Use Reddit's thumbnail, fallback needed if it's 'self', 'default' etc.
      thumbnailUrl:
          (thumbnail != null && thumbnail!.startsWith('http'))
              ? thumbnail
              : null,
      mediaUrl:
          (mediaType != MediaType.none)
              ? finalMediaUrl
              : null, // Only set mediaUrl if it's direct media
      mediaType: mediaType, // Use the determined media type
      timestamp: createdDateTime, // Use the converted DateTime
      metadata: metadata, // Attach collected metadata
      originalData: this, // Store the original post object
    );
  }
}
