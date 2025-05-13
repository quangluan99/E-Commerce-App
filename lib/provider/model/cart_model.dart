class CartModel {
  final String productId; // Use the product ID from Firebase

  final Map<String, dynamic> productData; // Store product details as a map
  int quantity;
  final String selectedColor; // New field for selected color
  final String selectedSize;

  CartModel({
    required this.productId,
    required this.productData,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });
}
