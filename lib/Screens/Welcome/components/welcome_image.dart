import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "WELCOME TO OUN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                "assets/icons/LOGOs.svg",
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
