import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget {
  final String name;
  final String email;
  final String product;
  final String price;
  final String image;
  final String status;
  final String productImage; // Thêm ảnh sản phẩm

  OrderDetail({
    required this.name,
    required this.email,
    required this.product,
    required this.price,
    required this.image,
    required this.status,
    required this.productImage, // Khởi tạo ảnh sản phẩm
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh người dùng (chỉnh lại thành hình tròn)
            ClipOval(
              child: Image.network(
                image,
                width: 60.0, // Chiều rộng của ảnh
                height: 60.0, // Chiều cao của ảnh
                fit: BoxFit.cover, // Cắt ảnh cho phù hợp với hình tròn
              ),
            ),

            // Hiển thị các thông tin đơn hàng
            Text("Name: $name", style: TextStyle(fontSize: 18)),
            Text("Email: $email", style: TextStyle(fontSize: 18)),
            Text("Sản phẩm: $product", style: TextStyle(fontSize: 18)),
            Text("Giá: \$ $price", style: TextStyle(fontSize: 18)),
            Text("Trạng thái: $status", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10.0),

            // Hình ảnh sản phẩm
            Image.network(
              productImage,
              width: double.infinity, // Mở rộng chiều rộng của ảnh sản phẩm
              height: 200, // Chiều cao của ảnh sản phẩm
              fit: BoxFit.cover, // Cắt ảnh cho phù hợp với khung
            ),
            SizedBox(height: 10.0),
            // Các thông tin chi tiết khác có thể được thêm vào đây
          ],
        ),
      ),
    );
  }
}
