import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RemoteRegister extends StatefulWidget {
  const RemoteRegister({super.key});

  @override
  State<RemoteRegister> createState() => _RemoteRegisterState();
}

class _RemoteRegisterState extends State<RemoteRegister> {

  void connect(BuildContext context){

  }

  TextEditingController url=TextEditingController();
  FocusNode urlFocus=FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(urlFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    urlFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "密码",
                    style: GoogleFonts.notoSansSc(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.key),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: TextField(
                          controller: url,
                          focusNode: urlFocus,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          autocorrect: false,
                          // enableSuggestions: false,
                          onEditingComplete: (){
                            connect(context);
                          },
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}