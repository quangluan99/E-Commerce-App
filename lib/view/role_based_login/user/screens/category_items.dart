import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/core/models/sub_category.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:ecommerce_app/view/role_based_login/user/screens/items_detail_screen/screen/items_detai_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CategoryItems extends ConsumerStatefulWidget {
  final String selectedCategory;
  final String category;
  const CategoryItems(
      {super.key, required this.category, required this.selectedCategory});

  @override
  ConsumerState<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends ConsumerState<CategoryItems> {
//for creating a review (i have generate a random number)
  Map<String, Map<String, dynamic>> randomValuecache = {};
  //search controller
  final TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filteredItems = [];
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String serachTerm = searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems.where(
        (item) {
          final data = item.data() as Map<String, dynamic>;
          final itemName = data['name'].toString().toLowerCase();
          return itemName.startsWith(serachTerm);
        },
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final favrProvider = ref.watch(favoriteProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: SizedBox(
                      height: 44.0,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${widget.category}\'s Fashion',
                          hintStyle: const TextStyle(color: Colors.black45),
                          contentPadding: const EdgeInsets.all(5.0),
                          filled: true,
                          fillColor: fbackgroundColor2,
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          prefixIcon: const Icon(Iconsax.search_normal),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    filterCategory.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black12)),
                          child: Row(
                            children: [
                              Text(filterCategory[index]),
                              const SizedBox(
                                width: 5.0,
                              ),
                              index == 0
                                  ? const Icon(
                                      Icons.filter_list,
                                      size: 15.0,
                                    )
                                  : const Icon(Icons.keyboard_arrow_down,
                                      size: 15.0)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  subcategory.length,
                  (index) {
                    return Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 5.0, 5.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 58.0,
                            width: 58.0,
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              subcategory[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(subcategory[index].name)
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: itemsCollection
                    .where('category', isEqualTo: widget.selectedCategory)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!.docs;
                    if (allItems.isEmpty) {
                      allItems = items;
                      filteredItems = items;
                    }
                    if (filteredItems.isEmpty) {
                      return const Center(
                        child: Text(
                          'No items found.',
                        ),
                      );
                    }

                    return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.65,
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 5.0,
                                crossAxisCount: 2),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final doc = filteredItems[index];
                          final item = doc.data() as Map<String, dynamic>;
                          final itemId = doc.id;
                          //check if random value are already
                          if (!randomValuecache.containsKey(itemId)) {
                            randomValuecache[itemId] = {
                              'rating':
                                  '${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}',
                              'reviews': Random().nextInt(300) + 100,
                            };
                          }
                          final cacheRating =
                              randomValuecache[itemId]!['rating'];
                          final cacheReviews =
                              randomValuecache[itemId]!['reviews'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemsDetaiScreen(
                                            productItems: doc,
                                          )));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: itemId,
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: fbackgroundColor2,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                item['image'],
                                              ))),
                                      height: size.height * 0.24,
                                      width: size.width * 0.48,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          radius: 16.0,
                                          backgroundColor:
                                              favrProvider.isExist(items[index])
                                                  ? Colors.white
                                                  : Colors.black26,
                                          child: GestureDetector(
                                            onTap: () {
                                              ref
                                                  .read(favoriteProvider)
                                                  .toigleFavorites(
                                                      items[index]);
                                            },
                                            child: Icon(
                                              favrProvider.isExist(items[index])
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favrProvider
                                                      .isExist(items[index])
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
                                        style: TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.w600),
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
                                        '$cacheRating',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '($cacheReviews)',
                                        style: const TextStyle(
                                            color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * 0.48,
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      item['name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${item['price']}.00',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            height: 1.4,
                                            color: Colors.red),
                                      ),
                                      const SizedBox(width: 5.0),
                                      if (item['isDiscounted'] == true)
                                        Text(
                                          '\$${(item['price'] * (1 - item['discountPercenttage'] / 100)).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.black26,
                                              fontSize: 18.0,
                                              height: 1.4,
                                              color: Colors.black26),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
