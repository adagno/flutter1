import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:first_pro/sqldb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accounts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: accounts(),
    );
  }
}

class accounts extends StatefulWidget {
  @override
  _accountsState createState() => _accountsState();
}

class _accountsState extends State<accounts> {
  SqlDb dbHelper = SqlDb();
  TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  String _selectedTable = 'customer_Table';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _controller.text.trim();
    });
  }

  void _onTableChanged(String? value) {
    setState(() {
      _selectedTable = value ?? 'customer_Table';
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Accounts'),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () async {
              await dbHelper.mydeleteDatabase();
            },
            child: Text("Delete Database"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _selectedTable,
                  onChanged: _onTableChanged,
                  items: <String>[
                    'customer_Table',
                    'SP_Table',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search by Account Number',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _searchQuery.isEmpty
                  ? dbHelper.readData('SELECT * FROM $_selectedTable')
                  : dbHelper.readData(
                      'SELECT * FROM $_selectedTable WHERE id = $_searchQuery'),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No accounts found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> account = snapshot.data![index];
                      String _name = account['name'];
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text('${account['id']}'),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            account['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(account['email']),
                                          SizedBox(height: 4.0),
                                          Text(account['phone']),
                                          Row(
                                            children: [
                                              Text("State: "),
                                              Text(account['state']),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text('Delete'),
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirm Delete'),
                                                  content: Text(
                                                      'Are you sure you want to delete your account?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        int response = 0;
                                                        response = await dbHelper
                                                            .deleteData(
                                                                "DELETE FROM '$_selectedTable' WHERE name='$_name'");

                                                        if (response > 0) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'The Account has been deleted!'),
                                                            ),
                                                          );
                                                          response = await dbHelper
                                                              .deleteData(
                                                                  "DELETE FROM Comments WHERE commenter_name='$_name'");

                                                          response = await dbHelper
                                                              .deleteData(
                                                                  "DELETE FROM ServiceOfferAds_Table WHERE publisher_name='$_name'");

                                                          response = await dbHelper
                                                              .deleteData(
                                                                  "DELETE FROM requestAds_Table WHERE publisher_name='$_name'");
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Failed to delete account!'),
                                                            ),
                                                          );
                                                        }

                                                        setState(() {
                                                          build(context);
                                                        });
                                                        // Ad
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // Add delete logic here
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Text('Block'),
                                          onTap: () async {
                                            int response = 0;
                                            response = await dbHelper.updateData(
                                                "UPDATE '$_selectedTable' SET state='Blocked' WHERE name='$_name'");

                                            if (response > 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'The Account has been Bloked!'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Failed to Blocked account!'),
                                                ),
                                              );
                                            }
                                            setState(() {
                                              build(context);
                                            });
                                            // Add block logic here
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Text('Activite'),
                                          onTap: () async {
                                            int response = 0;
                                            response = await dbHelper.updateData(
                                                "UPDATE '$_selectedTable' SET state='Activite' WHERE name='$_name'");

                                            if (response > 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'The Account has been Activited!'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Failed to Blocked Activited!'),
                                                ),
                                              );
                                            }
                                            setState(() {
                                              build(context);
                                            });
                                            // Add block logic here
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
