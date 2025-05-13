// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/order/my_order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> placeOrder(
    String productId,
    Map<String, dynamic> productData,
    String selectedColor,
    String selectedSize,
    String paymentMethodId,
    String address,
    num finalPrice,
    BuildContext context) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    showSnackBar(
        context, 'User not Logged in. Please log in to please an order.');
    return;
  }
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
        'items': [
          {
            'productId': productId,
            'quantity': 1,
            'selectedColor': selectedColor,
            'selectedSize': selectedSize,
            'name': productData['name'],
            'price': productData['price']
          }
        ],

        'totalPrice': finalPrice,
        'status': 'pending', 
        'createdAt': FieldValue.serverTimestamp(),
        'address': address,
      };
      //Create new order
      final orderRef = FirebaseFirestore.instance.collection('Orders').doc();
      transaction.set(orderRef, orderData);
    });
    showSnackBar(context, 'Order Placed Suffessfully!');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyOrderScreen(),
        ));
  } on FirebaseException catch (err) {
    showSnackBar(context, 'Firebase Error : ${err.message}');

    throw Exception(err.toString());
  } on Exception catch(e){
        showSnackBar(context, 'Error : $e!');

  }
}
