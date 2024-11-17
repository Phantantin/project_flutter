import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late Stream<QuerySnapshot> usersStream;

  @override
  void initState() {
    super.initState();
    usersStream = FirebaseFirestore.instance
        .collection("users")
        .snapshots(); // Lấy tất cả người dùng từ Firestore
  }

  // Widget hiển thị danh sách người dùng
  Widget allUsers() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child:
                  CircularProgressIndicator()); // Hiển thị vòng tròn chờ nếu chưa có dữ liệu
        }

        var users = snapshot.data.docs;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: users.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = users[index];

            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị ảnh người dùng
                      Image.network(
                        ds['Image'] ??
                            "images/avatar.png", // Nếu không có trường "Image", sẽ dùng "images/avatar.png"
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(width: 10.0),
                      Expanded(
                        // Dùng Expanded để giãn cách các widget con trong Row
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name : " + (ds["Name"] ?? "No Name"),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Email : " + (ds["Email"] ?? "No Email"),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Các nút Edit và Delete
                      // IconButton(
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () {
                      //     _editUser(ds);
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(ds.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hàm xử lý Edit
  void _editUser(DocumentSnapshot ds) {
    // Ví dụ đơn giản, có thể mở một màn hình mới để chỉnh sửa thông tin
    print("Edit user: ${ds['Name']}");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserScreen(userId: ds.id)));
  }

  // Hàm xác nhận trước khi xóa
  void _confirmDelete(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa người dùng"),
          content: Text("Bạn có chắc chắn muốn xóa người dùng này?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại nếu chọn Cancel
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng hộp thoại
                await _deleteUser(userId); // Xóa người dùng sau khi xác nhận
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý Delete
  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .delete(); // Xóa người dùng khỏi Firestore
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error deleting user")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "All Users", // Tiêu đề màn hình
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allUsers()) // Hiển thị danh sách người dùng
          ],
        ),
      ),
    );
  }
}
