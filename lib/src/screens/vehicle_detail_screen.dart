
import 'package:flutter/material.dart';
import '../backend/vehicle_detail_backend.dart';

class VehicleDetailScreen extends StatelessWidget {
  static Map<String, dynamic> _vehicleInfo;
  final String _requestId;

  VehicleDetailScreen(this._requestId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildVehicleDetailScreen()
    );
  }

  Widget _buildVehicleDetailScreen(){
    return FutureBuilder(
      initialData: false,
      future: _getVehicleInfoFromDb(),
      builder: (BuildContext context, AsyncSnapshot<bool> resultSnap){
        if(resultSnap.data){
          return _createVehicleInfoListView();
        }
        else{
          return _sparePadding(8.0);
        }
      },
    );
  }

  Future<bool> _getVehicleInfoFromDb() async{
    _vehicleInfo = await VehicleDetailBackend(_requestId).getVehicleInfo();
    if(_vehicleInfo == null){
      return false;
    }
    else{
      print(_vehicleInfo);
      return true;
    }
  }

  Widget _createVehicleInfoListView(){
    print(_vehicleInfo);
    return Container(
      child: ListView(
        children: [
          _getListTileWith('Make', _vehicleInfo['make']),
          _getListTileWith('Model', _vehicleInfo['model']),
          _getListTileWith('Year', _vehicleInfo['year']),
          _getListTileWith('Trim', _vehicleInfo['trim']),
          _getListTileWith('Transmission', _vehicleInfo['transmission']),
          _getListTileWith('Fuel Type', _vehicleInfo['fuel_type']),
          _getListTileWith('Drivetrain', _vehicleInfo['drivetrain']),
          _getListTileWith('Mileage', _vehicleInfo['mileage']),
        ],
      ),
    );
  }

  Widget _getListTileWith(String title, String subtitle){
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _sparePadding(double value){
    return Padding(
      padding: EdgeInsets.all(value),
    );
  }
}