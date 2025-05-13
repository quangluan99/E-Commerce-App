// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/payment/add_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentSceen extends StatefulWidget {
  const PaymentSceen({super.key});

  @override
  State<PaymentSceen> createState() => _PaymentSceenState();
}

class _PaymentSceenState extends State<PaymentSceen> {
  String? userId;
  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser?.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Payment Methods'),
          centerTitle: true,
          backgroundColor: fbackgroundColor2,
        ),
        body: userId == null
            ? const Center(
                child: Text('Pleaes login to vew payment methods'),
              )
            : SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User Payment Method')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final methods = snapshot.data!.docs;
                    if (methods.isEmpty) {
                      return const Center(
                        child: Text(
                            textAlign: TextAlign.center,
                            'No Payment methods found. Please add a payment methods!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: methods.length,
                      itemBuilder: (context, index) {
                        final method = methods[index];
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: method['image'],
                            width: 48,
                            height: 48,
                          ),
                          title: Text(
                            method['paymentSystem'],
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            ' ● Activate',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700),
                          ),
                          trailing: MaterialButton(
                            onPressed: () {
                              return _showAddFundsDialog(context, method);
                            },
                            child: const Text(
                              'Add Fund',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'Add Payment',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          isExtended: true,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPaymentMethod(),
                ));
          },
        ));
  }

  void _showAddFundsDialog(BuildContext context, DocumentSnapshot method) {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add Funds'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'Amount',
                prefixText: '\$',
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text);
                  if (amount == null || amount <= 0) {
                    showSnackBar(
                        context, "Please enter a valid positive amount ");
                    return;
                  }
                  try {
                    await method.reference.update({
                      'balance': FieldValue.increment(amount),
                    });
                    Navigator.pop(context);
                    showSnackBar(context, "Fund Added Successfully");
                  } catch (e) {
                    showSnackBar(context, 'Error adding funds: $e');
                  }
                },
                child: const Text('Add'))
          ],
        );
      },
    );
  }
}
