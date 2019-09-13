import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BackendMethods{
  static String _currentUid;

  Future<Map<String, dynamic>> getProviderLocation() async{
    Map<String, dynamic> locationMap;
    String currentUid = await getCurrentUid();

    await Firestore.instance.collection('provider_accounts')
      .document(currentUid)
      .collection('locations')
      .getDocuments()
      .then((docsSnap){
        locationMap = docsSnap.documents.first.data;
      })
      .catchError((e){
        print('Cant get location @ BackendMethods > getProviderLocation()');
        print(e);
      });
    return locationMap;
  }

  Future<String> getCurrentUid()async{

    await FirebaseAuth.instance.currentUser().then((user){
      _currentUid = user.uid;
    })
    .catchError((onError){
      print('cant fetch id @ BackendMethods > getCurrentUid');
      print(onError.toString());
    });

    return _currentUid;
  }
}