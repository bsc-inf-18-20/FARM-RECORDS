import 'package:flutter/material.dart';
import 'field_validator.dart';

class LabourActivityForm extends StatefulWidget {
  final Color buttonColor;
  final Color formFieldBorderColor;
  final Function(Map<String, dynamic>) onSubmit;

  const LabourActivityForm({
    super.key,
    required this.buttonColor,
    required this.formFieldBorderColor,
    required this.onSubmit,
  });

  @override
  _LabourActivityFormState createState() => _LabourActivityFormState();
}

class _LabourActivityFormState extends State<LabourActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plotNumberController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _workDoneController = TextEditingController();
  DateTime? _selectedDate;

  final _validator = FieldValidator();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all fields and select a date.')),
      );
      return;
    }

    final data = {
      'plot_number': _plotNumberController.text,
      'plot_size': _plotSizeController.text,
      'crop': _cropController.text,
      'activity': _activityController.text,
      'work_done': _workDoneController.text,
      'date': _selectedDate,
    };

    widget.onSubmit(data);
    _clearFields();
  }

  void _clearFields() {
    _plotNumberController.clear();
    _plotSizeController.clear();
    _cropController.clear();
    _activityController.clear();
    _workDoneController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateField(),
              const SizedBox(height: 15),
              _buildTextFormField(_plotNumberController, 'Plot Number',
                  Icons.pin_drop, _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(
                  _plotSizeController,
                  'Plot Size (e.g., hectares)',
                  Icons.square_foot,
                  _validator.validateNumberOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_cropController, 'Crop', Icons.local_florist,
                  _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_activityController, 'Activity', Icons.work,
                  _validator.validateTextOnly),
              const SizedBox(height: 15),
              _buildTextFormField(_workDoneController, 'Work Done',
                  Icons.done_all, _validator.validateNumberOnly),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  backgroundColor: widget.buttonColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Activity',
                    style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Date',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          errorText: _selectedDate == null ? 'Please choose a date' : null,
        ),
        child: Text(
          _selectedDate == null
              ? 'Choose Date'
              : '${_selectedDate!.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    IconData icon,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.formFieldBorderColor),
        ),
      ),
      validator: validator,
    );
  }
}
