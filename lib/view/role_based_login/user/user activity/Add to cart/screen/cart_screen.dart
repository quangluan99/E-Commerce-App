import 'package:dotted_line/dotted_line.dart';
import 'package:ecommerce_app/core/common/payment_method_list.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20activity/Add%20to%20cart/widgets/cart_items.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/order/my_order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? selectedPaymentMethodId; //to track selected paymnet method id
  double? selectedpaymentBalance; //to track selected paymnet method balance
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cp = ref.watch(cartService);
    final carts = cp.carts.reversed.toList();
    return Scaffold(
      backgroundColor: fbackgroundColor2,
      appBar: AppBar(
        backgroundColor: fbackgroundColor2,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: carts.isNotEmpty
                  ? ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: CartItems(
                              cart: carts[index],
                              index: index,
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
          //for total cart Summary
          if (carts.isNotEmpty) _buildSummarySection(context, cp)
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, CartProvider cp) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Delivery',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: DottedLine()),
              SizedBox(width: 10.0),
              Text(
                '\$89.9',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              const Text(
                'Total Order',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Expanded(child: DottedLine()),
              const SizedBox(width: 10.0),
              Text(
                '\$${(cp.totalCart()).toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20.0,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(
            height: 38,
          ),
          MaterialButton(
            color: Colors.orangeAccent,
            height: 63.0,
            minWidth: MediaQuery.of(context).size.width - 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              _showOderConfirmationDialog(context, cp);
            },
            child: Text(
              'Pay \$${((cp.totalCart() + 4.99).toStringAsFixed(2))}',
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  void _showOderConfirmationDialog(BuildContext context, CartProvider cp) {
    String? addressError;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Confirm You Order'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListBody(
                      children: cp.carts.map(
                        (cartItem) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${cartItem.productData['name']} x ${cartItem.quantity}')
                            ],
                          );
                        },
                      ).toList(),
                    ),
                    Text(
                      'Total Payable Price: \$${(cp.totalCart() + 4.99).toStringAsFixed(2)}',
                    ),
                   // to display the list of available payment
                    const SizedBox(height: 10.0),
                    const Text(
                      'Select Payment Method',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PaymentMethodList(
                      selectedPaymentMethodId: selectedPaymentMethodId,
                      selectedpaymentBalance: selectedpaymentBalance,
                      finalAmount: cp.totalCart() + 4.99,
                      onPaymentMethodSelected: (p0, p1) {
                        setDialogState(
                          () {
                            selectedPaymentMethodId = p0;
                            selectedpaymentBalance = p1;
                          },
                        );
                      },
                    ),

                    const Text(
                      'Add your Delivery Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: 'Enter your address',
                          errorText: addressError,
                          border: const OutlineInputBorder()),
                    )
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 38, vertical: 10)),
                      onPressed: () {
                        if (selectedPaymentMethodId == null) {
                          showSnackBar(
                              context, 'Please select a pament method!');
                        } else if (selectedpaymentBalance! <
                            cp.totalCart() + 4.99) {
                          showSnackBar(context,
                              'Insufficient balance in selected payment method!');
                        } else if (addressController.text.length < 8) {
                          setDialogState(() {
                            addressError =
                                "Your address must be reffect your address identity";
                          });
                        } else {
                          _saveOrder(cp, context);
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 43, vertical: 10)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

//save order to firestore
  Future<void> _saveOrder(CartProvider cp, context) async {
    final userId =
        FirebaseAuth.instance.currentUser?.uid; 
    if (userId == null) {
      showSnackBar(context, 'You need to be logged in to place an order. ');
      return;
    }
    await cp.saveOrder(
      userId,
      context,
      selectedPaymentMethodId,
      cp.totalCart() + 4.99,
      addressController.text,
    );
    showSnackBar(context, 'Order placed successfully!');
    // will navigate to this screen after order place is successfully
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyOrderScreen(),
        ));
  }
}
