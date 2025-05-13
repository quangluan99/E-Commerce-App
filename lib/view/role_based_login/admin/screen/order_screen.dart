import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:flutter/material.dart';

class AdminOderScreen extends StatefulWidget {
  const AdminOderScreen({super.key});

  @override
  State<AdminOderScreen> createState() => _AdminOderScreenState();
}

class _AdminOderScreenState extends State<AdminOderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        title: const Text('Total Order'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders yet'),
            );
          }
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text.rich(TextSpan(
                  children: [
                    TextSpan(
                        text: 'Order ID: ${order.id}}\n',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    TextSpan(
                      text: 'Total Price: \$${order['totalPrice']}',
                    )
                  ],
                )),
                subtitle: Text(
                  'Delivery location: ${order['address']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(
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

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        forceMaterialTransparency: false,
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('Orders').doc(orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final orders = snapshot.data!;
          var items = orders['items'] as List;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Id: ${item['productId']}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Quantity: ${item['quantity']}, Color: ${item['selectedColor']}, Size: ${item['selectedSize']}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Price: \$${item['price'] ?? 0}, Status : Pending',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
