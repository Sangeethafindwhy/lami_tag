import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/common/lami_text.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LamiColors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  LamiIcons.horseIcon,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: LamiColors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: LamiColors.black,
                          ),
                        ),
                      ),
                      const LamiText(
                        text: LamiString.lamiTagFAQ,
                        fontSize: 30,
                        color: LamiColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            text:
                                'Unable to connect Lami-TAG to your phone?\n\n',
                            style: questStyle(),
                            children: [
                              TextSpan(
                                text:
                                    '• Make sure Bluetooth is enabled on your phone\n'
                                    '• Press and hold the centre button until the light flashes purple\n'
                                    '• Device starting with LAMI will be your listed devices, select this\n'
                                    '• The light on the sensor will turn blue when connected\n\n',
                                style: answerStyle(),
                              ),
                              TextSpan(
                                text:
                                    'I can’t detect a reading from my pony?\n\n',
                                style: questStyle(),
                              ),
                              TextSpan(
                                text:
                                    '• Ensure the sensor is connected via Bluetooth\n'
                                    '• Ensure the light detectors on the back of the sensor are clean and free from obstruction.\n\n',
                                style: answerStyle(),
                              ),
                              TextSpan(
                                text:
                                    'If you’re still struggling try the following tips:\n\n',
                                style: questStyle(),
                              ),
                              TextSpan(
                                text: '• Make sure the leg is clean and dry.\n'
                                    '• If your pony has a a winter coat, a lot of hair or feather it may need to be shaved, clipped or scissored off just down the groove. This may only need to be minimal to enable sensor to connect.\n'
                                    '• If the equine has sparse hair, part with fingers before applying the wrap.\n\n',
                                style: answerStyle(),
                              ),
                              TextSpan(
                                text:
                                'I’m not sure how to position the Lami-TAG?\n\n',
                                style: questStyle(),
                              ),
                              TextSpan(
                                text: '• Feel for the easy to find groove on the outside of lower leg which runs the vertical length of the cannon bone, from just below the knee joint to just above the fetlock joint.\n'
                                    '• The sensor in the wrap needs to sit over the groove and can easily be slightly adjusted left or right by very slight hand adjustments.\n'
                                    '• Ensure the wrap is not on too tightly but is secure and the sensor is making contact with the skin\n'
                                    '• The sensor may take a few moments to connect.\n\n',
                                style: answerStyle(),
                              ),
                              TextSpan(
                                text:
                                'Other top tips\n\n',
                                style: questStyle(),
                              ),
                              TextSpan(
                                text: '• Completely safe for your equine as us non-invasive.\n'
                                    '• To obtain an accurate reading the equine should be relaxed.\n'
                                    '• Do not over tighten the wrap.\n'
                                    '• Do not leave on the equine for lengthy periods of time. Apply, take the reading and remove.\n'
                                    '• Wrap can be used on all four legs.\n'
                                    '• Data monitoring from the healthy equine at rest is useful, as this gives the normal reading for a particular animal to compare with.\n'
                                    '• Medications may give a false reading.\n'
                                    '• Notify your veterinary surgeon if your readings are above normal for advice.\n\n',
                                style: answerStyle(),
                              ),
                            ]),
                      ),
                      20.ph,
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

TextStyle questStyle() {
  return const TextStyle(
      color: LamiColors.black, fontWeight: FontWeight.bold, fontSize: 20);
}

TextStyle answerStyle() {
  return const TextStyle(
    color: LamiColors.mediumGrey,
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );
}
