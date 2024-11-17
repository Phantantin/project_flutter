import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app_1/Admin/add_product.dart';
import 'package:shopping_app_1/widget/support_widget.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  // Hàm xử lý khi chỉnh sửa sản phẩm
  // void editProduct(QueryDocumentSnapshot product) {
  //   // Logic chỉnh sửa sản phẩm (ví dụ: mở màn hình chỉnh sửa)
  //   print("Chỉnh sửa sản phẩm: ${product['Name']}");
  // }
  void editProduct(QueryDocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduct(
          product: product.data() as Map<String, dynamic>,
          productId: product.id,
        ),
      ),
    );
  }

  // Hàm xử lý khi xóa sản phẩm
  void deleteProduct(String docId) async {
    bool confirmDelete = (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận'),
            content:
                const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        )) ??
        false; // Nếu null, mặc định trả về false

    if (confirmDelete) {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Đã xóa sản phẩm thành công!'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Center(
          child: Text(
            'Xem sản phẩm',
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Products').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Đã xảy ra lỗi!'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var product = snapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Hình ảnh sản phẩm
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product['Image'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['Name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Giá: \$${product['Price']}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Chi tiết:",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product['Detail'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => editProduct(product),
                              icon: const Icon(Icons.edit, color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () => deleteProduct(product.id),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
