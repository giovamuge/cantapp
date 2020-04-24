class YouTubeModel {
  String version;
  String authorName;
  String authorUrl;
  String providerName;
  String providerUrl;
  int width;
  int height;
  String html;
  String type;
  int thumbnailHeight;
  int thumbnailWidth;
  String thumbnailUrl;
  String title;

  YouTubeModel.formMap(Map maps)
      : version = maps["version"],
        authorName = maps["author_name"],
        authorUrl = maps["author_url"],
        providerName = maps["provider_name"],
        providerUrl = maps["provider_url"],
        width = maps["width"],
        height = maps["height"],
        thumbnailWidth = maps["thumbnail_Width"],
        thumbnailHeight = maps["thumbnail_height"],
        thumbnailUrl = maps["thumbnail_url"],
        html = maps["html"],
        type = maps["type"],
        title = maps["title"];

  toJson() {
    return {
      "version": version,
      "author_name": authorName,
      "author_url": authorUrl,
      "provider_name": providerName,
      "provider_url": providerUrl,
      "width": width,
      "height": height,
      "thumbnail_Width": thumbnailWidth,
      "thumbnail_height": thumbnailHeight,
      "thumbnail_url": thumbnailUrl,
      "html": html,
      "type": type,
      "title": title
    };
  }
}
