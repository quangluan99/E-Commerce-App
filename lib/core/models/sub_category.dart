class SubCategory {
  final String name, image;
  const SubCategory({required this.name, required this.image});
}

List<SubCategory> subcategory = [
  const SubCategory(
    name: "Bags",
    image: "assets/category_image/sub_category/image6.png",
  ),
  const SubCategory(
    name: "Wallets",
    image: "assets/category_image/sub_category/image3.png",
  ),
  const SubCategory(
    name: "Footwear",
    image: "assets/category_image/sub_category/image4.png",
  ),
  const SubCategory(
    name: "Clothes",
    image: "assets/category_image/sub_category/image5.png",
  ),
  const SubCategory(
    name: "Watch",
    image: "assets/category_image/sub_category/image1.png",
  ),
  const SubCategory(
    name: "Makeup",
    image: "assets/category_image/sub_category/image2.png",
  )
];
List<String> filterCategory = [
  'Filter',
  'Ratings',
  'Size',
  'Color',
  'Price',
  'Brand',
];
