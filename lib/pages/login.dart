import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_1/pages/bottomnav.dart';
import 'package:shopping_app_1/pages/signup.dart';
import 'package:shopping_app_1/widget/support_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Hàm đăng nhập người dùng
  userLogin() async {
    try {
      // Thử đăng nhập với email và mật khẩu
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Nếu đăng nhập thành công, điều hướng tới màn hình BottomNav
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi nếu xảy ra
      String errorMessage = '';
      if (e.code == "user-not-found") {
        errorMessage = "Không tìm thấy người dùng với email này!";
      } else if (e.code == "wrong-password") {
        errorMessage = "Mật khẩu không đúng!";
      } else {
        errorMessage = "Lỗi đăng nhập. Vui lòng thử lại.";
      }

      // Hiển thị thông báo lỗi trên giao diện
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo hoặc hình ảnh đăng nhập
                Image.asset("images/login.png"),

                // Tiêu đề đăng nhập
                Center(
                  child: Text(
                    "Đăng Nhập",
                    style: AppWidget.semiboldTextFeildStyle(),
                  ),
                ),
                SizedBox(height: 20.0),

                // Mô tả về đăng nhập
                Text(
                  "Vui lòng nhập thông tin bên dưới để tiếp tục.",
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 40.0),

                // Label và trường nhập email
                Text(
                  "Email",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                    emailController, "Email", "Vui lòng nhập email của bạn",
                    emailValidation: true),

                SizedBox(height: 20.0),

                // Label và trường nhập mật khẩu
                Text(
                  "Mật khẩu",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                _buildTextField(passwordController, "Mật khẩu",
                    "Vui lòng nhập mật khẩu của bạn",
                    obscureText: true, passwordValidation: true),

                SizedBox(height: 20.0),

                // Link quên mật khẩu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                SizedBox(height: 30.0),

                // Nút đăng nhập
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = emailController.text;
                        password = passwordController.text;
                      });
                      userLogin(); // Gọi hàm đăng nhập khi form đã validate
                    }
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                // Liên kết tới màn hình đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn chưa có tài khoản? ",
                      style: AppWidget.lightTextFeildStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Đăng Ký",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget tạo các trường nhập liệu với validator
  Widget _buildTextField(TextEditingController controller, String labelText,
      String validationMessage,
      {bool obscureText = false,
      bool emailValidation = false,
      bool passwordValidation = false}) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          if (emailValidation &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Email không hợp lệ";
          }
          if (passwordValidation && value.length < 6) {
            return "Mật khẩu không đúng. Vui lòng nhập lại";
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText,
        ),
      ),
    );
  }
}
