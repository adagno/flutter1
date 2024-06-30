import 'package:flutter/material.dart';
import 'package:first_pro/login.dart';
import 'package:first_pro/sqldb.dart';

enum AccountType { ServiceProvider, Customer }

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _serviceTypeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _workHoursController = TextEditingController();
  TextEditingController _reviewsController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  AccountType _accountType = AccountType.ServiceProvider;

  GlobalKey<FormState> formstate = GlobalKey();
  SqlDb sqlDb = SqlDb();

  bool _obscureText = true;
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formstate,
          child: ListView(
            children: [
              SizedBox(height: 40), // ترك مساحة فارغة للعنوان

              // عنوان الصفحة
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 148, 93, 180),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // حقل نوع الحساب
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  errorStyle: TextStyle(color: Colors.redAccent),
                ),
                child: DropdownButtonFormField<AccountType>(
                  value: _accountType,
                  onChanged: (value) {
                    setState(() {
                      _accountType = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: AccountType.ServiceProvider,
                      child: Text('Service Provider'),
                    ),
                    DropdownMenuItem(
                      value: AccountType.Customer,
                      child: Text('Customer'),
                    ),
                  ],
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  elevation: 8,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // حقل اسم المستخدم
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: InputBorder.none,
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter username' : null,
                ),
              ),
              SizedBox(height: 16.0),

              // حقل البريد الإلكتروني
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
              ),
              SizedBox(height: 16.0),

              // حقل رقم الهاتف
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    border: InputBorder.none,
                    icon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }

                    // تحقق من الطول
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }

                    // تحقق من بداية الرقم بـ 091 أو 092 أو 094
                    if (!value.startsWith('091') &&
                        !value.startsWith('092') &&
                        !value.startsWith('094')) {
                      return 'Phone number must start with 091, 092, or 094';
                    }

                    // تحقق من أن القيمة تحتوي على أرقام فقط
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Phone number should only contain digits';
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),

              // حقل كلمة المرور
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  obscureText: _obscureText, // حقل نص مخفي أو مرئي
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none,
                    icon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText; // تبديل حالة الرؤية
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 16.0),

              // حقل تأكيد كلمة المرور
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: InputBorder.none,
                    icon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText; // تبديل حالة الرؤية
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),

              // إذا كان نوع الحساب مقدم خدمة، فأظهر حقول إضافية
              if (_accountType == AccountType.ServiceProvider) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _serviceTypeController,
                    decoration: InputDecoration(
                      hintText: 'Service Type',
                      border: InputBorder.none,
                      icon: Icon(Icons.work_sharp),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter Service Type' : null,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_pin),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter Location' : null,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _workHoursController,
                    decoration: InputDecoration(
                      hintText: 'Work Hours',
                      border: InputBorder.none,
                      icon: Icon(Icons.timer),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter Work Hours' : null,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _reviewsController,
                    decoration: InputDecoration(
                      hintText: 'Reviews',
                      border: InputBorder.none,
                      icon: Icon(Icons.reviews),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter Reviews' : null,
                  ),
                ),
                SizedBox(height: 16.0),
              ],

              // زر التسجيل
              ElevatedButton(
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    String username = _usernameController.text.trim();
                    String email = _emailController.text.trim();
                    String password = _passwordController.text;
                    String phone = _phoneController.text.trim();

                    int response = 0; // تعيين قيمة افتراضية

                    try {
                      String currentDate = DateTime.now().toIso8601String();

                      if (_accountType == AccountType.ServiceProvider) {
                        String serviceType = _serviceTypeController.text.trim();
                        String location = _locationController.text.trim();
                        String workHours = _workHoursController.text.trim();
                        String reviews = _reviewsController.text.trim();
                        String phone = _phoneController.text.trim();

                        response = await sqlDb.insertProvider(
                          username,
                          email,
                          password,
                          "SP",
                          serviceType,
                          location,
                          workHours,
                          reviews,
                          phone,
                          currentDate,
                          "Activite",
                          "null",
                        );
                      } else if (_accountType == AccountType.Customer) {
                        response = await sqlDb.insertCustomer(
                          username,
                          email,
                          password,
                          "SR",
                          currentDate,
                          "Activite",
                          phone,
                          "null",
                        );
                      }

                      if (response != 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Account added successfully!'),
                        ));
                        _usernameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        _serviceTypeController.clear();
                        _locationController.clear();
                        _workHoursController.clear();
                        _reviewsController.clear();
                        _phoneController.clear();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Failed to add account. Username already exists!'),
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('An error occurred: $e'),
                      ));
                    }
                  }
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // رابط لدي حساب بالفعل
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                },
                child: Text(
                  'I have Account',
                  style: TextStyle(color: Color.fromARGB(255, 148, 93, 180)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
