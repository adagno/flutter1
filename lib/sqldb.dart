import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'open.dart';
import 'accounts.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'servView.db');
    Database myDb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return myDb;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("onUpdate");
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "messages_Table" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "id_sender" TEXT NOT NULL,
      "id_receiver" TEXT NOT NULL,
      "text_msg" TEXT NOT NULL,
      "date" TEXT NOT NULL,
      "time" TEXT NOT NULL
    );
    ''');
    await db.execute('''

    CREATE TABLE "SP_Table" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT UNIQUE NOT NULL,
      "email" TEXT NOT NULL,
      "password" TEXT NOT NULL,
      "typeAccount" TEXT NOT NULL,
      "service_type" TEXT NOT NULL,
      "location" TEXT NOT NULL,
      "work_hours" TEXT NOT NULL,
      "reviews" TEXT NOT NULL,
      "phone" TEXT NOT NULL,
      "open_date" TEXT NOT NULL,
      "state" TEXT NOT NULL,
      "image" BLOB
    );
    ''');
    await db.execute('''
    CREATE TABLE "customer_Table" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT UNIQUE NOT NULL,
      "email" TEXT NOT NULL,
      "password" TEXT NOT NULL,
      "typeAccount" TEXT NOT NULL,
      "open_date" TEXT NOT NULL,
      "state" TEXT NOT NULL,
      "phone" TEXT NOT NULL,
      "image" BLOB
    );
    ''');
    await db.execute('''
    CREATE TABLE "requestAds_Table" (
      "ad_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "publisher_id" INTEGER NOT NULL,
      "publisher_name" TEXT NOT NULL,
      "location" TEXT,
      "budget" TEXT,
      "expiry_date" TEXT NOT NULL,
      "description" TEXT,    
      "likes" INT,
      "publish_date" TEXT NOT NULL,
      "time" TEXT,
      "typeAd" TEXT NOT NULL,
      FOREIGN KEY ("publisher_id") REFERENCES "customer_Table" ("id")
    );
    ''');
    await db.execute('''
    CREATE TABLE "ServiceOfferAds_Table" (
      "ad_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "publisher_id" INTEGER NOT NULL,
      "publisher_name" TEXT NOT NULL,
      "location" TEXT,
      "price" TEXT,
      "category" TEXT,
      "description" TEXT,
      "likes" INT,
      "publish_date" TEXT NOT NULL,
      "time" TEXT,
      "typeAd" TEXT NOT NULL,
      FOREIGN KEY ("publisher_id") REFERENCES "SP_Table" ("id")
    );
    ''');
    await db.execute('''
    CREATE TABLE Comments (
      "comment_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "commenter_name" TEXT NOT NULL,
      "ad_id" INTEGER NOT NULL,
      "comment_text" TEXT,
      "date" TEXT,
      "time" TEXT,
      FOREIGN KEY ("ad_id") REFERENCES "ServiceOfferAds_Table" ("ad_id")
    );
  ''');
    print("Create Table :DONE");
  }

  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<int> insertCustomer(
      String name,
      String email,
      String password,
      String typeAccount,
      String openDate,
      String state,
      String phone,
      String image) async {
    Database? mydb = await db;

    // Check if the username already exists
    List<Map<String, dynamic>> existingNames = await mydb!.query(
      'customer_Table',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingNames.isNotEmpty) {
      // Username already exists, handle appropriately
      print("This uesrName is used");

      return 0; // Return 0 or handle as needed
    }

    // Insert new record
    int response = await mydb!.insert('customer_Table', {
      'name': name,
      'email': email,
      'password': password,
      'typeAccount': typeAccount,
      'open_date': openDate,
      'state': state,
      'phone': phone,
      'image': image,
    });

    return response;
  }

  Future<int> insertProvider(
      String name,
      String email,
      String password,
      String typeAccount,
      String serviceType,
      String location,
      String workHours,
      String reviews,
      String phone,
      String openDate,
      String state,
      String image) async {
    Database? mydb = await db;

    // Check if the username already exists
    List<Map<String, dynamic>> existingNames = await mydb!.query(
      'SP_Table',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingNames.isNotEmpty) {
      // Username already exists, handle appropriately
      print("This uesrName is used");

      return 0; // Return 0 or handle as needed
    }

    // Insert new record
    int response = await mydb!.insert('SP_Table', {
      'name': name,
      'email': email,
      'password': password,
      'typeAccount': typeAccount,
      'service_type': serviceType,
      'location': location,
      'work_hours': workHours,
      'reviews': reviews,
      'phone': phone,
      'open_date': openDate,
      'state': state,
      'image': image,
    });

    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<List<Map<String, dynamic>>> rowData(String sql, String name) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql, [name]);
    return response;
  }

  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'servView.db');
    await deleteDatabase(path);
    print("DELET: DONE");
  }

  Future<String?> getPublisherName(int publisherId) async {
    Database? mydb = await db;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
        SELECT name FROM SP_Table 
        INNER JOIN ServiceOfferAds_Table 
        ON SP_Table.id = ServiceOfferAds_Table.publisher_id 
        WHERE ServiceOfferAds_Table.publisher_id = ?
      ''', [publisherId]);

      if (results.isNotEmpty) {
        return results.first['name'] as String?;
      } else {
        return null; // No matching record found
      }
    } catch (e) {
      print('Error retrieving publisher name: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsForAd(
      int adId, String typeAds) async {
    Database? mydb = await db;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
        SELECT * FROM Comments 
        WHERE ad_id = ?
      ''', [adId]);

      return results;
    } catch (e) {
      print('Error retrieving comments: $e');
      return [];
    }
  }

  Future<Map<int, int>> fetchCommentCounts() async {
    Database? mydb = await db;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
      SELECT ad_id, COUNT(*) as comment_count 
      FROM Comments 
      GROUP BY ad_id
    ''');
      Map<int, int> commentCounts = {};
      results.forEach((row) {
        int adId = row['ad_id'];
        int count = row['comment_count'];
        commentCounts[adId] = count;
      });
      return commentCounts;
    } catch (e) {
      print('Error fetching comment counts: $e');
      return {};
    }
  }

  Future<int> fetchLikesCount(int adId) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> results = await mydb!.rawQuery(
      'SELECT likes_count FROM ServiceOfferAds_Table WHERE ad_id = ?',
      [adId],
    );
    if (results.isNotEmpty) {
      return results.first['likes'] as int;
    }
    return 0; // Return 0 if no likes_count found (or handle accordingly)
  }

  Future<void> updateLikesCount(int adId, int newLikes) async {
    Database? mydb = await db;
    await mydb!.rawUpdate(
      'UPDATE ServiceOfferAds_Table SET likes = ? WHERE ad_id = ?',
      [newLikes, adId],
    );
  }

  Future<Map<String, dynamic>> getAccountDetails(int adId) async {
    // Replace with your database query logic to fetch account details
    try {
      // Execute your SQL query here
      // Example:
      final List<Map<String, dynamic>> result =
          await readData('SELECT * FROM customer_Table WHERE id = $adId');
      // Assuming result is a list with a single map for simplicity
      return result.isNotEmpty ? result.first : {}; // Return the fetched data

      // Mock implementation for demonstration
      //return {
      //  'name': 'John Doe',
      //  'email': 'john.doe@example.com',
      //  // Add other fields as needed
      //};
    } catch (e) {
      print('Error fetching account details: $e');
      return {}; // Return an empty map or handle error as needed
    }
  }

  Future<List<Ad>> getAdsForUser(String userName) async {
    Database? mydb = await db;
    try {
      // استعلام SQL لاسترجاع الإعلانات للمستخدم بناءً على اسم المستخدم
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''

        SELECT ad_id, publisher_name, description, publish_date, typeAd
        FROM requestAds_Table
        WHERE publisher_name = ?
        UNION ALL
        SELECT ad_id, publisher_name, description, publish_date, typeAd
        FROM ServiceOfferAds_Table
        WHERE publisher_name = ?
        ORDER BY publish_date DESC
        ''', [userName, userName]);

      // تحويل النتيجة إلى قائمة من كائنات Ad
      List<Ad> ads = results.map((Map<String, dynamic> map) {
        return Ad(
          ad_id: map['ad_id'],
          publisher_name: map['publisher_name'],
          description: map['description'],
          publish_date: map['publish_date'],
          type_Ad: map['typeAd'],
        );
      }).toList();

      return ads;
    } catch (e) {
      print('حدث خطأ أثناء جلب الإعلانات: $e');
      throw e; // يمكنك التعامل مع الخطأ هنا أو إعادة رميه للأعلى
    }
  }

  Future<void> deleteAdR(String publisherName, int adId) async {
    Database? mydb = await db;
    try {
      await mydb!.rawDelete('''
        DELETE FROM requestAds_Table
        WHERE publisher_name = ? AND ad_id = ?
        ''', [publisherName, adId]);
    } catch (e) {
      print('حدث خطأ أثناء حذف الإعلان: $e');
      throw e; // يمكنك التعامل مع الخطأ هنا أو إعادة رميه للأعلى
    }
  }

  Future<void> deleteAdO(String publisherName, int adId) async {
    Database? mydb = await db;
    try {
      await mydb!.rawDelete('''
        DELETE FROM ServiceOfferAds_Table
        WHERE publisher_name = ? AND ad_id = ?
        ''', [publisherName, adId]);
    } catch (e) {
      print('حدث خطأ أثناء حذف الإعلان: $e');
      throw e; // يمكنك التعامل مع الخطأ هنا أو إعادة رميه للأعلى
    }
  }

  Future<void> updateAdDescriptionR(int adId, String newDescription) async {
    Database? mydb = await db;

    try {
      // فتح قاعدة البيانات أو الاتصال بالقاعدة إذا لزم الأمر

      // استعلام SQL لتحديث وصف الإعلان في جدول الإعلانات
      String sql = '''
      UPDATE requestAds_Table
      SET description = ?
      WHERE ad_id = ?
    ''';

      // تنفيذ الاستعلام مع تمرير البارامترات
      await mydb!.rawUpdate(sql, [newDescription, adId]);
    } catch (e) {
      throw Exception('خطأ في تحديث الوصف: $e');
    }
  }

  Future<void> updateAdDescriptionF(int adId, String newDescription) async {
    Database? mydb = await db;

    try {
      // فتح قاعدة البيانات أو الاتصال بالقاعدة إذا لزم الأمر

      // استعلام SQL لتحديث وصف الإعلان في جدول الإعلانات
      String sql = '''
      UPDATE ServiceOfferAds_Table
      SET description = ?
      WHERE ad_id = ?
    ''';

      // تنفيذ الاستعلام مع تمرير البارامترات
      await mydb!.rawUpdate(sql, [newDescription, adId]);
    } catch (e) {
      throw Exception('خطأ في تحديث الوصف: $e');
    }
  }

  Future<Map<int, int>> fetchAdsRequestCounts() async {
    Database? mydb = await db;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
      SELECT ad_id, COUNT(*) as Ads_Count 
      FROM requestAds_Table 
      GROUP BY ad_id
    ''');
      Map<int, int> Ads_Count = {};
      results.forEach((row) {
        int adId = row['ad_id'];
        int count = row['Ads_Count'];
        Ads_Count[adId] = count;
      });
      return Ads_Count;
    } catch (e) {
      print('Error fetching Ads count: $e');
      return {};
    }
  }

  Future<Map<int, int>> fetchAdsOfferCounts() async {
    Database? mydb = await db;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
      SELECT ad_id, COUNT(*) as Ads_Count 
      FROM ServiceOfferAds_Table 
      GROUP BY ad_id
    ''');
      Map<int, int> Ads_Count = {};
      results.forEach((row) {
        int adId = row['ad_id'];
        int count = row['Ads_Count'];
        Ads_Count[adId] = count;
      });
      return Ads_Count;
    } catch (e) {
      print('Error fetching Ads count: $e');
      return {};
    }
  }

  Future<void> stateAccount(int adId, String newState, String table) async {
    Database? mydb = await db;

    try {
      // فتح قاعدة البيانات أو الاتصال بالقاعدة إذا لزم الأمر

      // استعلام SQL لتحديث وصف الإعلان في جدول الإعلانات
      String sql = '''
      UPDATE $table
      SET state = ?
      WHERE id = ?
    ''';

      // تنفيذ الاستعلام مع تمرير البارامترات
      await mydb!.rawUpdate(sql, [newState, adId]);
    } catch (e) {
      throw Exception('خطأ في تحديث الوصف: $e');
    }
  }

  Future<Map<String, dynamic>?> getLastComment() async {
    Database? db;
    try {
      db = await openDatabase('your_database.db');
      List<Map<String, dynamic>> comments = await db.query(
        'Comments',
        orderBy: 'comment_id DESC', // رتب التعليقات تنازلياً حسب comment_id
        limit: 1, // استرجع فقط آخر تعليق
      );
      if (comments.isNotEmpty) {
        return comments.first; // استرجع آخر تعليق كخريطة
      } else {
        return null; // لا توجد تعليقات
      }
    } catch (e) {
      print('Error getting last comment: $e');
      return null;
    } finally {
      if (db != null) {
        await db.close(); // أغلق قاعدة البيانات
      }
    }
  }

  Future<String?> getPhoneNumberForPublisher(int publisherId) async {
    Database? mydb = await db;
    String? number;
    try {
      List<Map<String, dynamic>> results = await mydb!.rawQuery('''
        SELECT phone
        FROM SP_Table
        INNER JOIN ServiceOfferAds_Table
        ON SP_Table.id = ServiceOfferAds_Table.publisher_id
        WHERE ServiceOfferAds_Table.publisher_id = ?
      ''', [publisherId]);

      if (results.isNotEmpty) {
        //print(results.first['phone'] as String?);
        //print(publisherId);
        number = results.first['phone'];
        return number;
        //return results.first['phone'] as String?;
      } else {
        return null; // إذا لم يتم العثور على سجل مطابق
      }
    } catch (e) {
      print('حدث خطأ أثناء استرجاع رقم الهاتف: $e');
      return null; // أو يمكنك التعامل مع الخطأ بطريقة أخرى
    }
  }

  Future<int> getCountOfUsers() async {
    Database? mydb = await db;
    String query = 'SELECT COUNT(*) FROM customer_Table';
    int count = Sqflite.firstIntValue(await mydb!.rawQuery(query))!;
    return count;
  }
}
