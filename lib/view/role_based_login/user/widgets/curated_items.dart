import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CuratedItems extends ConsumerWidget {
  final DocumentSnapshot<Object?> eCommerceItems;
  final Size size;
  const CuratedItems(
      {super.key, required this.eCommerceItems, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favrProvider = ref.watch(favoriteProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: eCommerceItems.id,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: fbackgroundColor2,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      eCommerceItems['image'],
                    ))),
            height: size.height * 0.24,
            width: size.width * 0.48,
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 16.0,
                backgroundColor: favrProvider.isExist(eCommerceItems)
                    ? Colors.white
                    : Colors.black26,
                child: GestureDetector(
                  onTap: () {
                    ref.read(favoriteProvider).toigleFavorites(eCommerceItems);
                  },
                  child: Icon(
                    favrProvider.isExist(eCommerceItems)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favrProvider.isExist(eCommerceItems)
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'H&M',
              style:
                  TextStyle(color: Colors.black26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),

            //co the lay rating, review tren firebase
            Text(
              '${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '(${Random().nextInt(300) + 25} )',
              style: const TextStyle(color: Colors.black38),
            ),
          ],
        ),
        SizedBox(
          width: size.width * 0.48,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            eCommerceItems['name'] ?? 'N/A',
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 5.0),
            if (eCommerceItems['isDiscounted'] == true)
              Text(
                '\$${(eCommerceItems['price'] * (1 - eCommerceItems['discountPercenttage'] / 100)).toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.4,
                    color: Colors.red),
              ),
            const SizedBox(width: 5.0),
            eCommerceItems['isDiscounted'] == true
                ? Text(
                    '\$${eCommerceItems['price']}.00',
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.black26,
                        fontSize: 18.0,
                        height: 1.4,
                        color: Colors.black26),
                  )
                : Text(
                    '\$${(eCommerceItems['price'])}.00',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        height: 1.4,
                        color: Colors.red),
                  ),
          ],
        ),
      ],
    );
  }
}
