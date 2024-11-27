import 'package:flutter/material.dart';

void main() {
  runApp(AnimalFinancialApp());
}

class AnimalFinancialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimalFinancialForm(),
    );
  }
}

class AnimalFinancialForm extends StatefulWidget {
  @override
  _AnimalFinancialFormState createState() => _AnimalFinancialFormState();
}

class _AnimalFinancialFormState extends State<AnimalFinancialForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeOfAnimalController = TextEditingController();
  final TextEditingController _numberOfAnimalsController = TextEditingController();
  final TextEditingController _salesController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Date: ${_dateController.text}");
      print("Type of Animal: ${_typeOfAnimalController.text}");
      print("Number of Animals: ${_numberOfAnimalsController.text}");
      print("Total Sales: ${_salesController.text}");

      _formKey.currentState!.reset();
      _dateController.clear();
      _typeOfAnimalController.clear();
      _numberOfAnimalsController.clear();
      _salesController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Animal financial details submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animal Financial Record"),
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
                controller: _typeOfAnimalController,
                decoration: InputDecoration(labelText: 'Type of Animal'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the type of animal' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _numberOfAnimalsController,
                decoration: InputDecoration(labelText: 'Number of Animals'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the number of animals' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _salesController,
                decoration: InputDecoration(labelText: 'Total Sales Made'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the total sales made' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
