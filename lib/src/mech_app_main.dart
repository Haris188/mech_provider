import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/main_screen.dart';
import 'screens/profile_makeup_screen.dart';

class MechApp{

  static bool _uidAvailableInDb;
  final FirebaseUser _user;
  final BuildContext _context;

  MechApp(
    this._user, 
    this._context); 

  Future<Null> start() async{
    _uidAvailableInDb = await _checkDbForCurrentUid();
    if(_uidAvailableInDb){
      _navigateToScreenNamed('MainScreen');
    }
    else{
      _navigateToScreenNamed('ProfileMakeup');
    }
  }

  Future<bool> _checkDbForCurrentUid() async{
    try {
      bool result;

      DocumentSnapshot snap = await Firestore.instance
      .collection('provider_accounts')
      .document(_user.uid).get();
      if(snap.data == null){
        result = false;
      }
      else{
        result = true;
      }
      return result;
    } 
    catch (e) {
      print('couldnt read db @ MechApp > checkDbForCurrentUid');
      return false;
    }
  }

  void _navigateToScreenNamed(String screen){
    MaterialPageRoute route;
    if(screen == 'MainScreen'){
      route = _getMainScreenRoute();
    }
    else if(screen == 'ProfileMakeup'){
      route = _getProfileMakeupRoute();
    }
    if(route != null){
      Navigator.push(_context, route);
    }
  }

  MaterialPageRoute _getMainScreenRoute(){
    return MaterialPageRoute(
      builder: (_context){
        return MainScreen();
      }
    );
  }

  MaterialPageRoute _getProfileMakeupRoute(){
    return MaterialPageRoute(
      builder: (_context){
        return ProfileMakeupScreen();
      }
    );
  }
}