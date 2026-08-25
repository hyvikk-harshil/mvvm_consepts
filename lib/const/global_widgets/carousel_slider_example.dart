import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderImager extends StatelessWidget {
  const CarouselSliderImager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            height: MediaQuery.sizeOf(context).height-300,
            enlargeCenterPage: true, // Make the center image pop out
            aspectRatio: 16 / 9,        // Aspect ratio of the slider area
          ),
          items: [1,2,3,4,5].map((i){
            return Container(
              //width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: Colors.blue),
              child:Center(child: Text("Slide $i",style: TextStyle(fontSize:24,color: Colors.white),)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
