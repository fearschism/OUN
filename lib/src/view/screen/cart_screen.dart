import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/src/view/screen/NewTask.dart';
import 'package:flutter_auth/src/view/screen/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../common/kimber_theme.dart';
import '../../../common/kimber_util.dart';
import '../../../common/kimber_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceRequestPageWidget extends StatefulWidget {
  const ServiceRequestPageWidget({Key? key}) : super(key: key);

  @override
  _ServiceRequestPageWidgetState createState() =>
      _ServiceRequestPageWidgetState();
}

class _ServiceRequestPageWidgetState extends State<ServiceRequestPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void test() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        automaticallyImplyLeading: false,
        actions: [],
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(5.0, 5.0),
                blurRadius: 2.0,
                color: ButtonsColors,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddTask();
              },
            ),
          );
        },
        backgroundColor: ButtonsColors,
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        label: const Text("Add Task", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: kPrimaryLightColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [const Spacer(), const Divider()],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Color(0x4D757575),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: KimberTheme.primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  'data:image/png;base64,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',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Waiting in line (jarir book store)',
                                            style:
                                                KimberTheme.bodyText2.override(
                                              fontFamily: 'NatoSansKhmer',
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 2, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Riyadh',
                                          style: KimberTheme.bodyText1.override(
                                            fontFamily: 'NatoSansKhmer',
                                            color: Color(0x80303030),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
