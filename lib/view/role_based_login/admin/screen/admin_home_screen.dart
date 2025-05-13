// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:ecommerce_app/services/auth_service.dart';
import 'package:ecommerce_app/view/login_screen.dart';
import 'package:ecommerce_app/view/role_based_login/admin/screen/add_items.dart';
import 'package:ecommerce_app/view/role_based_login/admin/screen/order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthService _authService = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');
  String? selectedCategory;
  List<String> categories = [];

  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Category').get();
    setState(() {
      categories = snapshot.docs
          .map(
            (doc) => doc['name'] as String,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Your Uploaded Items",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.receipt_long,
                          size: 28,
                        ),
                      ),
                      Positioned(
                        top: -8.0,
                        right: -10.0,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Orders')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return const Text('Error loading orders');
                              }
                              final orderCount = snapshot.data?.docs.length;

                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminOderScreen(),
                                      ));
                                },
                                icon: CircleAvatar(
                                  radius: 9.0,
                                  backgroundColor: Colors.red,
                                  child: Center(
                                    child: Text(
                                      orderCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),

                  //Sign Out
                  IconButton(
                    onPressed: () async {
                      try {
                        await _authService.signOut();
                        if (auth.currentUser == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                          ref.invalidate(cartService);
                          ref.invalidate(favoriteProvider);
                        }
                      } catch (e) {
                        debugPrint('Log out Failed because : $e ');
                      }
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      size: 29,
                    ),
                  ),

                  // filter category
                  DropdownButton<String>(
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All', style: TextStyle(fontSize: 18)),
                      ),
                      ...categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    icon: const Icon(Icons.tune, size: 28, color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    value: selectedCategory, // Currently selected value
                  )
                ],
              ),

              ///fetch the uploaded items from firestore
              Expanded(
                child: StreamBuilder(
                  //by filtering this => these items are display on those admin screen ,where uploads itself

                  stream: selectedCategory != null
                      ? items
                          .where("uploadedBy", isEqualTo: uid)
                          .where('category', isEqualTo: selectedCategory)
                          .snapshots()
                      : items.where("uploadedBy", isEqualTo: uid).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Center(
                          child: Text('Error loading items.'),
                        ),
                      );
                    }
                    final document = snapshot.data?.docs ?? [];
                    if (document.isEmpty) {
                      return const Center(child: Text('No Items Uploaded.'));
                    }
                    return ListView.builder(
                      itemCount: document.length,
                      itemBuilder: (context, index) {
                        final items =
                            document[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 2.0,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: items['image'],
                                    height: 55.0,
                                    fit: BoxFit.cover,
                                    width: 55.0,
                                  ),
                                ),
                                title: Text(
                                  items['name'] ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          items['price'] != null
                                              ? "\$${items['price']}.00"
                                              : "N/A",
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            letterSpacing: -1,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text('${items['category'] ?? "N/A"}'),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddItems(),
          ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
