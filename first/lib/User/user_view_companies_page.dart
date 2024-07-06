import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewCompaniesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Companies'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Companies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No companies found.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return _buildCompanyCard(context, data);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> data) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(data['name']),
        subtitle: Text('Profile: ${data['profile']}'),
        children: <Widget>[
          ListTile(
            title: Text('CGPA Cutoff: ${data['cgpaCutoff']}'),
          ),
          ListTile(
            title: Text('Eligibility: ${data['eligibility'].join(', ')}'),
          ),
          ListTile(
            title: Text('Backlogs: ${data['backlogs']}'),
          ),
          ListTile(
            title: Text('CTC: ${data['ctc']}'),
          ),
          ListTile(
            title: Text('Form Deadline: ${_formatDateTime(data['formDeadline'])}'),
          ),
          ListTile(
            title: Text('Form Link: ${data['formLink']}'),
          ),
          ListTile(
            title: Text('PPT Date: ${data['pptDate']}'),
          ),
          ListTile(
            title: Text('OT Date: ${data['otDate']}'),
          ),
          ListTile(
            title: Text('Interview Date: ${data['interviewDate']}'),
          ),
          ListTile(
            title: Text('Contacts: ${data['contacts']}'),
          ),
        ],
        // onTap: () {
        //   // Handle tap on company item, if needed
        // },
      ),
    );
  }

  String _formatDateTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
    return '';
  }
}
