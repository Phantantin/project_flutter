import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app_1/widget/support_widget.dart';

class AddProduct extends StatefulWidget {
  final Map<String, dynamic>? product; // Nhận dữ liệu sản phẩm
  final String? productId; // Nhận ID sản phẩm nếu sửa

  const AddProduct({super.key, this.product, this.productId});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? imageUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String? value;

  final _formKey = GlobalKey<FormState>();
  final List<String> categoryItems = ['Watch', 'Laptop', 'TV', 'Headphones'];

  @override
  void initState() {
    super.initState();

    // Nếu sản phẩm được truyền vào, hiển thị dữ liệu
    if (widget.product != null) {
      nameController.text = widget.product!['Name'] ?? '';
      priceController.text = widget.product!['Price'] ?? '';
      detailController.text = widget.product!['Detail'] ?? '';
      value = widget.product!['Category'] ?? null;
    }
  }

  // Yêu cầu quyền truy cập ảnh
  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  // Lấy ảnh từ gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path); // Cập nhật lại ảnh được chọn
      });
    }
  }

  // Kiểm tra và validate các trường nhập liệu
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập tên sản phẩm";
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập giá sản phẩm";
    }
    if (double.tryParse(value) == null) {
      return "Vui lòng nhập giá hợp lệ";
    }
    return null;
  }

  String? validateDetail(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập chi tiết sản phẩm";
    }
    return null;
  }

  // Upload ảnh và dữ liệu sản phẩm lên Firestore
  Future<void> uploadItem() async {
    // Kiểm tra xem có ảnh mới không và tên sản phẩm có trống không
    if ((selectedImage != null ||
            widget.product != null && widget.product!['Image'] != null) &&
        nameController.text.isNotEmpty) {
      String addId = widget.productId ?? randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("productImages").child(addId);

      // Nếu có ảnh mới được chọn, upload lên Firebase Storage và lấy URL
      if (selectedImage != null) {
        UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        imageUrl = await (await task).ref.getDownloadURL();
      } else if (widget.product != null && widget.product!['Image'] != null) {
        // Nếu không có ảnh mới, sử dụng ảnh cũ từ Firestore
        imageUrl = widget.product!['Image'];
      }

      // Tạo dữ liệu sản phẩm
      Map<String, dynamic> productData = {
        "Name": nameController.text,
        "Image": imageUrl,
        "Price": priceController.text,
        "Detail": detailController.text,
        "Category": value,
      };

      if (widget.productId != null) {
        // Cập nhật sản phẩm
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.productId)
            .update(productData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Sản phẩm được cập nhật thành công!"),
        ));
      } else {
        // Thêm sản phẩm mới
        await FirebaseFirestore.instance
            .collection('Products')
            .add(productData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Đã thêm sản phẩm thành công!"),
        ));
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Vui lòng điền chính xác tất cả các trường!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined)),
        title: Center(
          child: Text(
            widget.productId != null ? "Sửa sản phẩm" : "Thêm sản phẩm",
            style: AppWidget.semiboldTextFeildStyle(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload product image
                Text("Tải lên hình ảnh sản phẩm",
                    style: AppWidget.lightTextFeildStyle()),
                const SizedBox(height: 20.0),
                selectedImage == null && widget.product == null
                    ? GestureDetector(
                        onTap: getImage, // Bấm vào ảnh để chọn ảnh mới
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: getImage,
                        child: Center(
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: selectedImage != null
                                  ? Image.file(selectedImage!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover)
                                  : Image.network(widget.product!['Image'],
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),

                // Các trường nhập liệu ở dưới
                _buildTextField("Tên sản phẩm", nameController, validateName),
                _buildTextField("Giá sản phẩm", priceController, validatePrice,
                    isNumber: true),
                _buildTextField(
                    "Chi tiết sản phẩm", detailController, validateDetail,
                    maxLines: 4),
                _buildDropdownField("Loại", categoryItems, value, (newValue) {
                  setState(() {
                    value = newValue;
                  });
                }),

                // Button to submit or update the product
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: uploadItem,
                      child: Text(
                        widget.productId == null
                            ? "Thêm sản phẩm"
                            : "Sửa sản phẩm",
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String? Function(String?)? validator,
      {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidget.lightTextFeildStyle()),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              color: const Color(0xFFececf8),
              borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            validator: validator,
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      String? currentValue, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidget.lightTextFeildStyle()),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              color: const Color(0xFFececf8),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
              value: currentValue,
              hint: const Text("Chọn danh mục"),
              iconSize: 36,
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
