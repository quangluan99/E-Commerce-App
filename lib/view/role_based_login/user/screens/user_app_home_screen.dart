import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/cart_oder_count.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/core/models/category_model.dart';
import 'package:ecommerce_app/view/role_based_login/user/screens/category_items.dart';
import 'package:ecommerce_app/view/role_based_login/user/screens/items_detail_screen/screen/items_detai_screen.dart';
import 'package:ecommerce_app/view/role_based_login/user/widgets/curated_items.dart';
import 'package:ecommerce_app/view/role_based_login/user/widgets/my_banner.dart';
import 'package:flutter/material.dart';

class UserAppHomeScreen extends StatefulWidget {
  const UserAppHomeScreen({super.key});

  @override
  State<UserAppHomeScreen> createState() => _UserAppHomeScreenState();
}

class _UserAppHomeScreenState extends State<UserAppHomeScreen> {
  //for Category collection
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection('Category');
  //for e-commerce items collection
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 36.0,
                  ),
                  const CartOderCount(),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const MyBanner(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shop By Category',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 15.0, color: Colors.black45),
                  )
                ],
              ),
            ),
            //for category
            StreamBuilder(
              stream: categoriesItems.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        streamSnapshot.data!.docs.length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              // final filteritems = fashionEcomerceApp
                              //     .where(
                              //       (item) =>
                              //           item.category.toLowerCase() ==
                              //           category[index].name.toLowerCase(),
                              //     )
                              //     .toList();
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CategoryItems(
                                    category: streamSnapshot.data!.docs[index]
                                        ['name'],
                                    selectedCategory: streamSnapshot
                                        .data!.docs[index]['name'],
                                  );
                                },
                              ));
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: CircleAvatar(
                                    radius: 28.0,
                                    backgroundColor: fbackgroundColor1,
                                    backgroundImage:
                                        AssetImage(category[index].image),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(category[index].name),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Curated For you',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 15.0, color: Colors.black45),
                  )
                ],
              ),
            ),
            //for curated items
            StreamBuilder(
                stream: items.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          snapshot.data!.docs.length,
                          (index) {
                            final eCommerceItems = snapshot.data!.docs[index];
                            return Padding(
                              padding: index == 0
                                  ? const EdgeInsets.symmetric(horizontal: 18.0)
                                  : const EdgeInsets.only(right: 18.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemsDetaiScreen(
                                          productItems: eCommerceItems,
                                        ),
                                      ));
                                },
                                child: CuratedItems(
                                    eCommerceItems: eCommerceItems, size: size),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      )),
    );
  }
}
