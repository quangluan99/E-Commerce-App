import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/order/order_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        title: const Text('Total Order'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return const Center(
              child: Text('No orders found'),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text(
                  'Order ID: ${order.id}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  'Total Price: \$${order['totalPrice']}',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserOrderDetail(
                          orderId: order.id,
                        ),
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
