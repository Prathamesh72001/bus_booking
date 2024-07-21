import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final DatabaseReference database = FirebaseDatabase.instance.ref().child('users');
  static final FirebaseStorage storage = FirebaseStorage.instance;
}