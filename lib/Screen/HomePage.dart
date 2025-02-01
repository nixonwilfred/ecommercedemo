import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Controllers/HomeController.dart';
import '../Models/Banner_model.dart';
import '../Services/fetchBanners.dart';
import 'ProfileScreen.dart';
class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          HomeScreen(controller: controller),
          WishlistScreen(controller: controller),
          ProfileScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      )),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final HomeController controller;
  HomeScreen({required this.controller});

  @override

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadProducts();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: TextField(
                onChanged: (value) {
                  controller.updateSearchQuery(value);  // Update the search query
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),


        FutureBuilder<List<BannerModel>>(
              future: fetchBanners(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState("No banners available");
                } else {
                  return Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.27,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9
                      ),
                      items: snapshot.data!.map((banner) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to a banner details page or perf  orm an action
                            // Get.to(() => BannerDetailScreen(banner: banner));
                          },
                          child: Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.017),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              child: CachedNetworkImage(
                                imageUrl: banner.imageUrl,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),




            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                "Popular Product",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              ),
            ),
            FutureBuilder(
              future: controller.loadProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return Obx(() {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenWidth * 0.03,
                      childAspectRatio: screenWidth > 600 ? 4 / 5 : 3 / 4,
                    ),
                    itemCount: controller.filteredProductList.length,  // Use filtered product list
                    itemBuilder: (context, index) {
                      final product = controller.filteredProductList[index];
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.02), // Ensures smooth edges
                                  child: CachedNetworkImage(
                                    imageUrl: product.featuredImage,
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.cover, //
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),


                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Obx(() => IconButton(
                                    icon: Icon(
                                      product.inWishlist.value ? Icons.favorite : Icons.favorite_border,
                                      color: product.inWishlist.value ? Colors.red : Colors.white,
                                    ),
                                    onPressed: () async {
                                      await controller.manageWishlist(product);
                                      // await controller.loadWishlist();
                                    },
                                  )),
                                )

                              ],
                            ),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width:screenHeight * 0.003),

                              Text("${product.mrp}",
                                style: TextStyle(
                                  color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                ),),
                              SizedBox(width:screenHeight * 0.005),

                              Text('₹${product.salePrice}',
                              style: TextStyle(
                                color: Colors.purple.shade700 ,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight*0.015
                              ),),
                              SizedBox(width:screenHeight * 0.047),


                              Icon(Icons.star,color: Colors.yellow.shade800,
                              size: screenHeight*0.017,),
                              SizedBox(width:screenHeight * 0.005),


                              Text('${product.taxRate}',
                                style: TextStyle(
                                    color: Colors.purple.shade700 ,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight*0.015
                                ),)
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft
                            ,child: Text(" ${product.name}\t",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ],
                      );
                    },
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}




class WishlistScreen extends StatelessWidget {
  final HomeController controller;
  WishlistScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      if (controller.wishlist.isEmpty) {
        return Center(child: Text("Your wishlist is empty."));
      }

      return Scaffold(appBar: AppBar(
        title:Text("Wishlist",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold
        ),),
      ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(screenWidth * 0.03),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                crossAxisSpacing: screenWidth * 0.03,
                mainAxisSpacing: screenWidth * 0.03,
                childAspectRatio: screenWidth > 600 ? 4 / 5 : 3 / 4,
              ),
              itemCount: controller.wishlist.length,
              itemBuilder: (context, index) {
                final product = controller.wishlist[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children:[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(screenHeight*0.007),
                              child: CachedNetworkImage(
                                height: screenHeight*0.2,
                              imageUrl: product.featuredImage,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: double.infinity,
                                                        ),
                            ),


                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  product.inWishlist.value ? Icons.favorite : Icons.favorite_border,
                                  color: product.inWishlist.value ? Colors.red : Colors.grey,
                                ),
                                onPressed: () async {
                                  await controller.manageWishlist(product); // Call wishlist toggle
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('₹${product.salePrice}'),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                    ],
                  ),


                );
              },
                    ),
            ),
          ],
        )
        );


    });
  }
}
Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning, size: 50, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    ),
  );
}



