import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/common/utils/color_conversion.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItems extends ConsumerWidget {
  final CartModel cart;
  final int index;

  const CartItems({super.key, required this.index, required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);
    final carts = cp.carts.reversed.toList();

    Size size = MediaQuery.of(context).size;

    final finalPrice = num.parse((cart.productData['price'] *
            (1 - cart.productData['discountPercenttage'] / 100))
        .toStringAsFixed(2));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 115.0,
      width: size.width / 1.15,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 18.0,
              ),
              CachedNetworkImage(
                imageUrl: cart.productData['image'],
                height: 115,
                width: 95,
              ),
              const SizedBox(width: 18),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          cart.productData['name'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cp.deleteCartItems(carts[index].productId);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28,
                          ))
                    ],
                  ),
                  const SizedBox(width: 5),
                  Row(
                    children: [
                      //selected color and size
                      const Text('Color : '),
                      const SizedBox(
                        width: 3.0,
                      ),
                      CircleAvatar(
                        radius: 10.0,
                        backgroundColor: getColorFromName(cart.selectedColor),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Text('Size : '),
                      Text(
                        cart.selectedSize,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    children: [
                      Text(
                        '\$$finalPrice',
                        style: const TextStyle(
                            fontSize: 20.0,
                            letterSpacing: -1,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 44),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                               // cp.addCart(cart.productId, cart.productData,
                              //     cart.selectedColor, cart.selectedSize);
                              cp.addQuantity(cart.productId);
                            },
                            child: Container(
                              width: 24.0,
                              height: 28.0,
                              decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6.0))),
                              child: const Icon(
                                Icons.add,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            '${cart.quantity}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          InkWell(
                            onTap: () {
                              if (cart.quantity == 0) {
                                cp.deleteCartItems(carts[index].productId);
                              } else {
                                cp.decreaseQuantity(cart.productId);
                              }
                            },
                            child: Container(
                              width: 24.0,
                              height: 28.0,
                              decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6.0))),
                              child: const Icon(
                                Icons.remove,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
