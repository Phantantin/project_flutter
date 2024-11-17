import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_1/pages/product_detail.dart';
import 'package:shopping_app_1/services/database.dart';
import 'package:shopping_app_1/widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  final String category;
  const CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream<QuerySnapshot>? categoryStream; // Nullable stream

  // Hàm này cần await để nhận đúng kiểu trả về
  Future<void> getOnTheLoad() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {}); // Cập nhật UI khi dữ liệu đã có
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad(); // Gọi hàm lấy dữ liệu khi widget khởi tạo
  }

  Widget allProducts() {
    // Kiểm tra nếu categoryStream có dữ liệu
    if (categoryStream == null) {
      return Center(
          child:
              CircularProgressIndicator()); // Hiển thị loading nếu chưa có dữ liệu
    }

    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream, // Truyền stream đã lấy được
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No products available."));
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Image.network(
                    ds["Image"],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 120);
                    },
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Text(
                      ds["Name"],
                      style: AppWidget.semiboldTextFeildStyle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${ds["Price"]}",
                        style: TextStyle(
                          color: Color(0xFFfd6f3e),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                detail: ds["Detail"],
                                image: ds["Image"],
                                name: ds["Name"],
                                price: ds["Price"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
                child:
                    allProducts()), // Dùng StreamBuilder để hiển thị sản phẩm
          ],
        ),
      ),
    );
  }
}
