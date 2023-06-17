class AppwriteConstants {
  static const String databaseId = "647a10c63c6aa98fe987";
  static const String projectId = "647a0d40cfbb3355626b";
  // static const String endPoint = "https://cloud.appwrite.io/v1";
  static const String endPoint = "http://192.168.0.100:80/v1";
  // static const String endPoint = "http://192.168.0.101:80/v1";
  // static const String endPoint = "http://localhost:80/v1";
  static const String userCollectionId = "647d759bcb166a04231f";
  static const String tweetsCollectionId = "64831aac3a66e98f61a3";
  static const String imagesBucket = "6486eca4b548b4eb17ba";
  static String imageUrl(String imageId) =>
      "$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin";
}
