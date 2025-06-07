import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';

abstract interface class FireRepository {
  const FireRepository();

  Future<bool> checkInvoice();
}

final class FireRepositoryImpl implements FireRepository {
  FireRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<bool> checkInvoice() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('invoice')
          .get()
          .timeout(const Duration(seconds: 3));
      final invoice = querySnapshot.docs[0].data()['invoice'];
      await _prefs.setBool(Keys.invoice, invoice);
      return invoice;
    } catch (e) {
      logger(e);
    }
    return _prefs.getBool(Keys.invoice) ?? false;
  }
}
