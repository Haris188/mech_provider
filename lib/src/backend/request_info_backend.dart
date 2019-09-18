
import 'backend-methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestInfoBackend{
  static String _requestId;
  static Map<String, dynamic> _quoteMap;
  static Map<String, dynamic> _location;
  static String _providerId;
  static bool _isMsgAvailable;

  Future<Map<String, dynamic>> getQuoteInfoForReqId(String reqId) async{
    await _setParametersFor(reqId);
    await _getQuoteMap();    
    return _quoteMap;
  }

  Future<bool> checkMsgAvailable(reqId) async{
    await _setParametersFor(reqId);
    await _checkMsgNull();
    return _isMsgAvailable;
  }

  Future<void> _setParametersFor(reqId) async{
    _setRequestId(reqId);
    await _getProviderLocation();
    await _getProviderId();
  }

  void _setRequestId(String reqId){
    _requestId = reqId;
  }

  Future<void> _getProviderLocation() async{
    _location = await BackendMethods().getProviderLocation();
  }

  Future<void> _getProviderId() async{
    _providerId = await BackendMethods().getCurrentUid();
  }

  Future<void> _getQuoteMap() async{
    await Firestore.instance.collection('requests')
      .document(_location['country'])
      .collection(_location['state'])
      .document(_location['city'])
      .collection('request_info')
      .document(_requestId)
      .collection('quotes')
      .document(_providerId)
      .get()
      .then((docSnap){
        _quoteMap = docSnap.data;
      })
      .catchError((e){
        print('Cant get quotes @ RequestInfoBackend > getQuoteMap()');
        print(e);
      });
  }

  Future<void> _checkMsgNull() async{
    await Firestore.instance.collection('requests')
      .document(_location['country'])
      .collection(_location['state'])
      .document(_location['city'])
      .collection('request_info')
      .document(_requestId)
      .collection('quotes')
      .document(_providerId)
      .collection('chat')
      .getDocuments()
      .then((docSnap){
        if(docSnap.documents == null){
          _isMsgAvailable = false;
        }
        else{
          _isMsgAvailable = true;
        }
      })
      .catchError((e){
        print('Cant get messages @ RequestInfoBackend > checkMsgNull()');
        print(e);
      });
  }
}