import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService{
  final FirebaseStorage _storage = FirebaseStorage.instance;

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