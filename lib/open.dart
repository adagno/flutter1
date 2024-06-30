import 'package:flutter/material.dart';
import 'accounts.dart';
import 'login.dart';
import 'messages.dart';
import 'sittings.dart';
import 'userManager.dart';
import 'dart:async';
import 'package:first_pro/sqldb.dart';
import 'ForgotPasswordPage.dart';
import 'comment.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart'; // لتنسيق التاريخ والوقت

import 'sqlMessages.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  static const Color primaryColor = Color.fromARGB(234, 110, 0, 236);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  int id = users.id;
  String name = users.name;
  String email = users.email;
  String typeAccount = users.typeAccount;
  String pass = users.pass;
  String openDate = users.openDate;
  String state = users.state;
  String service_type = users.service_type;
  String location = users.location;
  String work_hours = users.work_hours;
  String reviews = users.reviews;
  String phone = users.phone;

  String catigoreys = "";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyApp.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle notification button tap
              },
              icon: Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomePage(),
            //MessagesPage(),
            AddAdPage(),
            //FriendsPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: MyApp.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.message),
          //  label: 'Messages',
          //),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Add Ad',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.people),
          //  label: 'Friends',
          //),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$name'),
              accountEmail: Text('$email'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/logo.jpg'),
              ),
            ),
            _buildDrawerItem(Icons.settings, 'Settings', () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage())); // Close drawer
              // Navigate to settings page or perform action
            }),
            if (users.typeAccount != 'SR' &&
                users.typeAccount != 'SP' &&
                users.typeAccount != 'guest')
              _buildDrawerItem(Icons.manage_search_rounded, 'Manager', () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (v) => accounts())); // Close drawer
                // Navigate to logout or perform logout action
              }),
            _buildDrawerItem(Icons.logout, 'Logout', () {
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage())); // Close drawer
              // Navigate to logout or perform logout action
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class search {
  static String name = '';
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  SqlDb sqlDb = SqlDb();
  Map<int, int> commentCounts = {};
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String searchName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    createTables();
    _fetchCommentCounts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> createTables() async {
    // Implement database table creation if necessary
  }

  Future<void> _fetchCommentCounts() async {
    try {
      Map<int, int> counts = await sqlDb.fetchCommentCounts();
      setState(() {
        commentCounts = counts;
      });
    } catch (e) {
      print('Error fetching comment counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              searchName = value;
            });
          },
          style: TextStyle(color: Color.fromARGB(255, 145, 101, 182)),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
                color: Color.fromARGB(255, 81, 0, 156).withOpacity(0.5)),
            border: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 70, 0, 117),
              size: 24.0,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Service request ADS'),
            Tab(text: 'Service offer ADS'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildServiceRequestAdsList(),
            _buildServiceOfferAdsList(),
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {
      //    showMenu(
      //      context: context,
      //      position: RelativeRect.fromLTRB(50, 1000, 0, 0),
      //      items: <PopupMenuEntry<String>>[
      //        PopupMenuItem<String>(
      //          value: 'All',
      //          child: Text('All'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات المهنية',
      //          child: Text('الخدمات المهنية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات الصحية',
      //          child: Text('الخدمات الصحية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات المالية',
      //          child: Text('الخدمات المالية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات التكنولوجية',
      //          child: Text('الخدمات التكنولوجية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات التجارية',
      //          child: Text('الخدمات التجارية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات الترفيهية',
      //          child: Text('الخدمات الترفيهية'),
      //        ),
      //        PopupMenuItem<String>(
      //          value: 'الخدمات الاجتماعية',
      //          child: Text('الخدمات الاجتماعية'),
      //        ),
      //      ],
      //    ).then((value) {
      //      if (value != null) {
      //        print('Selected: $value');
      //      }
      //    });
      //  },
      //  tooltip: 'Show Options',
      //  child: Icon(Icons.filter_list),
      //),
    );
  }

  Widget _buildServiceRequestAdsList() {
    return FutureBuilder<List<Post>>(
      future: _fetchServiceRequestPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لا توجد بيانات لعرضها'));
        } else {
          List<Post> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              int adId = posts[index].adId;
              int? count = commentCounts[adId];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/logo.jpg'),
                        ),
                        title: Text(posts[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(posts[index].time),
                            Text(posts[index].date),
                            Divider(),
                            Text(posts[index].description),
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(
                                    'Max Budget: '), // هذا النص سيظهر قبل سعر المنشور
                                Text(posts[index]
                                    .price
                                    .toString()), // سيظهر سعر المنشور
                                Text('   LYD '),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          print(posts[index].time);
                          print(posts[index].date);
                          // Handle item tap
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildServiceOfferAdsList() {
    return FutureBuilder<List<Post>>(
      future: _fetchServiceOfferPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لا توجد بيانات لعرضها'));
        } else {
          List<Post> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              int adId = posts[index].adId;
              int? count = commentCounts[adId];

              //String? result;
//

              //Future<String?> phoneNumber =
              //    sqlDb.getPhoneNumberForPublisher(publisher_id);
//
              //Future<String?> futureValue =
              //    sqlDb.getPhoneNumberForPublisher(publisher_id);
              //futureValue.then((value) {
              //  result = value;
              //  print(result);
              //  // القيام بالعمليات اللازمة بالنسبة لـ result
              //});
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/logo.jpg'),
                        ),
                        title: Text(posts[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(posts[index].time),
                            Text(posts[index].date),
                            Divider(),
                            Text(posts[index].description),
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(
                                    'Price: '), // هذا النص سيظهر قبل سعر المنشور
                                Text(posts[index]
                                    .price
                                    .toString()), // سيظهر سعر المنشور
                                Text('   LYD '),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    'Gategory: '), // هذا النص سيظهر قبل سعر المنشور
                                Text(posts[index].gategory.toString()),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          print(posts[index].time);
                          print(posts[index].date);
                          // Handle item tap
                        },
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _navigateToCommentsPage(context, adId);
                                  },
                                  icon: Icon(Icons.comment),
                                ),
                                SizedBox(width: 2),
                                Text(count != null ? '$count' : '0'),
                                SizedBox(width: 40),
                                Container(
                                  width: 1, // عرض الخط
                                  height: 20, // طول الخط
                                  color: Colors.grey, // لون الخط
                                ),
                                SizedBox(width: 40),
                                //IconButton(
                                //  onPressed: () {},
                                //  icon: Icon(Icons.phone),
                                //),
                                //SizedBox(width: 2),
                                //Text(posts[index].phone),
                                //SizedBox(width: 40),
                                //Container(
                                //  width: 1, // عرض الخط
                                //  height: 20, // طول الخط
                                //  color: Colors.grey, // لون الخط
                                //),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _navigateToCommentsPage(BuildContext context, int adId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(adId: adId),
      ),
    ).then((_) {
      // After returning from the CommentsPage, fetch the updated comment count
      _fetchCommentCounts();
    });
  }

  Future<List<Post>> _fetchServiceRequestPosts() async {
    String? searchName = _searchController.text;
    final List<Map<String, dynamic>> result;
    if (searchName != null && searchName.isNotEmpty) {
      result = await sqlDb.readData(
          'SELECT * FROM requestAds_Table WHERE publisher_name LIKE "%$searchName%" OR description LIKE "%$searchName%"');
    } else {
      result = await sqlDb.readData('SELECT * FROM requestAds_Table');
    }

    List<Post> posts = result
        .map((e) => Post(
              adId: e['ad_id'],
              title: e['publisher_name'],
              description: e['description'],
              price: e['budget'],
              time: e['time'],
              date: e['publish_date'],
              gategory: e['publisher_name'],
              //      phone: e['publisher_name'],
            ))
        .toList();

    return posts;
  }

  Future<List<Post>> _fetchServiceOfferPosts() async {
    String? searchName = _searchController.text;
    final List<Map<String, dynamic>> result;
    if (searchName != null && searchName.isNotEmpty) {
      result = await sqlDb.readData(
          'SELECT * FROM ServiceOfferAds_Table WHERE publisher_name LIKE "%$searchName%" OR description LIKE "%$searchName%"  OR category LIKE "%$searchName%"');
    } else {
      result = await sqlDb.readData('SELECT * FROM ServiceOfferAds_Table');
    }

    List<Post> posts = result
        .map((e) => Post(
              adId: e['ad_id'],
              title: e['publisher_name'],
              description: e['description'],
              price: e['price'],
              time: e['time'],
              date: e['publish_date'],
              gategory: e['category'],
              //        phone: e['publisher_phone'],
            ))
        .toList();

    return posts;
  }
}

