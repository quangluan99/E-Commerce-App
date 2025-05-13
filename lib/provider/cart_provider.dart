import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/provider/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartService =
    ChangeNotifierProvider<CartProvider>((ref) => CartProvider());

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CartProvider() {
    loadCartItems(); //load cart items on initialization
  }
  void reset() {
    _carts = [];
    notifyListeners();
  }

  final useId = FirebaseAuth.instance.currentUser?.uid;
  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  //add items to cart
  Future<void> addCart(String productId, Map<String, dynamic> productData,
      String selectedColor, String selectedSize) async {
    int index = _carts.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      //items exist, update quality and selected attributes
      var existingItem = _carts[index];
      _carts[index] = CartModel(
        productId: productId,
        productData: productData,
        quantity: existingItem.quantity + 1, //Increase quanity
        selectedColor: selectedColor, //update selected color
        selectedSize: selectedSize,
      );

      await _updateCartInFireBase(
          productId, _carts[index].quantity); //update firestore if nedded
    } else {
      //Items does not exist, add new entry
      _carts.add(CartModel(
          productId: productId,
          productData: productData,
          quantity: 1, //initially one items must be required
          selectedColor: selectedColor,
          selectedSize: selectedSize));
      await _firestore.collection('userCart').doc(productId).set({
        'productData': productData,
        'quantity': 1,
        'selectedColor': selectedColor,
        'selectedSize': selectedSize,
        'uid': useId,
      });
    }
    notifyListeners();
  }

// increase quantity
  Future<void> addQuantity(String producId) async {
    int index = _carts.indexWhere((element) => element.productId == producId);
    _carts[index].quantity += 1;
    await _updateCartInFireBase(producId, _carts[index].quantity);
    notifyListeners();
  }

  //Decrease quantity or remove the items

  Future<void> decreaseQuantity(String producId) async {
    int index = _carts.indexWhere((element) => element.productId == producId);
    _carts[index].quantity -= 1;
    if (_carts[index].quantity <= 0) {
      _carts.removeAt(index);
      await _firestore.collection('userCart').doc(producId).delete();
    } else {
      await _updateCartInFireBase(producId, _carts[index].quantity);
    }
    notifyListeners();
  }

  //Check if the prouct exist in the cart
  bool productExist(String productid) {
    return _carts.any((element) => element.productId == productid);
  }

//Calculate total cart value
  double totalCart() {
    double total = 0;
    for (var i = 0; i < _carts.length; i++) {
      final finalPrice = num.parse((_carts[i].productData['price'] *
              (1 - _carts[i].productData['discountPercenttage'] / 100))
          .toStringAsFixed(2));

      total += _carts[i].quantity * (finalPrice);
    }
    return total;
  }

  //save order list to firestore
  Future<void> saveOrder(String userId, BuildContext context, paymentMethodId,
      finalPrice, address) async {
    if (_carts.isEmpty) return; //No items to save
    final paymentRef = FirebaseFirestore.instance
        .collection('User Payment Method')
        .doc(paymentMethodId);
    try {
      //use transaction for atomic operations
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        //get current payment method data
        final snapshot = await transaction.get(paymentRef);
        if (!snapshot.exists) {
          throw Exception('Payment method not found');
        }
        final currentBalance = snapshot['balance'] as num;
        if (currentBalance < finalPrice) {
          throw Exception('Insufficoent funds');
        }
        //update payment method balance
        transaction.update(paymentRef, {
          'balance': currentBalance - finalPrice,
        });
        // create order data
        final orderData = {
          'userId': userId,
          'items': _carts.map(
            (cartItems) {
              return {
                'productId': cartItems.productId,
                'quantity': cartItems.quantity,
                'selectedColor': cartItems.selectedColor,
                'selectedSize': cartItems.selectedSize,
                'name': cartItems.productData['name'],
                'price': cartItems.productData['price']
              };
            },
          ).toList(),
          'totalPrice': finalPrice,
          'status': 'pending', //initial status
          'createdAt': FieldValue.serverTimestamp(),
          'address': address,
        };
        //Create new order
        final orderRef = FirebaseFirestore.instance.collection('Orders').doc();
        transaction.set(orderRef, orderData);
      });
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //Load cart items from firebase (to display it in cart screen)
  Future<void> loadCartItems() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userCart')
          .where('uid', isEqualTo: useId)
          .get();
      _carts = snapshot.docs.map(
        (doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CartModel(
              productId: doc.id,
              productData: data['productData'],
              quantity: data['quantity'],
              selectedColor: data['selectedColor'],
              selectedSize: data['selectedSize']);
        },
      ).toList();
    } catch (err) {
      debugPrint(err.toString());
    }
    notifyListeners();
  }

//Remove cartItems from FireStore
  Future<void> deleteCartItems(String productId) async {
    int index = _carts.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      _carts.removeAt(index); // Remove item from local cart
      await _firestore
          .collection('userCart')
          .doc(productId)
          .delete(); //remove item from firestore
    }
    notifyListeners();
  }

  //Update cart items in FIREBASE
  Future<void> _updateCartInFireBase(String productId, int quantity) async {
    try {
      await _firestore
          .collection('userCart')
          .doc(productId)
          .update({'quantity': quantity});
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
