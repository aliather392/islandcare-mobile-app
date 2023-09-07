// ignore_for_file: unused_local_variable, use_build_context_synchronously, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_element, must_be_immutable

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfileReceiverEdit extends StatefulWidget {
  String? name;
  String? dob;
  String? male;
  String? phoneNumber;
  String? service;
  String? zipCode;
  String? userInfo;
  String? userAddress;

  ProfileReceiverEdit({
    Key? key,
    this.name,
    this.male,
    this.dob,
    this.phoneNumber,
    this.service,
    this.zipCode,
    this.userInfo,
    this.userAddress,
  }) : super(key: key);
  @override
  State<ProfileReceiverEdit> createState() => _ProfileReceiverEditState();
}

class _ProfileReceiverEditState extends State<ProfileReceiverEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

// DatePicker
  var getPickedDate;
  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // DateTime.parse(picked);
      if (picked.isAfter(DateTime.now())) {
        customErrorSnackBar(
          context,
          "Please select correct date",
        );
        return;
      }
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      // print(dobController);
      // print("picked $picked");
      // picked == dobController;
      // print("controller ${dobController.text}");
      setState(() {
        getPickedDate = dobController.text;
      });

      // print("GetPickedDate $getPickedDate");
    }
  }

  // Services API
  String? selectedService;

  final String serviceurl = AppUrl.services;

  List? data = []; //edited line

  Future<String> getSWData() async {
    var res = await Dio().get(serviceurl, options: Options(headers: {"Accept": "application/json"}));
    Map<String, dynamic> resBody = res.data;
    // Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> serviceData = resBody["services"];
    // print(serviceData);
    if (widget.service != null) {
      var getServiceByProfile = serviceData
          .where(
            (element) => element['name'] == widget.service,
          )
          .first;
      // print(getServiceByProfile);

      setState(() {
        // data = serviceData;
        selectedService = getServiceByProfile['id'].toString();
      });
    }
    setState(() {
      data = serviceData;
      // selectedService = getServiceByProfile['id'].toString();
    });

    // print(resBody);

    return "Sucess";
  }

  // Image Picking
  ProgressDialog? pr;
  void showProgress(context) async {
    pr ??= ProgressDialog(context);
    await pr!.show();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
    }
  }

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;
  var myimg;
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      myimg = image!.path.split('/').last;
      // print("Imagess $image");
      // print("lasatacccestt ${image!.absolute}");
      // print("slited name ${image!.path.split('/').last}");
      // print("myIMG $myimg");

      setState(() {});
    } else {
      // print("No image selected");
    }
  }

  var userinfo = "fromapp";
  // Future<String?> uploadImage2(filename, url) async {
  //   var token = "85|4OmSeaaLUrp2ns2SYtNx733AnzSpTSvqJghXtf2Q";
  //   var request = http.MultipartRequest('POST',
  //       Uri.parse("${CareReceiverURl.serviceReceiverProfile}/3"));
  //   request.fields['_method'] = "PUT";
  //   request.fields['user_info'] = "from app";
  //   request.fields['phone'] = "12121212";
  //   request.fields['address'] = "from app";
  //   request.fields['gender'] = "1";
  //   request.fields['phone'] = "12121212";
  //   request.fields['dob'] = "2023-01-04T00:12:36.000000Z";
  //   request.fields['zip'] = "1234";
  //   request.files.add(await http.MultipartFile.fromPath('avatar', filename));
  //   request.headers.addAll(
  //     {"Authorization": "Bearer ${token}", "Accept": "application/json"},
  //   );
  //   var res = await request.send();
  //   return res.reasonPhrase;
  // }

  // String state = "";
  Future<void> uploadImage(filename) async {
    var token = await getUserToken();
    var usersId = await getUserId();

    // var token = "85|4OmSeaaLUrp2ns2SYtNx733AnzSpTSvqJghXtf2Q";
    // showProgress(context);

    // var stream = http.ByteStream(image!.openRead());
    // stream.cast();

    // // var length = await image!.length();
    // var putUrl = "${CareReceiverURl.serviceReceiverProfile}/$usersId";
    // var uri = Uri.parse(putUrl);

    // var request = http.MultipartRequest("POST", uri);
    // request.fields['_method'] = "PUT";
    // request.fields['user_info'] = userInfoController.text.toString();
    // request.fields['phone'] = phoneController.text.toString();
    // request.fields['address'] = addressController.text.toString();
    // request.fields['gender'] = _isSelectedGender;
    // request.fields['phone'] = phoneController.text.toString();
    // request.fields['dob'] = dobController.text.toString();
    // request.fields['zip'] = zipController.text.toString();

    // var multiport = http.MultipartFile(
    //   'avatar',
    //   stream,
    //   length,
    // );
    // request.files.add(await http.MultipartFile.fromPath('avatar', filename));

    // // request.files.add(multiport);
    // request.headers.addAll(
    //   {"Authorization": "Bearer $token", "Accept": "application/json"},
    // );
    // var response = await request.send();
    // final respStr = await response.stream.bytesToString();
    // if (response.statusCode == 200) {
    // print("API response  $response");
    // print("Succes response $respStr");
    // print(response.statusCode);
    // print("File Uploaded"); context,
    //    customSuccesSnackBar(context, "Profile Updated Successfully");
    //   // hideProgress();
    // } else {
    //    customErrorSnackBar(context, "Profile Is Not Updated Successfully");

    // print("Failed");
    // print(respStr);
    // print(response.statusCode);
    // hideProgress();
    // }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // print(userToken);
    return userToken.toString();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString(
      'userId',
    );
    // print(userId);
    return userId.toString();
  }

  @override
  void initState() {
    getUserToken();
    getUserId();
    super.initState();
    getSWData();
    if (widget.dob != null) {
      dobController.text = widget.dob!;
    }
    if (widget.zipCode != null) {
      zipController.text = widget.zipCode!;
    }
    if (widget.userInfo != null) {
      userInfoController.text = widget.userInfo!;
    }
    if (widget.userAddress != null) {
      addressController.text = widget.userAddress!;
    }
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
    }
    // if (widget.service != null) {
    //   selectedService = widget.service!;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile Edit",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const NotificationScreen(),
          //         ),
          //       );
          //     },
          //     child: const Padding(
          //       padding: EdgeInsets.all(12.0),
          //       // child: Badge(
          //       //   elevation: 0,
          //       //   badgeContent: const Text(""),
          //       //   badgeColor: CustomColors.red,
          //       //   position: BadgePosition.topStart(start: 18),
          //       //   child: const Icon(
          //       //     Icons.notifications_none,
          //       //     size: 30,
          //       //   ),
          //       // ),
          //     ),
          //   )
          // ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Upload Image
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: image == null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100.45,
                                  width: 100.45,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(15, 0, 0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 4,
                                        offset: Offset(2, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: const Center(child: Text("Upload")),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(image!.path).absolute,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      // Text(state),

                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 17, vertical: 10),
                      //   margin: const EdgeInsets.only(bottom: 15),
                      //   decoration: BoxDecoration(
                      //     color: CustomColors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         "Name",
                      //         style: TextStyle(
                      //           color: CustomColors.primaryColor,
                      //           fontSize: 12,
                      //           fontFamily: "Rubik",
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       TextFormField(
                      //         controller: nameController,
                      //         style: const TextStyle(
                      //           fontSize: 16,
                      //           fontFamily: "Rubik",
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //         textAlignVertical: TextAlignVertical.bottom,
                      //         maxLines: 1,
                      //         decoration: InputDecoration(
                      //           hintText: "Name...",
                      //           fillColor: CustomColors.white,
                      //           focusColor: CustomColors.white,
                      //           hoverColor: CustomColors.white,
                      //           filled: true,
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(0),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: CustomColors.white, width: 0.0),
                      //             borderRadius: BorderRadius.circular(0.0),
                      //           ),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: CustomColors.white, width: 0.0),
                      //             borderRadius: BorderRadius.circular(0.0),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "1";
                                        // print(_isSelectedGender);
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      // width: 149.49,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "1" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "1";
                                            // print(_isSelectedGender);
                                          });
                                        },
                                        child: Text(
                                          "Male",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "2";
                                        // print(_isSelectedGender);
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      // width: 149.49,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "2" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "2";
                                            // print(_isSelectedGender);
                                          });
                                        },
                                        child: Text(
                                          "Female",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date Of Birth",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomTextFieldWidget(
                              borderColor: CustomColors.white,
                              obsecure: false,
                              keyboardType: TextInputType.number,
                              controller: dobController,
                              onChanged: (value) {
                                setState(() {
                                  getPickedDate = value;
                                });
                              },
                              hintText: "DOB",
                              onTap: () async {
                                _selectDate(context);
                                // DateTime? pickedDate = await showDatePicker(
                                //     context: context,
                                //     initialDate: DateTime.now(),
                                //     firstDate: DateTime(1950),
                                //     lastDate: DateTime(2050));

                                // if (pickedDate != null) {
                                //   dobController.text =
                                //       DateFormat('dd MMMM yyyy').format(pickedDate);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Services ",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text("Services You Provide"),
                                      isExpanded: true,
                                      items: data!.map((item) {
                                        return DropdownMenuItem(
                                          value: item['id'].toString(),
                                          child: Text(item['name']),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          selectedService = newVal;
                                          // print(selectedService);
                                        });
                                      },
                                      value: selectedService,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Zip Code",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: zipController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Zip Code",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Info",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: userInfoController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "User Info",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Address",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "User Address",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            if (image == null) {
                              customErrorSnackBar(context, "Please Select Image");
                            } else if (_isSelectedGender == null) {
                              customErrorSnackBar(context, "Please Select Gender");
                            } else if (dobController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Select Date Of Birth");
                            } else if (selectedService == null) {
                              customErrorSnackBar(context, "Please Select Services");
                            } else if (zipController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Zip Code");
                            } else if (phoneController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Phone Number");
                            } else if (addressController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Address");
                            } else {
                              uploadImage(image!.path);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              color: CustomColors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(13, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Rubik",
                                ),
                              ),
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
    );
  }
}

