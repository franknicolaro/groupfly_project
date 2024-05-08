import 'package:firebase_storage/firebase_storage.dart';

//Service for retrieving images from FirebaseStorage.
class ImageStorageService{

  //Gets the URL for images from FirebaseStorage based on the reference provided.
  Future<String?> getImageUrlFromStorage(Reference ref) async{
    String? url;
    try{
      url = await ref.getDownloadURL();
    }
    catch(error){
      print('caught error trying to get downloadURL: $error');
      url = null;
    }
    return url;
  }
}