

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend-methods.dart';

class RequestListingBackend{
  static String _screenType;
  static List<Map<String, dynamic>> _requests;
  static Map<String, dynamic> _locationMap;
  static String _providerId;

  Future<List<Map<String, dynamic>>> getRequestsFromDbFor(String screenType) async{
    _assignScreenType(screenType);
    await _getProviderLocation();
    await _fetchRequests();
    print(_requests);
    return _requests;
  }

  void _assignScreenType(String scrType){
    _screenType = scrType;
  }


  Future<void> _getProviderLocation() async{
    _locationMap = await BackendMethods().getProviderLocation();
    print(_locationMap);
  }

  Future<void> _getProviderId() async{
    _providerId = await BackendMethods().getCurrentUid();
  }
  
  Future<void> _fetchRequests() async{
    if(_screenType == 'incomming'){
      await _fetchIncommingRequests();
    }
    else if(_screenType == 'quoted'){
      await _fetchQuotedRequests();
    }
    else if(_screenType == 'accepted'){
      await _fetchAcceptedRequests();
    }
  }

  Future<void> _fetchIncommingRequests() async{
    Duration duration = Duration(seconds: 5);
    await Firestore.instance.collection('requests')
      .document(_locationMap['country'])
      .collection(_locationMap['state'])
      .document(_locationMap['city'])
      .collection('request_info')
      .getDocuments()
      .then((docSnap){
        _requests = docSnap.documents.map<Map<String, dynamic>>((docSnap){
          if(docSnap.data['status'] == 'open'){
            return docSnap.data;
          }
        }).toList();
        _requests.removeWhere((req){
          return (req == null);
        });
      })
      .timeout(duration, onTimeout: (){
        _requests = [{'result' : 'timeout'}];
      })
      .catchError((e){
        print('Cant fetch Requests @ RequestListingBackend > fetchIncommingRequests()');
        print(e);
        _requests = [{'result': false}];
      });
  }

  Future<void> _fetchAcceptedRequests() async{
    Duration duration = Duration(seconds: 5);
    List<String> acceptedIds = await _getAcceptedIds();
    await Firestore.instance.collection('requests')
      .document(_locationMap['country'])
      .collection(_locationMap['state'])
      .document(_locationMap['city'])
      .collection('request_info')
      .getDocuments()
      .then((docSnap){
        _requests = docSnap.documents.map<Map<String, dynamic>>((docSnap){
          if(acceptedIds.contains(docSnap.data['request_id'])){
            return docSnap.data;
          }
        }).toList();
         _requests.removeWhere((req){
          return (req == null);
        });
      })
      .timeout(duration, onTimeout: (){
        _requests = [{'result' : 'timeout'}];
      })
      .catchError((e){
        print('Cant fetch Requests @ RequestListingBackend > fetchAcceptedRequests()');
        print(e);
        _requests = [{'result': false}];
      });
  }

  Future<List<String>> _getAcceptedIds() async{
    List<String> idsList;
    await _getProviderId();
    await Firestore.instance.collection('provider_accounts')
      .document(_providerId)
      .collection('accepted_requests')
      .getDocuments()
      .then((docsSnap){
        idsList = docsSnap.documents.map<String>((docSnap){
          return docSnap.data['id'];
        }).toList();
      })
      .catchError((e){
        print('Cant fetch Ids @ RequestListingBackend > getAcceptedIds()');
        print(e);
      });
      return idsList;
  }

    Future<void> _fetchQuotedRequests() async{
      Duration duration = Duration(seconds: 5);
    List<String> acceptedIds = await _getQuotedIds();
    await Firestore.instance.collection('requests')
      .document(_locationMap['country'])
      .collection(_locationMap['state'])
      .document(_locationMap['city'])
      .collection('request_info')
      .getDocuments()
      .then((docSnap){
        _requests = docSnap.documents.map<Map<String, dynamic>>((docSnap){
          if(acceptedIds.contains(docSnap.data['request_id'])){
            return docSnap.data;
          }
        }).toList();
         _requests.removeWhere((req){
          return (req == null);
        });
      })
      .timeout(duration, onTimeout: (){
        _requests = [{'result' : 'timeout'}];
      })
      .catchError((e){
        print('Cant fetch Requests @ RequestListingBackend > fetchQuotedRequests()');
        print(e);
        _requests = [{'result': false}];
      });
  }

  Future<List<String>> _getQuotedIds() async{
    List<String> idsList;
    await _getProviderId();
    await Firestore.instance.collection('provider_accounts')
      .document(_providerId)
      .collection('quoted_requests')
      .getDocuments()
      .then((docsSnap){
        idsList = docsSnap.documents.map<String>((docSnap){
          print('I am here');
          return docSnap.data['id'];
        }).toList();
      })
      .catchError((e){
        print('Cant fetch Ids @ RequestListingBackend > getQuotedIds()');
        print(e);
      });
      return idsList;
  }
}