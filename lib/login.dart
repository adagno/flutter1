import 'package:flutter/material.dart';
import 'package:first_pro/sqldb.dart';
import 'signin.dart';
import 'open.dart';
import 'ForgotPasswordPage.dart';
import 'userManager.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class Customer {
  int id;
  String name;
  String email;
  String typeAccount;
  String pass;
  String openDate;
  String state;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.typeAccount,
    required this.pass,
    required this.openDate,
    required this.state,
  });

  int getId() => id;

  String getName() => name;

  String getEmail() => email;

  String getTypeAccount() => typeAccount;

  String getPass() => pass;

  String getOpenDate() => openDate;

  String getState() => state;

  void setId(int id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setTypeAccount(String typeAccount) {
    this.typeAccount = typeAccount;
  }

  void setPass(String pass) {
    this.pass = pass;
  }

  void setOpenDate(String openDate) {
    this.openDate = openDate;
  }

  void setState(String state) {
    this.state = state;
  }
}

class S_Provider extends Customer {
  String serviceType;
  String location;
  String workHours;
  String reviews;
  String phone;

  S_Provider({
    required int id,
    required String name,
    required String email,
    required String typeAccount,
    required String pass,
    required String openDate,
    required String state,
    required this.serviceType,
    required this.location,
    required this.workHours,
    required this.reviews,
    required this.phone,
  }) : super(
          id: id,
          name: name,
          email: email,
          typeAccount: typeAccount,
          pass: pass,
          openDate: openDate,
          state: state,
        );

  String getServiceType() => serviceType;

  void setServiceType(String type) {
    serviceType = type;
  }

  String getLocation() => location;

  void setLocation(String loc) {
    location = loc;
  }

  String getWorkHours() => workHours;

  void setWorkHours(String hours) {
    workHours = hours;
  }

  String getReviews() => reviews;

  void setReviews(String rev) {
    reviews = rev;
  }

  String getPhone() => phone;

  void setPhone(String num) {
    phone = num;
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  String userType = "not";
  SqlDb sqlDb = SqlDb();

  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username == "admin" && password == "admin") {
      userType = "admin";
      users.typeAccount = "";
      print('Logged in as Admin');
    } else {
      // Check in SP_Table
      String spQuery =
          'SELECT * FROM SP_Table WHERE name = "$username" AND password = "$password"';
      List<Map<String, dynamic>> spResult = await sqlDb.readData(spQuery);

      if (spResult.isEmpty) {
        String spQuery =
            'SELECT * FROM SP_Table WHERE email = "$username" AND password = "$password"';
        spResult = await sqlDb.readData(spQuery);
      }

      if (spResult.isEmpty) {
        String spQuery =
            'SELECT * FROM SP_Table WHERE phone = "$username" AND password = "$password"';
        spResult = await sqlDb.readData(spQuery);
      }

      // Check in customer_Table if not found in SP_Table
      if (spResult.isEmpty) {
        String customerQuery =
            'SELECT * FROM customer_Table WHERE name = "$username" AND password = "$password"';
        List<Map<String, dynamic>> customerResult =
            await sqlDb.readData(customerQuery);

        if (customerResult.isEmpty) {
          String customerQuery =
              'SELECT * FROM customer_Table WHERE email = "$username" AND password = "$password"';
          customerResult = await sqlDb.readData(customerQuery);
        }
        if (customerResult.isEmpty) {
          String customerQuery =
              'SELECT * FROM customer_Table WHERE phone = "$username" AND password = "$password"';
          customerResult = await sqlDb.readData(customerQuery);
        }

        if (customerResult.isEmpty) {
          // Neither SP_Table nor customer_Table has the credentials
          _showMessage('Invalid username or password');
        } else {
          // Found in customer_Table
          userType = "CUS";
          _processUserData(customerResult);
          print('Logged in as customer');
        }
      } else {
        // Found in SP_Table
        userType = "SP";
        _processUserData(spResult);
        print('Logged in as service provider');
      }
    }

    setState(() {
      isLoading = false;
    });

    if (userType != "not") {
      // Implement login logic here
      if (users.state == "Activite" || userType == "admin") {
        Navigator.of(context).push(MaterialPageRoute(builder: (v) => MyApp()));
        print("This Account is Active");
      } else {
        _showMessage("This Account is Blocked");
      }
    }
  }

  void _processUserData(List<Map<String, dynamic>> userData) {
    List<Map<String, dynamic>> row = userData;
    if (row != null) {
      if (userType == "CUS") {
        Customer cu = Customer(
          id: row[0]['id'],
          name: row[0]['name'],
          email: row[0]['email'],
          typeAccount: row[0]['typeAccount'],
          pass: row[0]['password'],
          openDate: row[0]['open_date'],
          state: row[0]['state'],
        );
        _updateUserState(cu);
      } else if (userType == "SP") {
        S_Provider sp = S_Provider(
          id: row[0]['id'],
          name: row[0]['name'],
          email: row[0]['email'],
          typeAccount: row[0]['typeAccount'],
          pass: row[0]['password'],
          openDate: row[0]['open_date'],
          state: row[0]['state'],
          serviceType: row[0]['service_type'],
          location: row[0]['location'],
          workHours: row[0]['work_hours'],
          reviews: row[0]['reviews'],
          phone: row[0]['phone'],
        );
        _updateUserState(sp);
      }
    }
  }

  void _updateUserState(dynamic user) {
    users.id = user.getId();
    users.name = user.getName();
    users.email = user.getEmail();
    users.openDate = user.getOpenDate();
    users.pass = user.getPass();
    users.typeAccount = user.getTypeAccount();
    users.state = user.getState();
    if (user is S_Provider) {
      users.service_type = user.getServiceType();
      users.location = user.getLocation();
      users.phone = user.getPhone();
      users.reviews = user.getReviews();
      users.work_hours = user.getWorkHours();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 148, 93, 180),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username / Email / Phone',
                          border: InputBorder.none,
                          icon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // تبديل حالة الرؤية
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (v) => MyApp()));
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text('Guest'),
                    ),
                    SizedBox(height: 12.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (v) => SignUpPage()));
                      },
                      child: Text(
                        'Create an Account',
                        style:
                            TextStyle(color: Color.fromARGB(255, 148, 93, 180)),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text(
                        'Forgot Password?',
                        style:
                            TextStyle(color: Color.fromARGB(255, 148, 93, 180)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
