// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/my_button.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
      mask: "**** **** **** ****", // defines the pattern
      filter: {'*': RegExp(r'[0-9]')} // allows only digits

      );

  double balance = 0.0;
  String? selectedPaymentSystem;
  Map<String, dynamic>? selectedPaymentSystemData;
  final _formkey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>> fetchPaymentSystem() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('payment_methods').get();
    return snapshot.docs
        .map(
          (doc) => {
            'name': doc['name'],
            'image': doc['image'],
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Add Payment Method',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                FutureBuilder(
                  future: fetchPaymentSystem(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error : ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No Payment systems aivailable');
                    }
                    return DropdownButton<String>(
                      iconSize: 35,
                      elevation: 2,
                      value: selectedPaymentSystem,
                      hint: const Text(
                        'Select Payment System',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      items: snapshot.data!.map(
                        (system) {
                          return DropdownMenuItem<String>(
                            value: system['name'],
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: system['image'],
                                  width: 30.0,
                                  height: 380.0,
                                  errorWidget: (context, stackTrace, error) =>
                                      const Icon(Icons.error),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(system['name'])
                              ],
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentSystem = value;
                          selectedPaymentSystemData = snapshot.data!
                              .firstWhere((system) => system['name'] == value);
                        });
                      },
                    );
                  },
                ),
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                      labelText: 'Card Holder Name',
                      hintText: 'eg.Luan Bui',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Provide your full Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: 'eg.1230 4561 3454 8765',
                      border: OutlineInputBorder()),
                  inputFormatters: [maskFormatter],
                  validator: (value) {
                    if (value == null ||
                        value.replaceAll(' ', '').length != 16) {
                      return 'Card Number must be exactly 16 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _balanceController,
                  decoration: const InputDecoration(
                      labelText: 'Balance',
                      prefixText: '\$',
                      hintText: '40',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => balance = double.tryParse(value) ?? 0.0,
                ),
                const SizedBox(height: 20.0),
                MyButton(
                    onTab: () => addPaymentMethod(),
                    buttonText: 'Add Payment Method')
              ],
            )),
      )),
    );
  }

  void addPaymentMethod() async {
    if (!_formkey.currentState!.validate()) {
      return; //don't proceed if the form is invalid
    }
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && selectedPaymentSystemData != null) {
      final paymentCollection =
          FirebaseFirestore.instance.collection('User Payment Method');
      //check if the payment method already exists for this user
      final existingMethods = await paymentCollection
          .where('userId', isEqualTo: userId)
          .where('paymentSystem', isEqualTo: selectedPaymentSystemData!['name'])
          .get();
      if (existingMethods.docs.isNotEmpty) {
        showSnackBar(context, 'You have already added this payment method!');
        return;
      }
      await paymentCollection.add({
        'userName': _userNameController.text.trim(),
        'cardNumber': _cardNumberController.text.trim(),
        'balance': balance,
        'userId': userId,
        'paymentSystem': selectedPaymentSystemData!['name'],
        'image': selectedPaymentSystemData!['image'],
      });
      showSnackBar(context, 'Payment Method Successfully added!!');
      Navigator.pop(context);
    } else {
      showSnackBar(
          context, 'Failed!! Please Select Payment System or try again!!');
    }
  }
}
