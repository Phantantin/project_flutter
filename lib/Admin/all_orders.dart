import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_1/services/database.dart';
import 'package:shopping_app_1/widget/support_widget.dart';
import 'order_detail.dart'; // Import OrderDetail widget

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  late Stream<QuerySnapshot> orderStream;

  @override
  void initState() {
    super.initState();
    orderStream = DatabaseMethods().allOrders(); // Stream các đơn hàng
  }

  // Widget hiển thị tất cả đơn hàng
  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator()); // Hiển thị vòng tròn chờ
        }

        var orders = snapshot.data.docs;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: orders.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = orders[index];

            // Kiểm tra trạng thái đơn hàng
            String status = ds["Status"];
            bool isDelivered =
                status == "Delivered"; // Kiểm tra trạng thái "Delivered"

            // Hiển thị đơn hàng nhưng áp dụng hiệu ứng mờ nếu trạng thái là "Delivered"
            return Opacity(
              opacity: isDelivered ? 0.3 : 1.0, // Nếu đã giao, độ mờ sẽ là 30%
              child: GestureDetector(
                onTap: () {
                  // Điều hướng đến màn hình chi tiết đơn hàng khi nhấn vào
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetail(
                        name: ds["Name"],
                        email: ds["Email"],
                        product: ds["Product"],
                        price: ds["Price"].toString(),
                        image: ds["Image"], // Hình ảnh người dùng
                        status: ds["Status"],
                        productImage: ds["ProductImage"], // Ảnh sản phẩm
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            ds["Image"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name : " + ds["Name"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                SizedBox(height: 3.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    "Email : " + ds["Email"],
                                    style: AppWidget.lightTextFeildStyle(),
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  ds["Product"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                Text("\$" + ds["Price"],
                                    style: TextStyle(
                                        color: Color(0xFFfd6f3e),
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10.0),
                                // Button "Done"
                                GestureDetector(
                                  onTap: () async {
                                    // Cập nhật trạng thái "Delivered"
                                    await DatabaseMethods().updateStatus(ds.id);
                                    setState(() {}); // Cập nhật lại giao diện
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfd6f3e),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Done",
                                        style:
                                            AppWidget.semiboldTextFeildStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "All Orders",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }
}
