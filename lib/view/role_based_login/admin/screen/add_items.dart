// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:ecommerce_app/view/role_based_login/admin/controller/add_items_controller.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/my_button.dart';
import 'package:ecommerce_app/view/role_based_login/admin/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItems extends ConsumerStatefulWidget {
  const AddItems({super.key});

  @override
  ConsumerState<AddItems> createState() {
    return _AddItemsState();
  }
}

class _AddItemsState extends ConsumerState<AddItems> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _sizecontroller = TextEditingController();
  final TextEditingController _colorcontroller = TextEditingController();
  final TextEditingController _discountpercentagecontroller =
      TextEditingController();

  @override
  void dispose() {
    _namecontroller.dispose();
    _pricecontroller.dispose();
    _sizecontroller.dispose();

    _colorcontroller.dispose();
    _discountpercentagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Add new Items'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: notifier.pickImage,
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    File(state.imagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 30.0,
                                ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Name
                TextFormField(
                  controller: _namecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name can\'t empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Price
                TextFormField(
                  controller: _pricecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid price, price must be number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Category selection
                DropdownButtonFormField<String>(
                  value: state.selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: notifier.setSelectedCategory,
                  items: state.categories.map(
                    (String category) {
                      return DropdownMenuItem<String>(
                          value: category, child: Text(category));
                    },
                  ).toList(),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Size
                TextField(
                  controller: _sizecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Sizes (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    notifier.addSize(value);
                    _sizecontroller.clear();
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: state.sizes
                      .map(
                        (size) => Chip(
                            onDeleted: () => notifier.removeSize(size),
                            label: Text(size)),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Color
                TextField(
                  controller: _colorcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Color (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    notifier.addColor(value);
                    _colorcontroller.clear();
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: state.colors
                      .map(
                        (colors) => Chip(
                            onDeleted: () => notifier.removeColor(colors),
                            label: Text(colors)),
                      )
                      .toList(),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: state.isDiscounted,
                        onChanged: notifier.toggleDiscount),
                    const Text('Apply Discount'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                if (state.isDiscounted)
                  Column(
                    children: [
                      // Discount
                      TextField(
                        controller: _discountpercentagecontroller,
                        decoration: const InputDecoration(
                          labelText: 'Discount Percentage (%)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          notifier.setDiscountPercentage(value);
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 15.0,
                ),
                state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: MyButton(
                            onTab: () async {
                              try {
                                await notifier.updloadAndSaveItem(
                                    _namecontroller.text,
                                    _pricecontroller.text);
                                showSnackBar(
                                    context, 'Item added Successfully');
                                Navigator.of(context).pop();
                              } catch (e) {
                                showSnackBar(context, 'Error : $e');
                              }
                            },
                            buttonText: "Save Item"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
