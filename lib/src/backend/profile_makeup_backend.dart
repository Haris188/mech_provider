
import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend-methods.dart';

class ProfileMakeupBackend{
  static Map<String,dynamic> _profileMap;
  static String _providerUid;
  static bool _nameSubmitSuccess;
  static bool _locationSubmitSuccess;

  Future<bool> submitDataToDb(Map<String, dynamic> profile) async{
    _getProfileInfo(profile);
    await _getProviderId();
    await _submitNames();
    await _submitLocation();
    return _checkSubmitSuccess();
  }

  void _getProfileInfo(Map<String, dynamic> profile){
    _profileMap = profile;
  }

  Future<void> _getProviderId() async{
    _providerUid = await BackendMethods().getCurrentUid();
  }

  Future<void> _submitNames() async{
    await Firestore.instance.collection('provider_accounts')
      .document(_providerUid)
      .setData(_profileMap['names'])
      .whenComplete((){
        _nameSubmitSuccess = true;
      })
      .catchError((e){
        _nameSubmitSuccess = false;
        print('Cant submit names @ ProfileMakeupBackend > submitNames()');
        print(e);
      });
  }

  Future<void> _submitLocation() async{
    await Firestore.instance.collection('provider_accounts')
      .document(_providerUid)
      .collection('locations')
      .add(_profileMap['location'])
      .whenComplete((){
        _locationSubmitSuccess = true;
      })
      .catchError((e){
        _locationSubmitSuccess = false;
        print('Cant submit Location @ ProfileMakeupBackend > submitLocation()');
        print(e);
      });
  }

  bool _checkSubmitSuccess(){
    bool result;
    if(
      _nameSubmitSuccess &&
      _locationSubmitSuccess
    ){
      result = true;
    }
    else{
      result = false;
    }
    return result;
  }
}