class Post {
  final int adId;
  final String title;
  final String description;
  final String price;
  final String time;
  final String date;
  final String gategory;
  //final String phone;

  Post({
    required this.adId,
    required this.title,
    required this.description,
    required this.price,
    required this.time,
    required this.date,
    required this.gategory,
    //required this.phone,
  });
}

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> _messages = [];
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final messages = await DatabaseHelper.instance.getMessages();
    setState(() {
      _messages = messages
          .map((message) => Message(
                id: message[DatabaseHelper.columnId] as int,
                idSender: message[DatabaseHelper.columnIdSender] as String,
                idReceiver: message[DatabaseHelper.columnIdReceiver] as String,
                text: message[DatabaseHelper.columnText] as String,
                date: message[DatabaseHelper.columnDate] as String,
                time: message[DatabaseHelper.columnTime] as String,
              ))
          .toList();
    });
  }

  Future<void> _sendMessage() async {
    final message = {
      DatabaseHelper.columnIdSender: 'user1',
      DatabaseHelper.columnIdReceiver: 'user2',
      DatabaseHelper.columnText: _messageController.text,
      DatabaseHelper.columnDate: '2023-06-27',
      DatabaseHelper.columnTime: '12:34',
    };

    await DatabaseHelper.instance.insertMessage(message);
    _messageController.clear();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Messages Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Message {
  final int id;
  final String idSender;
  final String idReceiver;
  final String text;
  final String date;
  final String time;

  Message({
    required this.id,
    required this.idSender,
    required this.idReceiver,
    required this.text,
    required this.date,
    required this.time,
  });
}

class AddAdPage extends StatefulWidget {
  @override
  _AddAdPageState createState() => _AddAdPageState();
}

class _AddAdPageState extends State<AddAdPage> {
  int id = users.id;
  String name = users.name;
  String email = users.email;
  String typeAccount = users.typeAccount;
  String pass = users.pass;
  String openDate = users.openDate;
  String state = users.state;
  String service_type = users.service_type;
  String location = users.location;
  String work_hours = users.work_hours;
  String reviews = users.reviews;
  String phone = users.phone;

  String _adType = users.typeAccount; // Default to Offer
  String _description = '';
  double _price = 0.0;
  String _selectedCategory = 'Professional Services'; // Default category
  String _location = '';
  String budget = "";

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _priceContriller = TextEditingController();
  TextEditingController _catagory = TextEditingController();
  TextEditingController _budgetController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey();
  SqlDb sqlDb = SqlDb();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // List of business categories
  List<String> _businessCategories = [
    'Professional Services',
    'Health Services',
    'Financial Services',
    'Technology Services',
    'Commercial Services',
    'Entertainment Services',
    'Social Services',
    'Other',
    // Add more categories as needed
  ];
  bool canPressButton = true;

  void _submitForm() {
    // Handle form submission here
    // You can use _adType, _description, _price, _selectedCategory, _location variables
    // to send the data wherever you need to.
    // Example: API call, database operation, etc.
  }

  String escapeQuotes(String input) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (input[i] == "'") {
        buffer.write("''"); // استبدال علامة التنصيص بعلامتي تنصيص لتهريبها
      } else {
        buffer.write(input[i]);
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (users.typeAccount == 'guest')
                Row(
                  children: [
                    Icon(Icons.warning,
                        color: Colors.orange), // أيقونة التحذير أو الإنذار
                    SizedBox(width: 8), // المسافة بين الأيقونة والنص
                    Text(
                      'Log in to post ads',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8), // المسافة بين النص والزر
                    TextButton(
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
                        // إضافة السلوك عند النقر على الزر (مثلاً فتح شاشة تسجيل الدخول)
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                                255, 78, 14, 151)), // تعيين الألوان والنمط للزر
                      ),
                    ),
                  ],
                ),
              if (users.typeAccount != 'guest')
                Text(
                  'Choose Ad Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 10),
              if (users.typeAccount != 'guest')
                Row(
                  children: [
                    if (typeAccount == 'SP' || typeAccount == 'admin')
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Offer'),
                          value: 'Offer',
                          groupValue: _adType,
                          onChanged: (value) {
                            setState(() {
                              _adType = value!;
                            });
                          },
                        ),
                      ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Request'),
                        value: 'Request',
                        groupValue: _adType,
                        onChanged: (value) {
                          setState(() {
                            _adType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              Divider(),
              SizedBox(height: 20),
              if (users.typeAccount != 'guest')
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (users.typeAccount != 'guest')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter ad description...',
                      border: InputBorder.none,
                      icon: Icon(Icons.description_outlined),
                    ),
                    maxLines: null, // يسمح بعدة أسطر
                  ),
                ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              if (_adType == 'Offer')
                if (users.typeAccount != 'guest')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ':(Unchangeable)',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _priceContriller,
                          decoration: InputDecoration(
                            hintText: 'Enter price...',
                            border: InputBorder.none,
                            icon: Icon(Icons.attach_money),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _price = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20),
              if (_adType == 'Offer')
                if (users.typeAccount != 'guest')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ':(Unchangeable)',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _businessCategories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.work),
                          hintText: 'Select category...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20),
              if (users.typeAccount != 'guest')
                Row(
                  children: [
                    Text(
                      'Location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ':(Unchangeable)',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              if (users.typeAccount != 'guest')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter location...',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (_adType != 'Offer')
                if (users.typeAccount != 'guest')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Budget',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ':(Unchangeable)',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _budgetController,
                          decoration: InputDecoration(
                            hintText: 'Enter Budget...',
                            border: InputBorder.none,
                            icon: Icon(Icons.attach_money),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _price = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
              SizedBox(height: 20),
              if (users.typeAccount != 'guest')
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String description = _descriptionController.text.trim();
                      String escapedDescription = escapeQuotes(description);
                      String location = _locationController.text.trim();
                      String price = _priceContriller.text.trim();
                      String catagory = _selectedCategory.toString();
                      String budget = _budgetController.text.trim();
                      //String publish_Date = DateTime.now().toIso8601String();
                      int likes = 0;
                      String date =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                      String time = DateFormat('HH:mm').format(DateTime.now());
                      if (description.isNotEmpty) {
                        if (_adType == 'Offer') {
                          int response = await sqlDb.insertData('''
                        INSERT INTO ServiceOfferAds_Table 
                          (publisher_id, publisher_name, location, price, category, description, likes, publish_date, time,  typeAd)
                          VALUES ('$id', '$name', '$location', '$price', '$catagory', '$escapedDescription', '$likes', '$date', '$time', 'offer')
                      ''');

                          if (response != 0) {
                            _descriptionController.clear();
                            _priceContriller.clear();
                            _budgetController.clear();
                            _locationController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Add successfully!'),
                            ));
                          } else {
                            _showSnackBar(
                                'Failed to sign up. Please try again.');
                          }
                        } else {
                          int response = await sqlDb.insertData('''
                        INSERT INTO requestAds_Table 
                        (publisher_id,publisher_name, location, budget, expiry_date, description, likes, publish_date, time, typeAd)
                        VALUES ("$id","$name", "$location", "$budget", " ", "$description", "$likes", "$date", "$time" , "request")
                      ''');
                          if (response != 0) {
                            _descriptionController.clear();
                            _priceContriller.clear();
                            _budgetController.clear();
                            _locationController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Add successfully!'),
                            ));
                          } else {
                            _showSnackBar(
                                'Failed to sign up. Please try again.');
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter the description!'),
                        ));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Friends Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  int id = users.id;
  String name = users.name;
  String email = users.email;
  String phone = users.phone;
  String location = users.location;
  int _selectedIndex = 1;
  SqlDb sqlDb = SqlDb();

  Map<int, int> AdsRequestCounts = {};

  @override
  void initState() {
    super.initState();

    /// Create database tables if they do not exist
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //child: _selectedIndex == 0
        //    ? _buildAdsSection()
        //    : _selectedIndex == 1
        //        ? _buildProfileInfoSection()
        //        : _buildSettingsSection(),
        child: _selectedIndex == 0
            ? _buildAdsSection()
            : _buildProfileInfoSection(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.settings),
          //  label: 'الإعدادات',
          //),
        ],
      ),
    );
  }

  Widget _buildAdsSection() {
    return FutureBuilder(
      future: sqlDb.getAdsForUser(name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ في الحصول على البيانات.'));
        } else if (snapshot.hasData && (snapshot.data as List).isEmpty) {
          return Center(child: Text('No Ads'));
        } else {
          List<Ad> ads = snapshot.data as List<Ad>;

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              Ad ad = ads[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/logo.jpg'),
                        ),
                        title: Text(ad.publisher_name),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Text(ad.time),
                            Text(ad.publish_date),
                            Row(
                              children: [
                                Text("Type Ad: "),
                                Text(ad.type_Ad),
                              ],
                            ),
                            Divider(),
                            Text(ad.description),
                            SizedBox(height: 4.0),
                          ],
                        ),
                        //subtitle: Text(ad.description),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editAd(ad);
                            } else if (value == 'delete') {
                              deleteAd(ad.publisher_name, ad.ad_id, ad.type_Ad);
                            }
                          },
                        ),
                        onTap: () {
                          // إضافة ما يلزم للتعامل مع النقر على الإعلان
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void _editAd(Ad ad) {
    String newDescription = ad.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit'),
          content: TextFormField(
            initialValue: ad.description,
            onChanged: (value) {
              newDescription = value;
            },
            decoration: InputDecoration(
              labelText: 'New Description',
            ),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                _confirmEdit(ad, newDescription, ad.type_Ad);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmEdit(Ad ad, String newDescription, String typeAd) async {
    try {
      if (typeAd == "request")
        await sqlDb.updateAdDescriptionR(ad.ad_id, newDescription);
      else if (typeAd == "offer")
        await sqlDb.updateAdDescriptionF(ad.ad_id, newDescription);
      setState(() {
        _buildAdsSection();
      });
      print('Edit Done');
      // يمكنك إضافة منطق هنا لإعادة تحميل البيانات أو تحديث الواجهة بعد التعديل
    } catch (e) {
      print('حدث خطأ أثناء تعديل الإعلان: $e');
      // يمكنك إضافة رسالة للمستخدم أو معالجة خاصة بالأخطاء هنا
    }
  }

  Future<void> deleteAd(String publisherName, int adId, String typeAd) async {
    try {
      _confirmDelete(publisherName, adId, typeAd);
      print('Delete Done');

      // يمكنك إضافة منطق هنا لإعادة تحميل البيانات أو تحديث الواجهة بعد الحذف
    } catch (e) {
      print('حدث خطأ أثناء حذف الإعلان: $e');
      // يمكنك إضافة رسالة للمستخدم أو معالجة خاصة بالأخطاء هنا
    }
  }

  void _confirmDelete(String publisherName, int adId, String typeAd) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure to delete the ad?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الصندوق دون حذف
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                if (typeAd == "request")
                  await sqlDb.deleteAdR(publisherName, adId);
                else if (typeAd == "offer")
                  await sqlDb.deleteAdO(publisherName, adId);
                Navigator.of(context).pop();
                setState(() {
                  _buildAdsSection();
                }); // إغلاق الصندوق بعد الحذف
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileInfoSection() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (users.typeAccount == 'guest')
              Row(
                children: [
                  Icon(Icons.warning,
                      color: Colors.orange), // أيقونة التحذير أو الإنذار
                  SizedBox(width: 8), // المسافة بين الأيقونة والنص
                  Text(
                    'Log in to create a profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8), // المسافة بين النص والزر
                  TextButton(
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
                      // إضافة السلوك عند النقر على الزر (مثلاً فتح شاشة تسجيل الدخول)
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(
                              255, 78, 14, 151)), // تعيين الألوان والنمط للزر
                    ),
                  ),
                ],
              ),
            if (users.typeAccount != 'guest')
              CircleAvatar(
                radius: 50,
                // backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
            SizedBox(height: 16.0),
            if (users.typeAccount != 'guest')
              Text(
                '$name',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 8.0),
            if (users.typeAccount != 'guest')
              Text(
                '$email',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            SizedBox(height: 16.0),
            if (users.typeAccount != 'guest')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                  Icon(Icons.star_border, color: Colors.amber),
                  SizedBox(width: 8.0),
                  Text(
                    '4.5 / 5',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            if (users.typeAccount != 'guest')
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'التصنيف',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'القيمة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('المشاريع المكتملة'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('12'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الخبرة'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('5 سنوات'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('الترتيب'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('#25'),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            if (users.typeAccount != 'guest')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // launch('tel:+1234567890');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8.0),
                        Text('$phone'),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // launch('https://www.example.com');
                    },
                    child: Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(width: 8.0),
                        Text('$location'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'إعدادات الحساب',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Replace with your settings section content
      ],
    );
  }
}

class Ad {
  final int ad_id;
  final String publisher_name;
  final String description;
  final String publish_date;
  final String type_Ad;

  Ad({
    required this.ad_id,
    required this.publisher_name,
    required this.description,
    required this.publish_date,
    required this.type_Ad,
  });
}

/*
class ProfilePage_ extends StatefulWidget {
  final int adId;

  ProfilePage_({required this.adId});

  @override
  _ProfilePage_State createState() => _ProfilePage_State();
}

class _ProfilePage_State extends State<ProfilePage_> {
  String? userName;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchAccountDetails(widget.adId);
  }

  Future<void> fetchAccountDetails(int adId) async {
    // Replace with your database retrieval logic
    try {
      // Assuming SqlDb instance is available
      SqlDb sqlDb = SqlDb();
      Map<String, dynamic> accountData = await sqlDb.getAccountDetails(adId);
      setState(() {
        userName = accountData['name'];
        email = accountData['email'];
      });
    } catch (e) {
      print('Error fetching account details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'images/avatar.png'), // Replace with actual image path or network image
            ),
            SizedBox(height: 20),
            Text(
              'User Name: ${userName ?? "Loading..."}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${email ?? "Loading..."}',
              style: TextStyle(fontSize: 16),
            ),
            // Add other details here as needed
          ],
        ),
      ),
    );
  }
}

void _navigateToProfilePage(BuildContext context, int adId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage_(adId: adId),
    ),
  );
}
*/
