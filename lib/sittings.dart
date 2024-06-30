import 'package:flutter/material.dart';
import 'AccountPage.dart';
import 'userManager.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // متغيرات لتتبع حالة التطبيق
  bool _pushNotifications = true;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم عام: التبديلات والإعدادات العامة
            Text(
              'General',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
            // خيار تسجيل الدخول والأمان
            _buildListTile(Icons.lock, 'Login and security', () {
              _showPasswordDialog(context);
            }),
            // اختيار اللغة
            _buildLanguageDropDown(),
          ],
        ),
      ),
    );
  }

  // عنصر القائمة
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // قائمة منسدلة لاختيار اللغة
  Widget _buildLanguageDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Language',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _language,
          items: ['English', 'العربية', 'Español', 'Français']
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _language = value!;
            });
          },
        ),
      ],
    );
  }

  // صندوق حوار لإدخال كلمة المرور
  // صندوق حوار لإدخال كلمة المرور
  Future<void> _showPasswordDialog(BuildContext context) async {
    String enteredPassword = ''; // المتغير لتخزين كلمة المرور المدخلة
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              setState(() {
                enteredPassword = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // التحقق من كلمة المرور المدخلة
                if (enteredPassword == users.pass) {
                  // إذا كانت كلمة المرور صحيحة، انتقل للصفحة التالية
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                } else {
                  // إذا كانت كلمة المرور غير صحيحة، قم بعرض رسالة خطأ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect password!'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
