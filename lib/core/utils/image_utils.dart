class ImageUtils {
  static String fixImageUrl(String url) {
    return url
        .replaceFirst(
          'http://ia.media-imdb.com/',
          'https://m.media-amazon.com/',
        )
        .replaceAll('@..jpg', '@.V1.jpg');
  }
}
