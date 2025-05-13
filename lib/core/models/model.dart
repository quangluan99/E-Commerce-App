import 'package:flutter/material.dart';

class AppModel {
  final String name, image, description, category;
  final double rating;
  final int review, price;
  List<Color> fcolor;
  List<String> size;
  bool isCheck;

  AppModel(
      {required this.name,
      required this.image,
      required this.rating,
      required this.price,
      required this.review,
      required this.fcolor,
      required this.size,
      required this.description,
      required this.isCheck,
      required this.category});
}

List<AppModel> fashionEcomerceApp = [
  // id :1
  AppModel(
      name: 'Oversized Fit Printed Mesh T-Shirt',
      image: 'assets/category_image/image23.png',
      rating: 4.9,
      price: 294,
      review: 135,
      fcolor: [
        Colors.black,
        Colors.blue,
        Colors.blue[100]!,
      ],
      size: [
        'XS',
        'S',
        'M',
      ],
      description: '',
      isCheck: true,
      category: 'Women'),
  //id :2
  AppModel(
      name: 'Printed Sweatshirt',
      image: 'assets/category_image/image24.png',
      rating: 4.8,
      price: 313,
      review: 169,
      fcolor: [
        Colors.green,
        Colors.black,
        Colors.blue[100]!,
      ],
      size: [
        'S',
        'M',
        'XL',
      ],
      description: '',
      isCheck: true,
      category: 'Men'),
  //id :3
  AppModel(
      name: 'Loose Fit Sweatshirt',
      image: 'assets/category_image/image28.png',
      rating: 4.7,
      price: 188,
      review: 60,
      fcolor: [
        Colors.blue,
        Colors.red,
        Colors.purple,
      ],
      size: [
        'L',
        'XL',
        'XXL',
      ],
      description: '',
      isCheck: false,
      category: 'Men'),

  //id:4
  AppModel(
      name: 'Loose Fit Hoodie',
      image: 'assets/category_image/image7.png',
      rating: 5.0,
      price: 400,
      review: 28,
      fcolor: [
        Colors.brown,
        Colors.blueGrey,
        Colors.orange,
      ],
      size: [
        'S',
        'XL',
      ],
      description: '',
      isCheck: false,
      category: 'Men'),

  //id:5
  AppModel(
      name: 'DrvMove\' Track Jacket',
      image: 'assets/category_image/image8.png',
      rating: 4.1,
      price: 290,
      review: 31,
      fcolor: [
        Colors.black,
        Colors.orange,
        Colors.blueAccent,
      ],
      size: [
        'S',
        'L'
            'XL',
        'XXL'
      ],
      description: '',
      isCheck: false,
      category: 'Men'),
  //id:6
  AppModel(
      name: 'Regular Fit T-Shirt',
      image: 'assets/category_image/image22.png',
      rating: 3.9,
      price: 444,
      review: 46,
      fcolor: [
        Colors.brown,
        Colors.blueGrey,
        Colors.orange,
      ],
      size: [
        'S',
        'XL',
      ],
      description: '',
      isCheck: false,
      category: 'Men'),
  //id:7
  AppModel(
      name: 'Baby Frock',
      image: 'assets/category_image/image1.png',
      rating: 5.0,
      price: 340,
      review: 78,
      fcolor: [
        Colors.red,
        Colors.purple,
        Colors.pinkAccent,
      ],
      size: [
        'S',
        'M',
      ],
      description: '',
      isCheck: false,
      category: 'Baby'),
  //id:8
  AppModel(
      name: 'Coat For Man',
      image: 'assets/category_image/image2.png',
      rating: 4.5,
      price: 780,
      review: 80,
      fcolor: [
        Colors.blueAccent,
        Colors.pinkAccent,
        Colors.black,
      ],
      size: ['S', 'XL', 'M'],
      description: '',
      isCheck: true,
      category: 'Men'),

  //id:9
  AppModel(
      name: 'Baby Dress Set',
      image: 'assets/category_image/image3.png',
      rating: 5.0,
      price: 320,
      review: 80,
      fcolor: [
        Colors.blueAccent,
        Colors.pinkAccent,
        Colors.black,
      ],
      size: ['S', 'M', 'L'],
      description: '',
      isCheck: true,
      category: 'Baby'),
  //id:10
  AppModel(
      name: 'Casual Hoodie Dress For Kids',
      image: 'assets/category_image/image4.png',
      rating: 4.8,
      price: 420,
      review: 99,
      fcolor: [Colors.pink, Colors.black, Colors.deepPurple],
      size: ['S', 'M', 'L'],
      description: '',
      isCheck: true,
      category: 'Kids'),
  //id:11
  AppModel(
      name: 'Hoodie For Teens',
      image: 'assets/category_image/image6.png',
      rating: 4.5,
      price: 690,
      review: 180,
      fcolor: [Colors.blueAccent, Colors.red, Colors.purpleAccent],
      size: ['L', 'XL', 'M'],
      description: '',
      isCheck: true,
      category: 'Teens'),
  //id:13
  AppModel(
      name: 'Summer Jacket',
      image: 'assets/category_image/image9.png',
      rating: 4.8,
      price: 200,
      review: 44,
      fcolor: [Colors.blue, Colors.black, Colors.green],
      size: ['XXL', 'L', 'M'],
      description: '',
      isCheck: true,
      category: 'Men'),
  //id:14
  AppModel(
      name: 'Winter Jack',
      image: 'assets/category_image/image10.png',
      rating: 4.1,
      price: 900,
      review: 59,
      fcolor: [Colors.blue, Colors.black, Colors.yellow],
      size: ['S', 'Xl', 'xxL'],
      description: '',
      isCheck: true,
      category: 'Teens'),
  //  //id:15
  AppModel(
      name: 'Pain and Shirt',
      image: 'assets/category_image/image11.png',
      rating: 4.6,
      price: 500,
      review: 129,
      fcolor: [Colors.red, Colors.black, Colors.blueAccent],
      size: ['S', 'M', 'XS'],
      description: '',
      isCheck: true,
      category: 'Baby'),
  //id:16
  AppModel(
      name: 'Mix Double Set',
      image: 'assets/category_image/image12.png',
      rating: 3.9,
      price: 102,
      review: 159,
      fcolor: [Colors.pink, Colors.black, Colors.greenAccent],
      size: ['S', 'L', 'xL'],
      description: '',
      isCheck: false,
      category: 'Teens'),
  //id:17
  AppModel(
      name: 'Coat For Women',
      image: 'assets/category_image/image13.png',
      rating: 4.4,
      price: 202,
      review: 70,
      fcolor: [Colors.blueAccent, Colors.green, Colors.grey],
      size: ['M', 'L', 'xL'],
      description: '',
      isCheck: false,
      category: 'Women'),

  //id:19
  AppModel(
      name: 'Complete Dress',
      image: 'assets/category_image/image15.png',
      rating: 4.5,
      price: 208,
      review: 180,
      fcolor: [Colors.purple, Colors.green, Colors.red],
      size: ['S', 'L', 'xL'],
      description: '',
      isCheck: false,
      category: 'Teens'),

  //id:20
  AppModel(
      name: 'Summer Kurti',
      image: 'assets/category_image/image27.png',
      rating: 5.0,
      price: 102,
      review: 130,
      fcolor: [Colors.blueGrey, Colors.orange, Colors.black],
      size: ['S', 'M', 'XXL'],
      description: '',
      isCheck: true,
      category: 'Women'),
  //id:21
  AppModel(
      name: 'Loose Sweater',
      image: 'assets/category_image/image17.png',
      rating: 4.4,
      price: 120,
      review: 80,
      fcolor: [Colors.blueGrey, Colors.orange, Colors.black],
      size: ['L', 'XL', 'XXL'],
      description: '',
      isCheck: true,
      category: 'Teens'),
  //id:22
  AppModel(
      name: 'T-Shirt for Women',
      image: 'assets/category_image/image16.png',
      rating: 5.0,
      price: 102,
      review: 130,
      fcolor: [Colors.black12, Colors.blueAccent, Colors.black],
      size: ['S', 'XS', 'XXL'],
      description: '',
      isCheck: false,
      category: 'Women'),
  //id:23
  AppModel(
      name: 'Kids T-Shirt ',
      image: 'assets/category_image/image26.png',
      rating: 4.9,
      price: 200,
      review: 60,
      fcolor: [Colors.blueAccent, Colors.red, Colors.black],
      size: ['S', 'M', 'XXL'],
      description: '',
      isCheck: true,
      category: 'Kids'),
];

const myDescription1 = "Elevate your casual wardrobe with our";
const myDescription2 =
    ".Crated from prenium cotton for maxium comfort, this relaxed-fit tee featured ";