class ProfileReceiverPendingEdit extends StatefulWidget {
  const ProfileReceiverPendingEdit({
    Key? key,
  }) : super(key: key);
  @override
  State<ProfileReceiverPendingEdit> createState() => _ProfileReceiverPendingEditState();
}

class _ProfileReceiverPendingEditState extends State<ProfileReceiverPendingEdit> {
  var _isSelectedGender = "1";
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController userInfoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

// DatePicker
  var getPickedDate;
  DateTime? selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        // startDate = DateFormat('dd-MM-yyyy').format(args.value.startDate);
        // if (args.value.endDate != null) {
        //   endDate = DateFormat('dd-MM-yyyy').format(args.value.endDate);
        // } else {
        //   endDate = DateFormat('dd-MM-yyyy').format(args.value.startDate);
        // }
      }
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: CustomColors.primaryColor,
              accentColor: const Color(0xff55CE86),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      // print(dobController);
      // print("picked $picked");
      // picked == dobController;
      // print("controller ${dobController.text}");
      setState(() {
        getPickedDate = dobController.text;
      });

      // print("GetPickedDate $getPickedDate");
    }
  }

  // Services API
  String? selectedService;

  final String serviceurl = AppUrl.services;

  List? data = []; //edited line

  Future<String> getSWData() async {
    var res = await Dio().get(
      serviceurl,
      options: Options(headers: {"Accept": "application/json"}),
    );
    Map<String, dynamic> resBody = res.data;
    // Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> serviceData = resBody["services"];
    // print(data![0]["name"]);

    setState(() {
      data = serviceData;
    });

    // print(resBody);

    return "Sucess";
  }

  // Image Picking
  ProgressDialog? pr;
  void showProgress(context) async {
    pr ??= ProgressDialog(context);
    await pr!.show();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
    }
  }

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;
  var myimg;
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      myimg = image!.path.split('/').last;
      // print("Imagess $image");
      // print("lasatacccestt ${image!.absolute}");
      // print("slited name ${image!.path.split('/').last}");
      // print("myIMG $myimg");

      setState(() {});
    } else {
      // print("No image selected");
    }
  }

  var userinfo = "fromapp";
  // Future<String?> uploadImage2(filename, url) async {
  //   var token = "85|4OmSeaaLUrp2ns2SYtNx733AnzSpTSvqJghXtf2Q";
  //   var request = http.MultipartRequest('POST',
  //       Uri.parse("http://192.168.0.244:9999/api/service-receiver-profile/3"));
  //   request.fields['_method'] = "PUT";
  //   request.fields['user_info'] = "from app";
  //   request.fields['phone'] = "12121212";
  //   request.fields['address'] = "from app";
  //   request.fields['gender'] = "1";
  //   request.fields['phone'] = "12121212";
  //   request.fields['dob'] = "2023-01-04T00:12:36.000000Z";
  //   request.fields['zip'] = "1234";
  //   request.files.add(await http.MultipartFile.fromPath('avatar', filename));
  //   request.headers.addAll(
  //     {"Authorization": "Bearer ${token}", "Accept": "application/json"},
  //   );
  //   var res = await request.send();
  //   return res.reasonPhrase;
  // }

  // String state = "";
  Future<void> uploadImage(filename) async {
    var token = await getUserToken();
    var usersId = await getUserId();

    // var token = "85|4OmSeaaLUrp2ns2SYtNx733AnzSpTSvqJghXtf2Q";
    // showProgress(context);

    // var stream = http.ByteStream(image!.openRead());
    // stream.cast();

    // // var length = await image!.length();
    // var putUrl = "${CareReceiverURl.serviceReceiverProfile}/$usersId";
    // var uri = Uri.parse(putUrl);

    // var request = http.MultipartRequest("POST", uri);
    // request.fields['_method'] = "PUT";
    // request.fields['user_info'] = userInfoController.text.toString();
    // request.fields['phone'] = phoneController.text.toString();
    // request.fields['address'] = addressController.text.toString();
    // request.fields['gender'] = _isSelectedGender;
    // request.fields['phone'] = phoneController.text.toString();
    // request.fields['dob'] = dobController.text.toString();
    // request.fields['zip'] = zipController.text.toString();

    // var multiport = http.MultipartFile(
    //   'avatar',
    //   stream,
    //   length,
    // );
    // request.files.add(await http.MultipartFile.fromPath('avatar', filename));

    // // request.files.add(multiport);
    // request.headers.addAll(
    //   {"Authorization": "Bearer $token", "Accept": "application/json"},
    // );
    // var response = await request.send();
    // final respStr = await response.stream.bytesToString();
    // if (response.statusCode == 200) {
    // print("API response  $response");
    // print("Succes response $respStr");
    // print(response.statusCode);
    // print("File Uploaded");
    //    customSuccesSnackBar(context, "Profile Updated Successfully");
    //   // hideProgress();
    // } else {
    //    customErrorSnackBar(context, "Profile Is Not Updated Successfully");

    // print("Failed");
    // print(respStr);
    // print(response.statusCode);
    // hideProgress();
    // }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userTokenProfile',
    );
    // print(userToken);
    return userToken.toString();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString(
      'userId',
    );
    // print(userId);
    return userId.toString();
  }

  @override
  void initState() {
    getUserToken();
    getUserId();
    super.initState();
    getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile Edit",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: const [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const NotificationScreen(),
            //       ),
            //     );
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.all(12.0),
            //     // child: Badge(
            //     //   elevation: 0,
            //     //   badgeContent: const Text(""),
            //     //   badgeColor: CustomColors.red,
            //     //   position: BadgePosition.topStart(start: 18),
            //     //   child: const Icon(
            //     //     Icons.notifications_none,
            //     //     size: 30,
            //     //   ),
            //     // ),
            //   ),
            // )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Upload Image
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: image == null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100.45,
                                  width: 100.45,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(15, 0, 0, 0),
                                        blurRadius: 4,
                                        spreadRadius: 4,
                                        offset: Offset(2, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: const Center(child: Text("Upload")),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    File(image!.path).absolute,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "GenderGenderGenderGenderGenderGender",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "1";
                                        // print(_isSelectedGender);
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      // width: 149.49,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "1" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "1";
                                            // print(_isSelectedGender);
                                          });
                                        },
                                        child: Text(
                                          "Male",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "1" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelectedGender = "2";
                                        // print(_isSelectedGender);
                                      });
                                    },
                                    child: Container(
                                      height: 50.45,
                                      // width: 149.49,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _isSelectedGender == "2" ? CustomColors.primaryColor : CustomColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(15, 0, 0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            _isSelectedGender = "2";
                                            // print(_isSelectedGender);
                                          });
                                        },
                                        child: Text(
                                          "Female",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSelectedGender == "2" ? CustomColors.white : CustomColors.primaryText,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(color: CustomColors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date Of Birth",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomTextFieldWidget(
                              borderColor: CustomColors.white,
                              obsecure: false,
                              keyboardType: TextInputType.number,
                              controller: dobController,
                              onChanged: (value) {
                                setState(() {
                                  getPickedDate = value;
                                });
                              },
                              hintText: "DOB",
                              onTap: () async {
                                // _selectDate(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 300,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: SfDateRangePicker(
                                            headerHeight: 50,
                                            initialDisplayDate: DateTime.now(),
                                            initialSelectedDate: DateTime.now(),
                                            enablePastDates: false,
                                            backgroundColor: Colors.white,
                                            selectionMode: DateRangePickerSelectionMode.range,
                                            showActionButtons: true,
                                            confirmText: "CONFIRM",
                                            initialSelectedRange: PickerDateRange(
                                              DateTime.now(),
                                              DateTime.now().add(
                                                const Duration(
                                                  days: 3,
                                                ),
                                              ),
                                            ),
                                            // selectionColor: AppColors.appPrimarySkyColor,
                                            // rangeSelectionColor: AppColors.appPrimarySkyColor,
                                            onSubmit: (args) {
                                              if (args != null) {
                                                var value = args as PickerDateRange;

                                                //  setState(() {
                                                //   startDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.parse(
                                                //       value.startDate.toString(),
                                                //     ),
                                                //   );
                                                //   if (value.endDate != null) {
                                                //     endDate = DateFormat('dd-MM-yyyy').format(
                                                //       DateTime.parse(
                                                //         value.endDate.toString(),
                                                //       ),
                                                //     );
                                                //   } else {
                                                //     endDate = DateFormat('dd-MM-yyyy').format(
                                                //       DateTime.parse(
                                                //         value.startDate.toString(),
                                                //       ),
                                                //     );
                                                //   }
                                                // });
                                                // NavigationService().pop();
                                              } else {
                                                // setState(() {
                                                //   startDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.now(),
                                                //   );
                                                //   endDate = DateFormat('dd-MM-yyyy').format(
                                                //     DateTime.now(),
                                                //   );
                                                // });
                                                // NavigationService().pop();
                                              }
                                            },
                                            onCancel: () {
                                              setState(() {
                                                // startDate = DateFormat('dd-MM-yyyy').format(
                                                //   DateTime.now(),
                                                // );
                                                // endDate = DateFormat('dd-MM-yyyy').format(
                                                //   DateTime.now(),
                                                // );
                                              });
                                              // NavigationService().pop();
                                            },
                                            onSelectionChanged: (dateRangePickerSelectionChangedArgs) => _onSelectionChanged(dateRangePickerSelectionChangedArgs),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Services ",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text("Services You Provide"),
                                      isExpanded: true,
                                      items: data!.map((item) {
                                        return DropdownMenuItem(
                                          value: item['id'].toString(),
                                          child: Text(item['name']),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          selectedService = newVal;
                                          // print(selectedService);
                                        });
                                      },
                                      value: selectedService,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Zip Code",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: zipController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Zip Code",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Info",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: userInfoController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "User Info",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "User Address",
                              style: TextStyle(
                                color: CustomColors.primaryColor,
                                fontSize: 12,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: addressController,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Rubik",
                                fontWeight: FontWeight.w400,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "User Address",
                                fillColor: CustomColors.white,
                                focusColor: CustomColors.white,
                                hoverColor: CustomColors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: CustomColors.white, width: 0.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            if (image == null) {
                              customErrorSnackBar(context, "Please Select Image");
                            } else if (_isSelectedGender == null) {
                              customErrorSnackBar(context, "Please Select Gender");
                            } else if (dobController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Select Date Of Birth");
                            } else if (selectedService == null) {
                              customErrorSnackBar(context, "Please Select Services");
                            } else if (zipController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Zip Code");
                            } else if (phoneController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter Phone Number");
                            } else if (addressController.text.isEmpty) {
                              customErrorSnackBar(context, "Please Enter User Address");
                            } else {
                              uploadImage(image!.path);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  const Color(0xff90EAB4).withOpacity(0.1),
                                  const Color(0xff6BD294).withOpacity(0.8),
                                ],
                              ),
                              color: CustomColors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(13, 0, 0, 0),
                                  blurRadius: 4.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Rubik",
                                ),
                              ),
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
    );
  }
}
