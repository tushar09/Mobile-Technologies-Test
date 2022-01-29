import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection{
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'mtdb');
    var database = await openDatabase(path, version: 1, onCreate: onCreatingDatabase);
    return database;
  }

  onCreatingDatabase(Database db, int version) async{
    //await db.execute("CREATE TABLE IF NOT EXISTS user (id INTEGER NOT NULL,imei TEXT NULL,firstName TEXT NULL,lastName TEXT NULL,dob TEXT NULL,passport TEXT NULL,email TEXT NULL,picture TEXT NULL,lat TEXT NULL,lng TEXT NULL,PRIMARY KEY (id),UNIQUE INDEX imei_UNIQUE (imei ASC) VISIBLE)");
    await db.execute("CREATE TABLE IF NOT EXISTS user (`id` INTEGER NOT NULL, `imei` TEXT, `firstName` TEXT, `lastName` TEXT, `dob` TEXT, `passport` TEXT, `email` TEXT, `picture` TEXT, `lat` TEXT, `lng` TEXT, PRIMARY KEY(`id`))");
    await db.execute("CREATE UNIQUE INDEX IF NOT EXISTS `index_User_imei` ON user (`imei`)");
  }
  //CREATE TABLE IF NOT EXISTS user (id INTEGER NOT NULL AUTO_INCREMENT,imei TEXT NULL,firstName TEXT NULL,lastName TEXT NULL,dob TEXT NULL,passport TEXT NULL,email TEXT NULL,picture TEXT NULL,lat TEXT NULL,lng TEXT NULL,PRIMARY KEY (id),UNIQUE INDEX imei_UNIQUE (imei ASC) VISIBLE)
}