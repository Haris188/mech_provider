
import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend-methods.dart';

class RequestListingBackend{
  static String _screenType;
  static List<Map<String, dynamic>> _requests;
  static Map<String, dynamic> _locationMap;

  Future<List<Map<String, dynamic>>> getRequestsFromDbFor(String screenType) async{
    _assignScreenType(screenType);
    await _getProviderLocation();
    await _fetchRequests();
    return _requests;
  }

  void _assignScreenType(String scrType){
    _screenType = scrType;
  }


  Future<void> _getProviderLocation() async{
    _locationMap = await BackendMethods().getProviderLocation();
    print(_locationMap);
  }
  
  Future<void> _fetchRequests() async{
    if(_screenType == 'incomming'){
      await _fetchIncommingRequests();
    }
  }

  Future<void> _fetchIncommingRequests() async{
    await Firestore.instance.collection('requests')
      .document(_locationMap['country'])
      .collection(_locationMap['state'])
      .document(_locationMap['city'])
      .collection('request_info')
      .getDocuments()
      .then((docSnap){
        _requests = docSnap.documents.map<Map<String, dynamic>>((docSnap){
          return docSnap.data;
        }).toList();
      })
      .catchError((e){
        print('Cant fetch Requests @ RequestListingBackend > fetchIncommingRequests()');
        print(e);
        _requests = [{'result': false}];
      });
  }
}