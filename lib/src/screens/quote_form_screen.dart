
import 'package:flutter/material.dart';
import '../backend/quote_form_backend.dart';

class QuoteFormScreen extends StatefulWidget {
  final String _requestId;
  static BuildContext _context;
  static Map<String, dynamic> _quoteDataMap;

  QuoteFormScreen(this._requestId);

  @override
  _QuoteFormScreenState createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _schedualController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    QuoteFormScreen._context = context;
    return Scaffold(
      floatingActionButton: _createSubmitButton(),
      body: _buildQuoteForm(),
    );
  }

  Widget _buildQuoteForm(){
    return Container(
      child: Form(
        key: _formKey,
        child: _createFormColumn(),
      ),
    );
  }

  Widget _createFormColumn(){
    return ListView(
      children: _getFormFields(),
    );
  }

  List<Widget> _getFormFields(){
    return [
      _createAmountField(),
      _createDescriptionField(),
      _createSchedualField(),
    ];
  }

  Widget _createAmountField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Quote Amount',
        hintText: '\$500',
      ),
      keyboardType: TextInputType.number,
      controller: _amountController,
      validator: (value){return _validateNull(value);},
    );
  }

  Widget _createDescriptionField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Detail about the repair costs',
      ),
      controller: _descriptionController,
      validator: (value){return _validateNull(value);},
    );
  }

  Widget _createSchedualField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Appointment Schedual',
        hintText: 'Thurs, 9:50 AM',
      ),
      controller: _schedualController,
      validator: (value){return _validateNull(value);},
    );
  }

  String _validateNull(String value){
    if(value.length < 1){
      return 'Please fill out the field';
    }
    else{
      return null;
    }
  }

  FloatingActionButton _createSubmitButton(){
    return FloatingActionButton(
      child: Icon(Icons.check),
      onPressed: (){_whenSubmitPressed();},
    );
  }

  Future<void> _whenSubmitPressed() async{
    bool result;

    _prepareQuoteDataMap();
    result = await _submitDataToDb();
    if(result){
      Navigator.pop(QuoteFormScreen._context);
    }
    else{
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Problem in network while submiting Quote'),
        )
      );
    }
  }

  void _prepareQuoteDataMap(){
    QuoteFormScreen._quoteDataMap = {
      'quote_amount': _amountController.text,
      'description': _descriptionController.text,
      'schedual': _schedualController.text
    };
  }

  Future<bool> _submitDataToDb() async{
    return await QuoteFormBackend(widget._requestId).submitData(QuoteFormScreen._quoteDataMap);
  }
}