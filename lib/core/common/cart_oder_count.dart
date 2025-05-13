import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20activity/Add%20to%20cart/screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CartOderCount extends ConsumerWidget {
  const CartOderCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Iconsax.shopping_bag,
          size: 27.0,
        ),
        Positioned(
          right: -18,
          top: -15,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ));
            },
            icon: Container(
              padding: const EdgeInsets.all(3.5),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Text(
                '${cp.carts.length}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
