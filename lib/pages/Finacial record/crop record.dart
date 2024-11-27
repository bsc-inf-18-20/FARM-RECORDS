import 'package:flutter/material.dart';

void main() {
  runApp(CropFinancialApp());
}

class CropFinancialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CropFinancialForm(),
    );
  }
}

class CropFinancialForm extends StatefulWidget {
  @override
  _CropFinancialFormState createState() => _CropFinancialFormState();
}

class _CropFinancialFormState extends State<CropFinancialForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeOfInputController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _salesController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you can process the entered data
      print("Date: ${_dateController.text}");
      print("Type of Input: ${_typeOfInputController.text}");
      print("Amount Used: ${_amountController.text}");
      print("Total Sales: ${_salesController.text}");

      // Clear the form after submission
      _formKey.currentState!.reset();
      _dateController.clear();
      _typeOfInputController.clear();
      _amountController.clear();
      _salesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Financial Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the date' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _typeOfInputController,
                decoration: InputDecoration(labelText: 'Type of Input'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the type of input' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount of Money Used'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the amount used' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _salesController,
                decoration: InputDecoration(labelText: 'Total Sales Made'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the total sales' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
