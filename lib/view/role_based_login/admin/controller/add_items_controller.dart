import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/view/role_based_login/admin/model/add_items_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final addItemProvider = StateNotifierProvider<AdditemNotifier, AddItemState>(
  (ref) {
    return AdditemNotifier();
  },
);

class AdditemNotifier extends StateNotifier<AddItemState> {
  AdditemNotifier() : super(AddItemState()) {
    fetchCategory();
  }
  //create a collection
//for storing all the  items on this collection

  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');

//for category
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('Category');

//for image picker

  void pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state = state.copyW(imagePath: pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  //to select the category Items
  void setSelectedCategory(String? category) {
    state = state.copyW(selectedCategory: category);
  }

  //for size
  void addSize(String size) {
    state = state.copyW(sizes: [...state.sizes, size]);
  }

  void removeSize(String size) {
    state = state.copyW(sizes: state.sizes.where((s) => s != size).toList());
  }

  //for color

  void addColor(String color) {
    state = state.copyW(colors: [...state.colors, color]);
  }

  void removeColor(String color) {
    state = state.copyW(colors: state.colors.where((c) => c != color).toList());
  }

//for discount
  void toggleDiscount(bool? isDiscounted) {
    state = state.copyW(isDiscounted: isDiscounted);
  }

  void setDiscountPercentage(String percentage) {
    state = state.copyW(discountPercentage: percentage);
  }

  //to handle the loading indicator
  void setLoading(bool isLoading) {
    state = state.copyW(isLoading: isLoading);
  }

  //to fetch the category items
  Future<void> fetchCategory() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categories = snapshot.docs
          .map(
            (docu) => docu['name'] as String,
          )
          .toList();
      state = state.copyW(categories: categories);
    } catch (e) {
      throw Exception('Error saving item : $e');
    }
  }

// to upload and save the items
  Future<void> updloadAndSaveItem(String name, String price) async {
    if (name.isEmpty ||
        price.isEmpty ||
        state.imagePath == null ||
        state.selectedCategory == null ||
        state.sizes.isEmpty ||
        state.colors.isEmpty ||
        (state.isDiscounted && state.discountPercentage == null)) {
      throw Exception("Please fill all the field an upload an image.");
    }
    state = state.copyW(isLoading: true);
    try {
      //upload image to firebase storage
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final reference = FirebaseStorage.instance.ref().child('image/$fileName');
      await reference.putFile(File(state.imagePath!));
      final imageUrl = await reference.getDownloadURL();
      //save item to firestore
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await items.add({
        'name': name,
        'price': int.tryParse(price),
        'image': imageUrl,
        'uploadedBy': uid,
        'category': state.selectedCategory,
        'size': state.sizes,
        'fcolor': state.colors,
        'isDiscounted': state.isDiscounted,
        'discountPercenttage':
            state.isDiscounted ? int.tryParse(state.discountPercentage!) : 0,
      });

      //Reset state after successfully upload the data
      state = AddItemState(
        imagePath: null,
        isLoading: false,
        selectedCategory: null,
        categories: [fetchCategory().toString()],
        sizes: [],
        colors: [],
        isDiscounted: false,
        discountPercentage: null,
      );
    } catch (e) {
      throw Exception('Error saving item : $e');
    } finally {
      state = state.copyW(isLoading: false);
    }
  }
}
