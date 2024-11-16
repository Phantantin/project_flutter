import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shopping_app_1/pages/bottomnav.dart';
import 'package:shopping_app_1/pages/login.dart';
import 'package:shopping_app_1/services/database.dart';
import 'package:shopping_app_1/services/shared_pref.dart';
import '../widget/support_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.setLanguageCode("vi");
    print(FirebaseAuth.instance.languageCode);
  }

  Future<void> register() async {
    if (name != null && email != null && password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(
              "Đăng ký thành công",
              style: TextStyle(fontSize: 20.0),
            )));

        String userId = randomAlphaNumeric(10);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserId(userId);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserImage("images/avatar.png");

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": userId,
          "Hình ảnh": "images/avatar.png",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, userId);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LogIn()));
      } on FirebaseException catch (e) {
        String message = "";
        if (e.code == "weak-password") {
          message = "Mật khẩu cung cấp quá yếu";
        } else if (e.code == "email-already-in-use") {
          message = "Tài khoản đã tồn tại";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              message,
              style: TextStyle(fontSize: 20.0),
            )));
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

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
                Image.asset("images/login.png"),
                Center(
                  child: Text(
                    "Đăng Ký",
                    style: AppWidget.semiboldTextFeildStyle(),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Vui lòng nhập thông tin bên dưới để tiếp tục.",
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Tên",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                    nameController, "Tên", "Vui lòng nhập tên của bạn"),
                SizedBox(height: 40.0),
                Text(
                  "Email",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                    emailController, "Email", "Vui lòng nhập email của bạn",
                    emailValidation: true),
                SizedBox(height: 20.0),
                Text(
                  "Mật khẩu",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                SizedBox(height: 20.0),
                _buildTextField(passwordController, "Mật khẩu",
                    "Vui lòng nhập mật khẩu của bạn",
                    obscureText: true, passwordValidation: true),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                      });
                      register();
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
                          "ĐĂNG KÝ",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn đã có tài khoản? ",
                      style: AppWidget.lightTextFeildStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Text(
                        "Đăng Nhập",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            return "Mật khẩu phải có hơn 6 ký tự";
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
