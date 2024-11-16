import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_1/Admin/add_product.dart';
import 'package:shopping_app_1/Admin/all_orders.dart';
import 'package:shopping_app_1/Admin/view_product.dart';
import 'package:shopping_app_1/model/dashboard_btn_model.dart';
import 'package:shopping_app_1/providers/theme_provider.dart';
import 'package:shopping_app_1/widget/dashboard_btn_widget.dart';
import 'package:shopping_app_1/widget/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    // Lấy provider ThemeProvider
    final themeProvider = context.watch<ThemeProvider>();

    // Tạo danh sách các nút điều khiển Dashboard
    List<DashboardButtonsModel> dashboardBtns =
        DashboardButtonsModel.dashboardBtnList(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Home Admin",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("images/shopping_cart.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Thay đổi theme khi nhấn vào icon
              themeProvider.setDarkTheme(
                themeValue: !themeProvider.getIsDarkTheme,
              );
            },
            icon: Icon(
              themeProvider.getIsDarkTheme ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: List.generate(
          dashboardBtns.length, // Duyệt qua danh sách các nút
          (index) => Padding(
            padding: const EdgeInsets.all(8),
            child: DashboardButtonWidget(
              title: dashboardBtns[index].text,
              imagePath: dashboardBtns[index].imagePath,
              onPressed: dashboardBtns[index].onPressed,
            ),
          ),
        ),
      ),
    );
  }
}



















  //   return Scaffold(
  //     backgroundColor: Color(0xfff2f2f2),
  //     appBar: AppBar(
  //       backgroundColor: Color(0xfff2f2f2),
  //       title: Center(
  //         child: Text(
  //           'Home Admin',
  //           style: AppWidget.boldTextFeildStyle(),
  //         ),
  //       ),
  //     ),
  //     body: Container(
  //       margin: EdgeInsets.only(left: 20.0, right: 20.0),
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             height: 50.0,
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => AddProduct()));
  //             },
  //             child: Material(
  //               elevation: 3.0,
  //               borderRadius: BorderRadius.circular(10),
  //               child: Container(
  //                 padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.add,
  //                       size: 50.0,
  //                     ),
  //                     SizedBox(
  //                       width: 20.0,
  //                     ),
  //                     Text(
  //                       "Add Product",
  //                       style: AppWidget.boldTextFeildStyle(),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 80.0,
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => AllOrders()));
  //             },
  //             child: Material(
  //               elevation: 3.0,
  //               borderRadius: BorderRadius.circular(10),
  //               child: Container(
  //                 padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.shopping_bag_outlined,
  //                       size: 50.0,
  //                     ),
  //                     SizedBox(
  //                       width: 20.0,
  //                     ),
  //                     Text(
  //                       "All Orders",
  //                       style: AppWidget.boldTextFeildStyle(),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 80.0,
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ViewProduct()));
  //             },
  //             child: Material(
  //               elevation: 3.0,
  //               borderRadius: BorderRadius.circular(10),
  //               child: Container(
  //                 padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10)),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.view_headline,
  //                       size: 50.0,
  //                     ),
  //                     SizedBox(
  //                       width: 20.0,
  //                     ),
  //                     Text(
  //                       "View Products",
  //                       style: AppWidget.boldTextFeildStyle(),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }