class Post{
  String imageUrl;
  late String description;
  String postId;
  Post({required this.imageUrl, required this.postId, String description = ""});

  void setDescription(String newDescription){
    description = newDescription;
  }
}