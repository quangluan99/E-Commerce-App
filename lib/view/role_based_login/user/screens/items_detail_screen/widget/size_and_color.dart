import 'package:ecommerce_app/core/common/utils/color_conversion.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final Function(int) onColorSelected;
  final Function(int) onSizeSelected;
  final int selectedColorIndex;
  final int selectedSizeIndex;
  const SizeAndColor(
      {super.key,
      required this.colors,
      required this.sizes,
      required this.onColorSelected,
      required this.onSizeSelected,
      required this.selectedColorIndex,
      required this.selectedSizeIndex});

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width / 2.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Colors',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.w500),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.colors.asMap().entries.map<Widget>(
                    (entr) {
                      final int index = entr.key;
                      final color = entr.value;

                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 10.0,
                        ),
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: getColorFromName(color),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.onColorSelected(index);
                              });
                            },
                            child: Icon(Icons.check,
                                color: widget.selectedColorIndex == index
                                    ? Colors.white
                                    : Colors.transparent),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width / 2.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Size',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.w500),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.sizes.asMap().entries.map<Widget>(
                    (entr) {
                      final int index = entr.key;
                      final size = entr.value;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: widget.selectedSizeIndex == index
                              ? Colors.black
                              : Colors.white,
                          child: InkWell(
                            onTap: () {
                              widget.onSizeSelected(index);
                            },
                            child: Text(
                              size,
                              style: TextStyle(
                                color: widget.selectedSizeIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
