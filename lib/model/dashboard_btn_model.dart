import 'package:flutter/material.dart';
import 'package:shopping_app_1/Admin/add_product.dart';
import 'package:shopping_app_1/Admin/all_orders.dart';
import 'package:shopping_app_1/Admin/all_user.dart';
import 'package:shopping_app_1/Admin/view_product.dart';

class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(BuildContext context) => [
        DashboardButtonsModel(
          text: "Thêm sản phẩm",
          imagePath: "images/dashboard/cloud.png", // Store the path as string
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
        ),
        DashboardButtonsModel(
          text: "Tất cả sản phẩm",
          imagePath: "images/shopping_cart.png", // Store the path as string
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewProduct()));
          },
        ),
        DashboardButtonsModel(
          text: "Giỏ hàng",
          imagePath: "images/dashboard/order.png", // Fixed typo in path
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AllOrders()));
          },
        ),
        DashboardButtonsModel(
          text: "Người dùng",
          imagePath: "images/user.png", // Fixed typo in path
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AllUsers()));
          },
        ),
      ];
}
