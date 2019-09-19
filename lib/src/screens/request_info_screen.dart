import 'attachment_screen.dart';
import 'package:flutter/material.dart';
import '../backend/request_info_backend.dart';
import 'vehicle_detail_screen.dart';
import 'quote_form_screen.dart';
import 'chat_screen.dart';

class RequestInfoScreen extends StatelessWidget {
  final Map<String, dynamic> _request;
  final String _screenType;
  static Map<String, dynamic> _quote;
  static bool _isMsgAvailabe;
  static BuildContext _context;

  RequestInfoScreen(this._screenType, this._request);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: _buildRequestDetailScreen(),
    );
  }

  Widget _buildRequestDetailScreen(){
    return Column(
      children: <Widget>[
      _createRequestInfoSection(),
      _createQuoteInfoSection(),
      _createButton()
      ],
    );
  }

  Widget _createRequestInfoSection(){
    return Container(
      child: _createRequestInfoList(),
    );
  }

  Widget _createRequestInfoList(){
    return Expanded(
          child: ListView(
        children: <Widget>[
          _createTitleTile(),
          _createVehicleInfoButton(),
          _createDescriptionTile(),
          _createAttachmentButton()
        ],
      ),
    );
  }

  Widget _createTitleTile(){
    return ListTile(
      title: Text('Title'),
      subtitle: Text(_request['title']),
    );
  }

  Widget _createVehicleInfoButton(){
    return RaisedButton(
      child: Text('View Vehicle'),
      onPressed:(){ _whenViewVehiclePressed();},
    );
  }

  void _whenViewVehiclePressed(){
    MaterialPageRoute route = _getViewVehicleRoute();
    Navigator.push(_context, route);
  }

  MaterialPageRoute _getViewVehicleRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        return VehicleDetailScreen(_request['request_id']);
      }
    );
  }

  Widget _createDescriptionTile(){
    return ListTile(
      title: Text('Description'),
      subtitle: Text(_request['description']),
    );
  }

  Widget _createAttachmentButton(){
    return RaisedButton(
      child: Text('View Attachment'),
      onPressed: (){_whenViewAttachmentPressed();},
    );
  }

  void _whenViewAttachmentPressed(){
    MaterialPageRoute route = _getAttachmentRoute();
    Navigator.push(_context, route);
  }

  MaterialPageRoute _getAttachmentRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
       return AttachmentScreen(_request['attachment_url']);
      }
    );
  }

  Widget _createQuoteInfoSection(){
    return FutureBuilder(
      future: RequestInfoBackend().getQuoteInfoForReqId(_request['request_id']),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> quoteSnap){
        if(quoteSnap.data != null){
          _quote = quoteSnap.data;
          if(_screenType != 'incomming'){
            return _createQuoteInfoList();
          }
          else{
            return _sparePadding(8.0);
          }
        }
        else{
          return _sparePadding(8.0);
        }
      },
    );
  }

  Widget _createQuoteInfoList(){
    return Expanded(
          child: Container(
        child: ListView(
          children: <Widget>[
            _createQuoteTile(),
            _createQuoteDescriptionTile(),
            _createSchedualTile(),
          ],
        ),
      ),
    );
  }

  Widget _createQuoteTile(){
    return ListTile(
      title: Text('Quote Amount'),
      subtitle: Text('\$${_quote['quote_amount']}'),
    );
  }

  Widget _createQuoteDescriptionTile(){
    return ListTile(
      title: Text('Quote Description'),
      subtitle: Text(_quote['description']),
    );
  }

  Widget _createSchedualTile(){
    return ListTile(
      title: Text('Schedual'),
      subtitle: Text(_quote['schedual']),
    );
  }

  Widget _createButton() {
    if(_screenType != 'incomming'){
      return _createViewMsgButton();
    }
    else{
      return _createSendQuoteButton();
    }
  }

  Widget _createViewMsgButton(){
    return FutureBuilder(
      initialData: false,
      future: RequestInfoBackend().checkMsgAvailable(_request['request_id']),
      builder: (BuildContext context, AsyncSnapshot<bool> isMsgAvailable){
        if(isMsgAvailable.data){
          return _createEnabledViewMsgBtn();
        }
        else{
          return _createDisabledViewMsgBtn();
        }
          },
        );
    
  }

  Widget _createEnabledViewMsgBtn(){
    return RaisedButton(
      child: Text('View Chat'),
      onPressed: (){_whenViewBtnPressed();},
    );
  }

  void _whenViewBtnPressed(){
    MaterialPageRoute route = _getChatRoute();
    Navigator.push(_context, route);
  }

  MaterialPageRoute _getChatRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        return ChatScreen(_quote['mech_id'],_request['request_id'], _screenType);
      }
    );
  }

  Widget _createDisabledViewMsgBtn(){
    return RaisedButton(
      child: Text('No Message yet'),
    );
  }

  Widget _createSendQuoteButton(){
    return RaisedButton(
      child: Text('Send Quote'),
      onPressed: (){_whenSendQuotePressed();},
    );
  }

  void _whenSendQuotePressed(){
    MaterialPageRoute route = _getQuoteFormRoute();
    Navigator.push(_context, route);
  }

  MaterialPageRoute _getQuoteFormRoute(){
    return MaterialPageRoute(
      builder: (BuildContext context){
        return QuoteFormScreen(_request['request_id']);
      }
    );
  }

  Widget _sparePadding(double value){
    return Padding(
      padding: EdgeInsets.all(value),
    );
  }
}