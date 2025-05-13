import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/cart_oder_count.dart';
import 'package:ecommerce_app/core/common/payment_method_list.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/core/models/model.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:ecommerce_app/view/role_based_login/admin/controller/place_oder_controller.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:ecommerce_app/view/role_based_login/user/screens/items_detail_screen/widget/size_and_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ItemsDetaiScreen extends ConsumerStatefulWidget {
  final DocumentSnapshot<Object?> productItems;
  const ItemsDetaiScreen({super.key, required this.productItems});

  @override
  ConsumerState<ItemsDetaiScreen> createState() => _ItemsDetaiScreenState();
}

class _ItemsDetaiScreenState extends ConsumerState<ItemsDetaiScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 1;
  int selectedSizeIndex = 1;
  String? selectedPaymentMethodId; //to track selected payment method id
  double? selectedpaymentBalance; //to track selected payment method balance

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cp = ref.watch(cartService);
    final favrProvider = ref.watch(favoriteProvider);
    // final finalPrice = '\$${(widget.productItems['price'] * (1 - widget.productItems['discountPercenttage'] / 100) + 4.99).toStringAsFixed(2)}';
    final finalPrice = num.parse((widget.productItems['price'] *
            (1 - widget.productItems['discountPercenttage'] / 100))
        .toStringAsFixed(2));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: fbackgroundColor2,
        actions: const [
          CartOderCount(),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            height: size.height * 0.45,
            color: fbackgroundColor2,
            child: PageView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Hero(
                      tag: widget.productItems.id,
                      child: CachedNetworkImage(
                        imageUrl: widget.productItems['image'],
                        height: size.height * 0.38,
                        width: size.width * 0.84,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => AnimatedContainer(
                duration: const Duration(microseconds: 300),
                margin: const EdgeInsets.only(right: 4.0),
                width: index == currentIndex ? 10.0 : 6.0,
                height: 6.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: index == currentIndex
                        ? Colors.blue
                        : Colors.grey.shade400),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'H&M',
                      style: TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),

                    Text(
                      '${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '(${Random().nextInt(300) + 55} )',
                      style: const TextStyle(color: Colors.black38),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          favrProvider.toigleFavorites(widget.productItems);
                        },
                        child: Icon(
                          favrProvider.isExist(widget.productItems)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favrProvider.isExist(widget.productItems)
                              ? Colors.red
                              : Colors.black,
                          size: 28,
                        ))
                  ],
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  widget.productItems['name'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                Row(
                  children: [
                    Text(
                      '\$${widget.productItems['price']}.00',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          height: 1.4,
                          color: Colors.red),
                    ),
                    const SizedBox(width: 5.0),
                    if (widget.productItems['isDiscounted'] == true)
                      Text(
                        '$finalPrice',
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.black26,
                            fontSize: 18.0,
                            height: 1.4,
                            color: Colors.black26),
                      ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Text(
                  '$myDescription1 ${widget.productItems['name']} $myDescription2',
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -.5,
                      color: Colors.black38),
                ),
                const SizedBox(height: 15.0),
                SizeAndColor(
                    colors: widget.productItems['fcolor'],
                    sizes: widget.productItems['size'],
                    onColorSelected: (index) {
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                    onSizeSelected: (index) {
                      setState(() {
                        selectedSizeIndex = index;
                      });
                    },
                    selectedColorIndex: selectedColorIndex,
                    selectedSizeIndex: selectedSizeIndex)
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () {},
        label: SizedBox(
          width: size.width * 0.95,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final productId = widget.productItems.id; 
                      final productData = widget.productItems.data()
                          as Map<String, dynamic>; // get product data as map
                      //to get currently selected color and size
                      final selectedColor =
                          widget.productItems['fcolor'][selectedColorIndex];
                      final selectedSize =
                          widget.productItems['size'][selectedSizeIndex];

                      //
                      cp.addCart(
                        productId,
                        productData,
                        selectedColor,
                        selectedSize,
                      );
                      //notify to user
                      showSnackBar(
                          context, '${productData['name']} added to cart!');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black45,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.shopping_bag,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'ADD TO CART',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: -1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final productId = widget.productItems.id;
                    final productData = widget.productItems.data()
                        as Map<String, dynamic>; //get product data as map
                    final selectedColor =
                        widget.productItems['fcolor'][selectedColorIndex];
                    final selectedSize =
                        widget.productItems['size'][selectedColorIndex];
                    _showOderConfirmationDialog(
                      cp,
                      context,
                      productId,
                      productData,
                      selectedColor,
                      selectedSize,
                      finalPrice + 4.99,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BUY NOW',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOderConfirmationDialog(
    CartProvider cp,
    BuildContext context,
    String productId,
    Map<String, dynamic> productData,
    String selectedColor,
    String selectedSize,
    finalPrice,
  ) {
    String? addressError;
    TextEditingController addresscontroller = TextEditingController();
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
                    Text('Product Name: ${productData['name']}'),
                    const Text('Duantity: 1'),
                    Text('Selected Color : $selectedColor'),
                    Text('Selected Size: $selectedSize'),
                    Text('Toal Price : \$$finalPrice'),
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
                      finalAmount: finalPrice,
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
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: addresscontroller,
                      decoration: InputDecoration(
                          hintText: 'Enter your address',
                          errorText: addressError,
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    //Confirm and cancel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            } else if (selectedpaymentBalance! < finalPrice) {
                              showSnackBar(context,
                                  'Insufficient balance in selected payment method!');
                            } else if (addresscontroller.text.length < 8) {
                              setDialogState(() {
                                addressError =
                                    "Your address must be reffect your address identity";
                              });
                            } else {
                              //for single items order place
                              placeOrder(
                                  productId,
                                  productData,
                                  selectedColor,
                                  selectedSize,
                                  selectedPaymentMethodId!,
                                  addresscontroller.text,
                                  finalPrice,
                                  context);
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
                ),
              ),
            );
          },
        );
      },
    );
  }
}
