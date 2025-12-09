import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/model/user.dart';
import 'package:lami_tag/res/constants.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/add_equine/add_equine.dart';
import 'package:lami_tag/views/blue_flow/blue_screen.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_switch.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';
import 'package:lami_tag/views/common/profile_image.dart';
import 'package:lami_tag/views/equine/equine_detail_cubit.dart';
import 'package:lami_tag/views/equine/equine_reading/equine_reading.dart';
import 'package:lami_tag/views/equine/widgets/chart.dart';
import 'package:lami_tag/views/profile/profile_screen.dart';

class EquineDetail extends StatelessWidget {
  final Equine equine;

  const EquineDetail({super.key, required this.equine});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) =>
            EquinesDetailCubit(context: context, equine: equine),
        child: BlocBuilder<EquinesDetailCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = (context).read<EquinesDetailCubit>();
            return Scaffold(
              backgroundColor: LamiColors.white,
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: bloc.storageService.$userProfile,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final UserProfile userProfile = snapshot.data!;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            } else {
                              return const Center();
                            }
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const LamiText(
                            text:
                                '${LamiString.lamiTag} ${LamiString.connected}',
                            fontSize: 16,
                            color: LamiColors.lightestGrey,
                            softWrap: true,
                          ),
                          StreamBuilder(
                              stream: bloc.blueService.$blueToothState,
                              builder: (context, snapshot) {
                                final bool blueToothAdapterStatus = snapshot
                                        .hasData &&
                                    (snapshot.data ==
                                            BluetoothAdapterState.on ||
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
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
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading:
                                  EquineProfileImage(image: equine.imageURL),
                              title: SizedBox(
                                width: displayWidth(context) * 0.65,
                                child: LamiText(
                                  text: equine.equineName,
                                  color: LamiColors.black,
                                  softWrap: true,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: LamiText(
                                text: equine.type,
                                color: LamiColors.mediumGrey,
                                softWrap: true,
                                fontSize: 20,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SingleChildScrollView(
                                          child: Container(
                                            width: displayWidth(context),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 40),
                                            child: Form(
                                              key: bloc.shareFormKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  LamiText(
                                                    text:
                                                        '${LamiString.share} ${bloc.equine.equineName} ${LamiString.details}: ',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: LamiColors.black,
                                                  ),
                                                  10.ph,
                                                  const LamiText(
                                                    text:
                                                        LamiString.shareMessage,
                                                    fontSize: 18,
                                                    color:
                                                        LamiColors.mediumGrey,
                                                    softWrap: true,
                                                  ),
                                                  10.ph,
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: ProfileImage(
                                                      image: bloc
                                                          .storageService
                                                          .$userProfile
                                                          .value
                                                          .imageURL,
                                                    ),
                                                  ),
                                                  10.ph,
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: LamiText(
                                                      text: bloc
                                                          .equine.equineName,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: LamiColors.black,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  10.ph,
                                                  LamiTextField(
                                                      hintText:
                                                          LamiString.email,
                                                      controller:
                                                          bloc.emailController,
                                                      validator: (value) {
                                                        return bloc
                                                            .validationServices
                                                            .validateEmail(
                                                                value);
                                                      }),
                                                  10.ph,
                                                  LamiButton(
                                                      onPressed: () {
                                                        if (bloc.shareFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          Navigator.pop(
                                                              context);
                                                          bloc.emailService.sendEmail(
                                                              context,
                                                              subject:
                                                                  '${LamiString.appName} App',
                                                              body:
                                                                  '${LamiString.equineName}: ${bloc.equine.equineName}\n'
                                                                  '${LamiString.equineType}: ${bloc.equine.type}\n'
                                                                  '${LamiString.equineBreed}: ${bloc.equine.breed}\n'
                                                                  '${LamiString.height}: ${bloc.equine.height} ${bloc.equine.unit}\n'
                                                                  '===${bloc.equine.equineName} ${LamiString.records}===\n'
                                                                  '${bloc.equineRecordService.readings.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                              receiver: bloc
                                                                  .emailController
                                                                  .text);
                                                        }
                                                      },
                                                      text: LamiString
                                                          .shareResults)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.ios_share_rounded,
                                  color: LamiColors.black,
                                ),
                              ),
                              onTap: () {
                                //
                              },
                            ),
                            LamiButton(
                              onPressed: () async {
                                final Equine? updatedEquine =
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddEquine(equine: equine)));

                                if (context.mounted && updatedEquine != null) {
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EquineDetail(
                                              equine: updatedEquine)));
                                }
                              },
                              text: LamiString.editEquineProfile,
                              backgroundColor: LamiColors.transparent,
                              borderColor: LamiColors.red,
                              textColor: LamiColors.red,
                              fontSize: 20,
                            ),
                            StreamBuilder(
                              stream: bloc.equineRecordService.$spots,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<FlSpot> spots = snapshot.data!;
                                  if (spots.isEmpty) {
                                    return const Center();
                                  } else {
                                    return Column(
                                      children: [
                                        LineChartSample2(
                                          spots: spots,
                                          times: bloc
                                              .equineRecordService.$times.value,
                                        ),
                                        StreamBuilder(
                                            stream: bloc.$selectedGraphType,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final int selectedType =
                                                    snapshot.data!;
                                                return Wrap(
                                                  direction: Axis.horizontal,
                                                  children: List.generate(
                                                      LamiConstants.graphType
                                                          .length, (index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2),
                                                      child: LamiSmallButton(
                                                        onPressed: () {
                                                          bloc.updateGraphType(
                                                              index);
                                                        },
                                                        text: LamiConstants
                                                            .graphType[index],
                                                        backgroundColor: (index ==
                                                                selectedType)
                                                            ? LamiColors
                                                                .lightestGrey
                                                            : LamiColors.black,
                                                        textColor: (index ==
                                                                selectedType)
                                                            ? LamiColors.red
                                                            : LamiColors.white,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    );
                                                  }),
                                                );
                                              } else {
                                                return Wrap(
                                                  children: List.generate(
                                                      LamiConstants.graphType
                                                          .length, (index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2),
                                                      child: LamiButton(
                                                        onPressed: () {
                                                          bloc.updateGraphType(
                                                              index);
                                                        },
                                                        text: LamiConstants
                                                            .graphType[index],
                                                        backgroundColor:
                                                            LamiColors.black,
                                                        textColor:
                                                            LamiColors.white,
                                                        // padding: EdgeInsets.symmetric(horizontal: 10),
                                                        width: 80,
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }
                                            }),
                                      ],
                                    );
                                  }
                                } else {
                                  return const Center();
                                }
                              },
                            ),
                            20.ph,
                            LamiButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BlueConnectivityScreen(
                                              onNext: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EquineReading(
                                                              equine: equine,
                                                            )));
                                              },
                                            )));
                              },
                              icon: LamiIcons.heart,
                              text: LamiString.recordANewReading,
                              fontSize: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
