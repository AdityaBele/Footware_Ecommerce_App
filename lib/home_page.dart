import 'package:client_footware/Controller/home_controller.dart';
import 'package:client_footware/login_page.dart';
import 'package:client_footware/product_description_page.dart';
import 'package:client_footware/widget/Product_card.dart';
import 'package:client_footware/widget/dropdown_button.dart';
import 'package:client_footware/widget/muilti_select_drop_drown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'model/product/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      assignId: true,
      builder: (ctrl) {
        return RefreshIndicator(
          onRefresh: ()async{
            ctrl.fetchProduct();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Footware Store',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GetStorage box = GetStorage();
                      // box.erase();
                      Get.offAllNamed('/login');
                    },
                    icon: Icon(Icons.login))
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ctrl.productCategory.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            ctrl.filterByCategory(ctrl.productCategory[index].name ?? '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Chip(
                                label:
                                    Text(ctrl.productCategory[index].name ?? '')),
                          ),
                        );
                      }),
                ),
                Row(
                  children: [
                    Flexible(
                      child: DropDownBtn(
                        items: ['Rs: Low to High', 'Rs: High to Low'],
                        selectedItemText: "Sort",
                        onseleted: (SelectedValue) {
                          print(SelectedValue);
                          ctrl.sortByPrice(ascending: SelectedValue == 'Rs: Low to High'? true : false);
                        },
                      ),
                    ),
                    Flexible(
                      child: MultiSelectDropDown(
                        items: ['Puma', 'Nike', 'Adidas','New Balancia','Bata','Local Brand'],
                        onSelectionChange: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                      itemCount: ctrl.productShowInUi.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          name: ctrl.productShowInUi[index].name ?? '',
                          imageUrl: ctrl.productShowInUi[index].image ?? '',
                          price: ctrl.productShowInUi[index].price ?? 00,
                          offer: '20% off',
                          onTap: () {
                           Get.toNamed('/product',arguments: {'data':ctrl.productShowInUi[index]});
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
