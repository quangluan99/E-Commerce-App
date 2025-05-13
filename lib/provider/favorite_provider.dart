import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProvider = ChangeNotifierProvider<FavoriteProvider>(
  (ref) => FavoriteProvider(),
);

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;

  void reset() {
    _favoriteIds = [];
    notifyListeners();
  }

  final userId = FirebaseAuth.instance.currentUser?.uid;

  FavoriteProvider() {
    loadFavorites();
  }

  //toogle favorites states
  void toigleFavorites(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(productId); // remove from favorite
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(productId); // add items to the favorite collection
    }
    notifyListeners();
  }

  //check if a product is favorite
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  //add items  to firestore
  Future<void> _addFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorite').doc(productId).set({
        'isFavorite': true,
        'userId': userId,
      });
    } catch (err) {
      throw (err.toString());
    }
  }

  //remove favorite items from to firestore
  Future<void> _removeFavorite(String productId) async {
    try {
      await _firestore.collection('userFavorite').doc(productId).delete();
    } catch (err) {
      throw (err.toString());
    }
  }

  //to the keep store and load items favorite until remove favorite
  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userFavorite')
          .where('userId', isEqualTo: userId)
          .get();
      _favoriteIds = snapshot.docs
          .map(
            (doc) => doc.id,
          )
          .toList();
    } catch (err) {
      throw (err.toString());
    }
    notifyListeners();
  }
}
