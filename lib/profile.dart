import 'package:first_pro/open.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(home: profile()));
}

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(238, 246, 237, 255),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: double.infinity,
            color: Color.fromARGB(234, 255, 255, 255),
          ),

          // المربع البنفسجي في الأعلى
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(234, 62, 18, 158),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 100,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.36,
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('images/logo.jpg'),
              backgroundColor: Color.fromARGB(234, 62, 18, 158),
            ),
          ),
          // زر الرجوع في الأعلى اليسار
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (v) => MyApp()));

                // add your back button logic here
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // زر الخيارات في الأعلى اليمين
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              onPressed: () {
                // add your options button logic here
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
          ),
          // العنوان "Profile" في الأعلى الوسط
          Positioned(
            top: MediaQuery.of(context).size.height * 0.019,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),

          // إيميل المستخدم تحت الاسم
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Alidagnosh01@Gmail.com',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // اسم المستخدم تحت الصورة

          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Ali Dagnosh',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // أربعة أزرار في الأسفل
          Positioned(
            bottom: 410.0,
            left: 16.0,
            right: 16.0,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(Icons.settings, 'Settings'),
                _buildButton(Icons.phone, 'Call'),
                _buildButton(Icons.fingerprint, 'Fingerprint'),
                _buildButton(Icons.camera_alt, 'Camera'),
              ],
            ),
          ),

          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(234, 62, 18, 158),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(Icons.person, '1'),
                  _buildButton(Icons.people, '1'),
                  _buildButton(Icons.search, '1'),
                  _buildButton(Icons.message, '1'),
                  _buildButton(Icons.home, '1'),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 300.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton2(Icons.dashboard, 'Dashboard'),
                _buildButton2(Icons.account_balance, 'Balance'),
                _buildButton2(Icons.credit_card, 'CreditCard'),
              ],
            ),
          ),

          Positioned(
            bottom: 150.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton2(Icons.language, 'Language'),
                _buildButton2(Icons.question_answer, 'Questions'),
                _buildButton2(Icons.visibility, 'Visibility'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(height: 8.0),
          if (label != "1")
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton2(IconData icon, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Georgia',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
