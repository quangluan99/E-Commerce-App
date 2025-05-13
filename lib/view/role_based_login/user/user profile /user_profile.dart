// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:ecommerce_app/services/auth_service.dart';
import 'package:ecommerce_app/view/login_screen.dart';
import 'package:ecommerce_app/view/role_based_login/admin/screen/author%20profile/author_profile.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/order/my_order_screen.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/payment/payment_sceen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthService _authService = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
final userId = FirebaseAuth.instance.currentUser?.uid;

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final user = snapshot.data!;
                        return Column(
                          children: [
                            const CircleAvatar(
                              radius: 56.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  'https://img.freepik.com/premium-photo/psychologist-digital-avatar-generative-ai_934475-9054.jpg'),
                            ),
                            Text(
                              user['name'],
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  height: 1.8,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user['email'],
                              style: const TextStyle(
                                height: 0.45,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyOrderScreen(),
                            )),
                        child: const ListTile(
                          leading: Icon(
                            Icons.change_circle_rounded,
                            size: 30,
                          ),
                          title: Text(
                            'Order',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentSceen(),
                              ));
                        },
                        child: const ListTile(
                          leading: Icon(
                            Icons.payment,
                            size: 30,
                          ),
                          title: Text(
                            'Payment Method',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthorProfileScreen(),
                              ));
                        },
                        child: const ListTile(
                          leading: Icon(
                            Icons.contact_emergency,
                            size: 30,
                          ),
                          title: Text(
                            'Contact Author',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.zero,
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
                        child: const ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            size: 30,
                          ),
                          title: Text(
                            'Log Out',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
