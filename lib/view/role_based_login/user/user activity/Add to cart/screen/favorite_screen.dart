import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favrProvider = ref.watch(favoriteProvider);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        backgroundColor: fbackgroundColor2,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: fbackgroundColor2,
          centerTitle: true,
          title: const Text(
            'Favorite',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: userId == null
            ? const Center(
                child: Center(
                  child: Text('Please login to view favorites'),
                ),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userFavorite')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final favoriteDocs = snapshot.data!.docs;
                  if (favoriteDocs.isEmpty) {
                    return const Center(
                      child: Text('No favorites yet!'),
                    );
                  }
                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: Future.wait(favoriteDocs.map(
                      (doc) => FirebaseFirestore.instance
                          .collection('items')
                          .doc(doc.id)
                          .get(),
                    )),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final favoritesItems = snapshot.data!
                          .where(
                            (doc) => doc.exists,
                          )
                          .toList();
                      if (favoritesItems.isEmpty) {
                        return const Center(
                          child: Text('No favorites yet!!!'),
                        );
                      }
                      return ListView.builder(
                        itemCount: favoritesItems.length,
                        itemBuilder: (context, index) {
                          final favoriteItem = favoritesItems[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                  favoriteItem['image']),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0),
                                              child: Text(
                                                favoriteItem['name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                                '${favoriteItem['category']} Fashion'),
                                            Text(
                                              '${favoriteItem['price']}.00',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 50,
                                    right: 30,
                                    child: InkWell(
                                      onTap: () {
                                        favrProvider
                                            .toigleFavorites(favoriteItem);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ))
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ));
  }
}
