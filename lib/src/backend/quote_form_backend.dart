import 'backend-methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteFormBackend{
  final String _requestId;
  static Map<String, dynamic> _location;
  static String _providerId;
  static Map<String, dynamic> _quoteMap;
  static bool _quoteSubmitResult;
  static bool _idSubmitResult;
  static bool _submitResult;

  QuoteFormBackend(this._requestId);

  Future<bool> submitData(Map<String, dynamic> quoteData) async{
    assignDataToQuoteMap(quoteData);
    await _getProviderLocation();
    await _getProviderId();
    _addMechIdToQuoteMap();
    await _submitDataToDb();
    await _submitReqIdToProviderAccount();
    _checkSubmitSuccess();
    return _submitResult;
  }

  void assignDataToQuoteMap(Map<String, dynamic> quoteData){
    _quoteMap = quoteData;
  }

  Future<void> _getProviderLocation() async{
    _location = await BackendMethods().getProviderLocation();
  }

  Future<void> _getProviderId() async{
    _providerId = await BackendMethods().getCurrentUid();
  }

  void _addMechIdToQuoteMap(){
    _quoteMap.addAll({'mech_id': _providerId});
  }

  Future<void> _submitDataToDb() async{
    await Firestore.instance.collection('requests')
      .document(_location['country'])
      .collection(_location['state'])
      .document(_location['city'])
      .collection('request_info')
      .document(_requestId)
      .collection('quotes')
      .document(_providerId)
      .setData(_quoteMap)
      .whenComplete((){
        _quoteSubmitResult = true;
      })
      .catchError((e){
        _quoteSubmitResult = false;
        print('Cant submit data@ QuoteFormBackend > submitDataToDb()');
        print(e);
      });
  }

  Future<void> _submitReqIdToProviderAccount() async{
    await Firestore.instance.collection('provider_accounts')
      .document(_providerId)
      .collection('quoted_requests')
      .document(_requestId)
      .setData({'id': _requestId})
      .whenComplete((){
        _idSubmitResult = true;
      })
      .catchError((e){
        _idSubmitResult = false;
        print('Cant submit ids @ QuoteFormBackend > submitReqIdToProviderAccount()');
        print(e);
      });
  }

  void _checkSubmitSuccess(){
    if(_idSubmitResult && _quoteSubmitResult){
      _submitResult = true;
    }
    else{
      _submitResult = false;
    }
  }
}