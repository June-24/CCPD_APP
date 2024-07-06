import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_page.dart'; // Import your admin home page file here

class AddCompaniesPage extends StatefulWidget {
  @override
  _AddCompaniesPageState createState() => _AddCompaniesPageState();
}

class _AddCompaniesPageState extends State<AddCompaniesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _cgpaCutoffController = TextEditingController();
  final TextEditingController _backlogsController = TextEditingController();
  final TextEditingController _ctcController = TextEditingController();
  final TextEditingController _formLinkController = TextEditingController();
  final TextEditingController _pptDateController = TextEditingController();
  final TextEditingController _otDateController = TextEditingController();
  final TextEditingController _interviewDateController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();

  List<String> _eligibilityTags = [];
  final TextEditingController _eligibilityController = TextEditingController();

  DateTime? _formDeadline; // Stores selected form deadline
  DateTime? _pptDate; // Stores selected PPT date
  DateTime? _otDate; // Stores selected OT date
  DateTime? _interviewDate; // Stores selected interview date

  final CollectionReference _companiesCollection =
      FirebaseFirestore.instance.collection('Companies');

  Future<void> _addCompany(BuildContext context) async {
    await _companiesCollection
        .add({
          'name': _nameController.text,
          'profile': _profileController.text,
          'eligibility': _eligibilityTags,
          'cgpaCutoff': _cgpaCutoffController.text,
          'backlogs': _backlogsController.text,
          'ctc': _ctcController.text,
          'formDeadline': _formDeadline,
          'formLink': _formLinkController.text,
          'pptDate': _pptDateController.text,
          'otDate': _otDateController.text,
          'interviewDate': _interviewDateController.text,
          'contacts': _contactsController.text,
          // Add more fields as needed
        })
        .then((value) {
          // Clear text fields after successful addition
          _nameController.clear();
          _profileController.clear();
          _eligibilityController.clear();
          _eligibilityTags.clear();
          _cgpaCutoffController.clear();
          _backlogsController.clear();
          _ctcController.clear();
          _formLinkController.clear();
          _pptDateController.clear();
          _otDateController.clear();
          _interviewDateController.clear();
          _contactsController.clear();
          // Navigate back to admin home page
          Navigator.pop(context); // Pop the current route (AddCompaniesPage)
        })
        .catchError((error) {
          print("Failed to add company: $error");
          // Handle error as needed
        });
  }

  Future<void> _selectDateTime(
    BuildContext context,
    DateTime? initialDate,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final DateTime selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          onDateSelected(selectedDateTime);
          controller.text =
              '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}';
        });
      }
    }
  }

  void _addTag(String tag) {
    setState(() {
      _eligibilityTags.add(tag);
      _eligibilityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _profileController,
                decoration: InputDecoration(labelText: 'Profile'),
              ),
              SizedBox(height: 16),
              _buildEligibilityInput(),
              SizedBox(height: 16),
              TextField(
                controller: _cgpaCutoffController,
                decoration: InputDecoration(labelText: 'CGPA Cutoff'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _backlogsController,
                decoration: InputDecoration(labelText: 'Backlogs'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ctcController,
                decoration: InputDecoration(labelText: 'CTC'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(
                    context, _formDeadline, _formLinkController, (dateTime) {
                  _formDeadline = dateTime;
                }),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _formDeadline == null
                            ? ''
                            : '${_formDeadline!.day}/${_formDeadline!.month}/${_formDeadline!.year} ${_formDeadline!.hour}:${_formDeadline!.minute}'),
                    decoration: InputDecoration(labelText: 'Form Deadline'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _formLinkController,
                decoration: InputDecoration(labelText: 'Form Link'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(
                    context, _pptDate, _pptDateController, (dateTime) {
                  _pptDate = dateTime;
                }),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _pptDate == null
                            ? ''
                            : '${_pptDate!.day}/${_pptDate!.month}/${_pptDate!.year} ${_pptDate!.hour}:${_pptDate!.minute}'),
                    decoration: InputDecoration(labelText: 'PPT Date'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(
                    context, _otDate, _otDateController, (dateTime) {
                  _otDate = dateTime;
                }),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _otDate == null
                            ? ''
                            : '${_otDate!.day}/${_otDate!.month}/${_otDate!.year} ${_otDate!.hour}:${_otDate!.minute}'),
                    decoration: InputDecoration(labelText: 'OT Date'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(
                    context, _interviewDate, _interviewDateController,
                    (dateTime) {
                  _interviewDate = dateTime;
                }),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _interviewDate == null
                            ? ''
                            : '${_interviewDate!.day}/${_interviewDate!.month}/${_interviewDate!.year} ${_interviewDate!.hour}:${_interviewDate!.minute}'),
                    decoration:
                        InputDecoration(labelText: 'Interview Date'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _contactsController,
                decoration: InputDecoration(labelText: 'Points of Contacts'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _addCompany(context),
                child: Text('Add Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEligibilityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Eligibility (Tags)'),
        Wrap(
          spacing: 8.0,
          children: _eligibilityTags.map((tag) => _buildTagChip(tag)).toList(),
        ),
        TextField(
          controller: _eligibilityController,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _addTag(value.trim());
            }
          },
          decoration: InputDecoration(
            hintText: 'Add eligibility tag',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (_eligibilityController.text.isNotEmpty) {
                  _addTag(_eligibilityController.text.trim());
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return InputChip(
      label: Text(tag),
      onDeleted: () {
        setState(() {
          _eligibilityTags.remove(tag);
        });
      },
    );
  }
}
