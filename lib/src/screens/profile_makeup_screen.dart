import 'package:flutter/material.dart';
import 'package:mech_provider/src/screens/main_screen.dart';
import '../backend/profile_makeup_backend.dart';

class ProfileMakeupScreen extends StatefulWidget {
  @override
  _ProfileMakeupScreenState createState() => _ProfileMakeupScreenState();
}

class _ProfileMakeupScreenState extends State<ProfileMakeupScreen> {
  static Map<String, dynamic> _profileInfoMap = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final TextEditingController _mechNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createProfileMakeupScreen(),
    );
  }

  Widget _createProfileMakeupScreen(){
    return Container(
      child: _createProfileListView(),
    );
  }

  Widget _createProfileListView(){
    return ListView(
      children: <Widget>[
        _createProfileForm()
      ],
    );
  }

  Widget _createProfileForm(){
    return Form(
      key: _formKey,
      child: _createFormFieldColumn(),
    );
  }

  Widget _createFormFieldColumn(){
    return Column(
      children: <Widget>[
        _createMechNameField(),
        _createBusinessNameField(),
        _createStateField(),
        _createCityField(),
        _createPhoneField(),
        _createSubmitButton()
      ],
    );
  }

  Widget _createMechNameField(){
    return TextFormField(
      controller: _mechNameController,
      decoration: InputDecoration(
        labelText: 'Your Name',
        hintText: 'John Smith'
      ),
      validator: (value){ return _nullValidateCheck(value);},
    );
  }

  Widget _createBusinessNameField(){
    return TextFormField(
      controller: _businessNameController,
      decoration: InputDecoration(
        labelText: 'Your Business Name',
        hintText: 'Car Parts Inc'
      ),
      validator: (value){ return _nullValidateCheck(value);},
    );
  }

  Widget _createStateField(){
    return TextFormField(
      controller: _stateController,
      decoration: InputDecoration(
        labelText: 'State',
        hintText: 'ON'
      ),
      validator: (value){ return _nullValidateCheck(value);},
    );
  }

  Widget _createCityField(){
    return TextFormField(
      controller: _cityController,
      decoration: InputDecoration(
        labelText: 'City',
        hintText: 'Toronto'
      ),
      validator: (value){ return _nullValidateCheck(value);},
    );
  }

  Widget _createPhoneField(){
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Your Contact Number'
      ),
      validator: (value){ return _nullValidateCheck(value);},
    );
  }

  String _nullValidateCheck(String value){
    if(value.length < 1){
      return 'Please Enter a Value';
    }
    else {
      return null;
    }
  }

  Widget _createSubmitButton(){
    return RaisedButton(
      child: _getButtonText(),
      onPressed:(){ _whenSubmitPressed();},
    );
  }

  Text _getButtonText(){
    return Text('Submit');
  }

  Future<void> _whenSubmitPressed() async{
    bool validateResult = _formKey.currentState.validate();
    if(validateResult){
      _prepareLocationMap();
      _prepareNamesMap();
      await _submitToDb();
    }
  }

  void _prepareLocationMap(){
    _profileInfoMap = {
      'location': {
        'country' : 'canada',
        'state' : _stateController.text,
        'city': _cityController.text,
        'phone' : _phoneController.text,
      }
    };
  }

  void _prepareNamesMap(){
    _profileInfoMap.addAll({
      'names' : {
        'name' : _mechNameController.text,
        'business_name' : _businessNameController.text
      }
    });
  }

  Future<void> _submitToDb() async{
    bool submitResult;
    
    submitResult = await ProfileMakeupBackend().submitDataToDb(_profileInfoMap);
    if(submitResult){
      _navigateToMainScreen();
    }
  }

  void _navigateToMainScreen(){
    MaterialPageRoute route = _getMainScreenRoute();
    Navigator.push(context, route);
  }

  MaterialPageRoute _getMainScreenRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        return MainScreen();
      }
    );
  }
}