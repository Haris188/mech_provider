
import 'package:flutter/material.dart';
import 'request_listing_screen.dart';

class MainScreen extends StatelessWidget {

  static BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: _buildMainScreen(),
    );
  }

  Widget _buildMainScreen(){
    return Column(
      children: <Widget>[
        _createInstructionsBlock(),
        _createMenu()
      ],
    );
  }

  Widget _createInstructionsBlock(){
    return Container(
      height: _getInstructionsBlockHeight(),
      color: Theme.of(_context).primaryColor,
      child: _createInstructionsColumn(),
    );
  }

  double _getInstructionsBlockHeight(){
    double screenHeight = MediaQuery.of(_context).size.height;
    double blockHeight = screenHeight / 1.6;
    return blockHeight;
  }

  Widget _createInstructionsColumn(){
    return Column(
      children: <Widget>[
        _createWelcomeMsg(),
        _createInstructionsMsg()
      ],
    );
  }

  Widget _createWelcomeMsg(){
    return Container(
      alignment: Alignment.centerLeft,
      height: _getWelcomeContainerHeight(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0
          ),
        child: Text(
          'Welcome To Mech_app',
          style: _getWelcomeTextStyle(),
        ),
      ),
    );
  }

  double _getWelcomeContainerHeight(){
    double screenHeight = MediaQuery.of(_context).size.height;
    double containerHeight = screenHeight / 3.5;
    return containerHeight;
  }

  TextStyle _getWelcomeTextStyle(){
    return TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold
    );
  }

  Widget _createInstructionsMsg(){
    return Expanded(
      child: _createInstructionsMsgSettings(),
    );
  }

  Widget _createInstructionsMsgSettings(){
    return Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(_context).accentColor,
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0, 
            right:15.0
            ),
          child: _getInstructionsTextColumn(),
        ),
    );
  }

  Widget _getInstructionsTextColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getHelloText(),
        _getSparePadding(5.0),
        _getInstructionsText()

      ],
    );
  }

  Widget _getHelloText(){
    return Text(
      'Hello!',
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
    );
  }

  Widget _getInstructionsText(){
    return Text(
      'This app is for Mechanics to see requests' +
      ' .To begin Select one' +
      ' of the options below',
      style: _getInstructionsTextStyle(),
    );
  }

  TextStyle _getInstructionsTextStyle(){
    return TextStyle(
      fontSize: 25.0,
      color: Colors.white,
      fontWeight: FontWeight.w300
    );
  }

  Widget _createMenu(){
    return Expanded(
          child: Container(
            color: Theme.of(_context).accentColor,
            child:  _createMenuItemsList(),
          ),
    );
  }

  Widget _createMenuItemsList(){
    return ListView(
      children: <Widget>[
        _createIncommingRequestTile(),
        _createQuotedRequestTile(),
        _createAcceptedRequestTile()
      ],
    );
  }

  Widget _createIncommingRequestTile(){
    return ListTile(
        title: _getAddTitleText(),
        onTap: (){
          _whenIncommingRequestPressed();
        },
      );
  }

  Widget _getAddTitleText(){
    return Text(
      'See Incomming Quote Requests',
      style: _getMenuListTextStyle(),
    );
  }

  void _whenIncommingRequestPressed(){
    Navigator.push(_context, _getIncommingRequestsRoute());
  }

  MaterialPageRoute _getIncommingRequestsRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        return RequestListingScreen('incomming');
      }
    );
  }

  Widget _createQuotedRequestTile(){
    return ListTile(
          title: _getQuotedTitleText(),
          onTap: (){
            _whenQuotedRequestPressed();
          },
        );
  }

  Widget _getQuotedTitleText(){
    return Text(
      'View Quoted Requests',
      style: _getMenuListTextStyle(),
    );
  }

  void _whenQuotedRequestPressed(){
    //Navigator.push(_context, _getActiveRoute());
  }

  MaterialPageRoute _getQuotedRequestsRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        //return RequestListingScreen('active');
      }
    );
  }

  Widget _createAcceptedRequestTile(){
    return ListTile(
          title: _getAcceptedTitleText(),
          onTap: (){
            _whenAcceptedRequestPressed();
          },
        );
  }

  Widget _getAcceptedTitleText(){
    return Text(
      'View Accepted Requests',
      style: _getMenuListTextStyle(),
    );
  }

  void _whenAcceptedRequestPressed(){
    //Navigator.push(_context, _getArchivedRoute());
  }

  MaterialPageRoute _getAccesptedRequestsRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        //return RequestListingScreen('archived');
      }
    );
  }


  TextStyle _getMenuListTextStyle(){
    return TextStyle(
      color: Colors.white
    );
  }

  Padding _getSparePadding(double amount){
    return Padding(
      padding: EdgeInsets.only(top: amount),
    );
  }




}