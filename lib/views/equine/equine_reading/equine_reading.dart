import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/model/user.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_switch.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/profile_image.dart';
import 'package:lami_tag/views/equine/equine_reading/equine_reading_cubit.dart';
import 'package:lami_tag/views/profile/faq/faq.dart';
import 'package:lami_tag/views/profile/profile_screen.dart';
import 'package:speedometer_chart/speedometer_chart.dart';

class EquineReading extends StatelessWidget {
  final Equine equine;

  const EquineReading({super.key, required this.equine});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EquineReadingCubit(context: context, equine: equine),
      child: BlocBuilder<EquineReadingCubit, AppBaseState>(
        builder: (context, state) {
          final bloc = (context).read<EquineReadingCubit>();
          return PopScope(
            onPopInvoked: (value){
              bloc.blueService.updateBluetoothAdapterStatus(context);
              bloc.blueService.disConnectWithDevice();
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: LamiColors.white,
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                            stream: bloc.storageService.$userProfile,
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                final UserProfile userProfile = snapshot.data!;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: displayWidth(context) * 0.65,
                                      child: LamiText(
                                        text: userProfile.name,
                                        fontSize: 30,
                                        color: LamiColors.red,
                                        softWrap: true,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const ProfileScreen()));
                                        },
                                        child: ProfileImage(
                                          size: displayWidth(context) * 0.80,
                                          image: userProfile.imageURL,
                                        )),
                                  ],
                                );
                              }else{
                                return const Center();
                              }
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const LamiText(
                              text: '${LamiString.lamiTag} ${LamiString.connected}',
                              fontSize: 16,
                              color: LamiColors.lightestGrey,
                              softWrap: true,
                            ),
                            StreamBuilder(
                                stream: bloc.blueService.$blueToothState,
                                builder: (context, snapshot) {
                                  final bool blueToothAdapterStatus = snapshot
                                          .hasData &&
                                      (snapshot.data == BluetoothAdapterState.on ||
                                          snapshot.data ==
                                              BluetoothAdapterState.turningOn);
                                  return LamiSwitch(
                                    value: blueToothAdapterStatus,
                                    onChanged: (bool newValue) {
                                      bloc.blueService
                                          .updateBluetoothAdapterStatus(context);
                                    },
                                  );
                                }),
                          ],
                        ),
                        20.ph,
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: LamiColors.lighterGrey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: LamiColors.black,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: LamiColors.black,
                                    border: Border.all(
                                      color: LamiColors.black,
                                      width: 2,
                                    ),
                                    gradient: const LinearGradient(
                                        colors: [
                                          LamiColors.white,
                                          LamiColors.red,
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft),
                                  ),
                                  child: EquineProfileImage(
                                    image: equine.imageURL,
                                    size: displayWidth(context) * 0.25,
                                  )),
                              SizedBox(
                                width: displayWidth(context) * 0.65,
                                child: LamiText(
                                  text: equine.equineName,
                                  color: LamiColors.black,
                                  softWrap: true,
                                  fontSize: 35,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              20.ph,
                              StreamBuilder(
                                  stream: bloc.blueService.$reading,
                                  builder: (context, snapshot){
                                    if(snapshot.hasData){
                                      final int value = snapshot.data!;
                                      return SpeedometerChart(
                                        dimension: displayWidth(context) * 0.80,
                                        minValue: 10,
                                        valueWidget: LamiText(
                                          text: value.toString(),
                                          color: bloc.decideColor(value),
                                          fontSize: 30,
                                        ),
                                        value: value.toDouble(),
                                        graphColor: const [LamiColors.green, Colors.orange, Colors.red],
                                        pointerColor: bloc.decideColor(value),
                                      );
                                    }else{
                                      return const Center();
                                    }
                                  }),
                              // StreamBuilder(
                              //     stream: bloc.blueService.$reading,
                              //     builder: (context, snapshot){
                              //       if(snapshot.hasData){
                              //         final int value = snapshot.data!;
                              //         return Container(
                              //           height: displayWidth(context)*0.50,
                              //           width: displayWidth(context)*0.50,
                              //           // padding: const EdgeInsets.all(50),
                              //           decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color: bloc.decideColor(value),
                              //             border: Border.all(
                              //               color: LamiColors.black,
                              //               width: 2,
                              //             ),
                              //           ),
                              //           child: Column(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             children: [
                              //               SvgPicture.asset(
                              //                 LamiIcons.heart,
                              //               ),
                              //               LamiText(
                              //                 text: value.toString(),
                              //                 fontSize: 60,
                              //               ),
                              //             ],
                              //           ),
                              //         );
                              //       }else{
                              //         return const Center();
                              //       }
                              //     }),
                              20.ph,
                              SizedBox(
                                width: displayWidth(context) * 0.85,
                                child: const LamiText(
                                  text: LamiString.areYouExperiencing,
                                  color: LamiColors.black,
                                  softWrap: true,
                                  fontSize: 20,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              LamiButton(
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                                },
                                icon: LamiIcons.faq,
                                text: LamiString.checkYourFAQ,
                                backgroundColor: LamiColors.purple,
                                fontSize: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
