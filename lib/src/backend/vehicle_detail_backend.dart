
import 'backend-methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDetailBackend{
  final String _requestId;
  static Map<String, dynamic> _location;
  static String _providerId;
  static Map<String, dynamic> _vehicleInfo;

  VehicleDetailBackend(this._requestId);

  Future<Map<String,dynamic>> getVehicleInfo() async{
    await _getProviderLocation();
    await _getProviderId();
    await _getVehicleInfoFromDb();
    return _vehicleInfo;
  }

  Future<void> _getProviderLocation() async{
    _location = await BackendMethods().getProviderLocation();
  }

  Future<void> _getProviderId() async{
    _providerId = await BackendMethods().getCurrentUid();
  }

  Future<void> _getVehicleInfoFromDb() async{
    await Firestore.instance.collection('requests')
      .document(_location['country'])
      .collection(_location['state'])
      .document(_location['city'])
      .collection('request_info')
      .document(_requestId)
      .collection('vehicle')
      .getDocuments()
      .then((docsSnap){
        _vehicleInfo = docsSnap.documents.first.data;
      })
      .catchError((e){
        print('Cant get Vehicles @ VehicleInfoBackend > getVehicleInfoFromDb()');
        print(e);
      });
  }
}