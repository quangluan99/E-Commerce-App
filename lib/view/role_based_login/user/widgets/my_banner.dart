import 'package:ecommerce_app/core/common/utils/colors.dart';
import 'package:flutter/material.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 18.0),
        height: size.height * 0.23,
        width: size.width,
        color: bannerColor,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'NEW COLLECTIONs',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0),
                ),
                const Row(
                  children: [
                    Text(
                      '20',
                      style: TextStyle(
                          letterSpacing: -2,
                          // height: 0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 36),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '%',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.0),
                        ),
                        Text(
                          'OFF',
                          style: TextStyle(
                              letterSpacing: -1,
                              color: Colors.black,
                              height: 0.3,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0),
                        )
                      ],
                    )
                  ],
                ),
                MaterialButton(
                  color: Colors.black26,
                  onPressed: () {},
                  child: const Text(
                    'SHOP NOW',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/girls.png',
                fit: BoxFit.cover,
                height: size.height * 0.20,
              ),
            )
          ],
        ));
  }
}
