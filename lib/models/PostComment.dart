//PostComment model, used to structure and retrieve data easier in Post Repository.
class PostComment{
  String text;
  String user_uid;
  String username;

  PostComment({required this.text, required this.user_uid, required this.username});
}