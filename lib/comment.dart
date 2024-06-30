import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ والوقت
import 'package:first_pro/sqldb.dart'; // استيراد كائن SqlDb
import 'userManager.dart';
import 'login.dart';

class CommentsPage extends StatefulWidget {
  final int adId;

  CommentsPage({required this.adId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  SqlDb sqlDb = SqlDb();
  String name = users.name;
  TextEditingController _commentController = TextEditingController();

  Future<List<Map<String, dynamic>>> _fetchComments() async {
    return await sqlDb.getCommentsForAd(widget.adId, users.typeAds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التعليقات'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchComments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('لا توجد تعليقات لعرضها'));
                    } else {
                      List<Map<String, dynamic>> comments = snapshot.data!;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(comments[index]['commenter_name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comments[index]['comment_text']),
                                  SizedBox(height: 4),
                                  Text(
                                    'تاريخ: ${comments[index]['date']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'الوقت: ${comments[index]['time']}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (users.typeAccount == 'guest')
                    Row(
                      children: [
                        Icon(Icons.warning,
                            color: Colors.orange), // أيقونة التحذير أو الإنذار
                        SizedBox(width: 8), // المسافة بين الأيقونة والنص
                        Text(
                          'Log in to comment',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                                color: Color.fromARGB(255, 78, 14,
                                    151)), // تعيين الألوان والنمط للزر
                          ),
                        ),
                      ],
                    ),
                  if (users.typeAccount != 'guest')
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Enter your comment here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  if (users.typeAccount != 'guest')
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _postComment();
                        });
                      },
                      child: Text('نشر'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _postComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      String commenterName = name; // يجب استبداله بالاسم المستخدم الفعلي
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String time = DateFormat('HH:mm').format(DateTime.now());
      String typeAds = users.typeAds;

      String sql = '''
        INSERT INTO Comments (commenter_name, ad_id, comment_text, date, time)
        VALUES ('$commenterName', ${widget.adId}, '$commentText', '$date', '$time')
      ''';

      int result = await sqlDb.insertData(sql);
      if (result > 0) {
        print('تمت إضافة التعليق بنجاح.');
        _commentController.clear();
        // قم بتحديث واجهة المستخدم لعرض التعليق الجديد (اختياري)
        setState(() {
          // قم بتحديث حالة الواجهة لعرض التعليق الجديد إذا لزم الأمر
        });
      } else {
        print('حدث خطأ أثناء إضافة التعليق.');
      }
    } else {
      print('يرجى إدخال نص التعليق.');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
