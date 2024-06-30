import 'package:first_pro/sqldb.dart';
import 'package:first_pro/userManager.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _username = users.name;
  String _email = users.email;
  String _pass = users.pass;
  String typeAccount = users.typeAccount;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailCntroller = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoRow(
                    Icons.person, 'Username', _username, _usernameController),
                Text("          $_username"),
                SizedBox(height: 10),
                Divider(),
                _buildUserInfoRow(
                    Icons.email, 'Email', _email, _emailCntroller),
                SizedBox(height: 20),
                Divider(),
                _buildListTile(Icons.password, 'Change Password', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Change Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _oldPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Old Password',
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: _newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'New Password',
                              ),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirm New Password',
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              String oldPassword = _oldPasswordController.text;
                              String newPassword = _newPasswordController.text;
                              String confirmPassword =
                                  _confirmPasswordController.text;

                              // Validate new password and confirm password match
                              if (newPassword != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'New password and confirm password do not match!'),
                                  ),
                                );
                                return;
                              }

                              // Check if old password is correct (this is just an example, replace with your actual logic)
                              bool isOldPasswordCorrect =
                                  await validateOldPassword(oldPassword);

                              if (!isOldPasswordCorrect) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Incorrect old password!'),
                                  ),
                                );
                                return;
                              }

                              // Proceed with updating password in the database
                              int response = await updatePassword(newPassword);

                              if (response > 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Password updated successfully!'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update password!'),
                                  ),
                                );
                              }

                              Navigator.of(context).pop();
                            },
                            child: Text('Change'),
                          ),
                        ],
                      );
                    },
                  );
                }),
                _buildListTile(Icons.delete, 'Delete Account', () {
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
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              int response = 0; // Assigning initial value

                              if (users.typeAccount == "SR") {
                                response = await sqlDb.deleteData(
                                    "DELETE FROM customer_Table WHERE name='$_username'");
                              } else if (users.typeAccount == "SP") {
                                response = await sqlDb.deleteData(
                                    "DELETE FROM SP_Table WHERE name='$_username'");
                              }

                              if (response > 0) {
                                response = await sqlDb.deleteData(
                                    "DELETE FROM Comments WHERE commenter_name='$_username'");
                                response = await sqlDb.deleteData(
                                    "DELETE FROM ServiceOfferAds_Table WHERE publisher_name='$_username'");
                                response = await sqlDb.deleteData(
                                    "DELETE FROM requestAds_Table WHERE publisher_name='$_username'");
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('The Account has been deleted!'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete account!'),
                                  ),
                                );
                              }
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                }),
                SizedBox(height: 20),
                Text(
                    "To ensure that no errors occur, you must repeat the login process if you have made changes"),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      users.id = 0;
                      users.name = '';
                      users.email = '';
                      users.typeAccount = 'guest';
                      users.pass = '';
                      users.openDate = '';
                      users.state = '';
                      users.service_type = '';
                      users.location = '';
                      users.work_hours = '';
                      users.reviews = '';
                      users.phone = '';
                      users.typeAds = '';
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                      // Perform logout functionality here
                    },
                    child: Text('Log out'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String title, String content,
      TextEditingController? controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter new $title'),
                  content: TextField(
                    controller: controller,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Save'),
                      onPressed: () async {
                        if (controller != null) {
                          String newValue = controller.text;
                          if (title == 'Username') {
                            int response = 0; // Assigning initial value

                            if (users.typeAccount == "SR") {
                              response = await sqlDb.updateData(
                                  "UPDATE customer_Table SET name='$newValue' WHERE name='$_username'");

                              response = await sqlDb.updateData(
                                  "UPDATE requestAds_Table SET publisher_name='$newValue' WHERE publisher_name='$_username'");
                            } else if (users.typeAccount == "SP") {
                              response = await sqlDb.updateData(
                                  "UPDATE SP_Table SET name='$newValue' WHERE name='$_username'");

                              response = await sqlDb.updateData(
                                  "UPDATE requestAds_Table SET publisher_name='$newValue' WHERE publisher_name='$_username'");

                              response = await sqlDb.updateData(
                                  "UPDATE ServiceOfferAds_Table SET publisher_name='$newValue' WHERE publisher_name='$_username'");
                            }
                            response = await sqlDb.updateData(
                                "UPDATE Comments SET commenter_name='$newValue' WHERE commenter_name='$_username'");

                            if (response > 0) {
                              setState(() {
                                print("object");
                                _username = newValue;
                                users.name = newValue;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Username updated successfully!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update username!'),
                                ),
                              );
                            }
                          } else if (title == 'Email') {
                            int response = 0; // Assigning initial value

                            if (users.typeAccount == "SR") {
                              response = await sqlDb.updateData(
                                  "UPDATE customer_Table SET email='$newValue' WHERE name='$_username'");
                            } else if (users.typeAccount == "SP") {
                              response = await sqlDb.updateData(
                                  "UPDATE SP_Table SET email='$newValue' WHERE name='$_username'");
                            }
                            print("sdfsdfkjshkjsdkjcsk");
                            if (response > 0) {
                              setState(() {
                                print("object");
                                _username = newValue;
                                users.email = newValue;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Email updated successfully!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update Email!'),
                                ),
                              );
                            }
                          }
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<bool> validateOldPassword(String oldPassword) async {
    // Replace this with actual validation logic
    // For example, you can check if the oldPassword matches the stored password
    return oldPassword == _pass;
  }

  Future<int> updatePassword(String newPassword) async {
    int response = 0;

    if (users.typeAccount == "SR") {
      response = await sqlDb.updateData(
          "UPDATE customer_Table SET password='$newPassword' WHERE name='$_username'");
    } else if (users.typeAccount == "SP") {
      response = await sqlDb.updateData(
          "UPDATE SP_Table SET password='$newPassword' WHERE name='$_username'");
    }

    return response;
  }
}
