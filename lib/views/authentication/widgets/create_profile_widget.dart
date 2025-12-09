import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/res/constants.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/services/validation_services.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/authentication/auth_view_cubit.dart';
import 'package:lami_tag/views/blue_flow/blue_cubit.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_drop_down.dart';
import 'package:lami_tag/views/common/lami_switch.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';
import 'package:lami_tag/views/common/loading.dart';
import 'package:lami_tag/views/common/profile_image.dart';

class CreateProfileWidget extends StatelessWidget {
  final void Function() onNext;
  final TextEditingController controller;
  final AuthViewCubit bloc;

  CreateProfileWidget(
      {super.key,
      required this.onNext,
      required this.controller,
      required this.bloc});

  final validationServices = ValidationServices();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: bloc.createProfileFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: LamiText(
              text: LamiString.createProfile,
              fontSize: 35,
              color: LamiColors.black,
            ),
          ),
          const LamiText(
            text: LamiString.createProfileMessage,
            fontSize: 16,
            color: LamiColors.lightestGrey,
            softWrap: true,
          ),
          StreamBuilder(
              stream: bloc.$profileImage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String image = snapshot.data!;
                  return ProfileImage(image: image);
                } else {
                  return const ProfileImage();
                }
              }),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 20, horizontal: displayWidth(context) / 6),
            child: LamiButton(
              onPressed: () {
                bloc.selectProfileImage(context);
              },
              text: LamiString.changePhoto,
              backgroundColor: LamiColors.lighterGrey,
              textColor: LamiColors.black.withOpacity(0.5),
            ),
          ),
          LamiTextField(
              hintText: LamiString.fullName,
              controller: controller,
              onChanged: (value) {
                //
              },
              validator: (value) {
                return validationServices.validateField(value);
              }),
          20.ph,
          StreamBuilder(
            stream: bloc.$selectedItem,
            builder: (context, snapshot) {
              final selectedItem = snapshot.data;
              return LamiDropDown(
                hintText: LamiString.role,
                items: LamiConstants.roles,
                selectedItem: selectedItem,
                onChanged: (newValue) {
                  bloc.updateSelectedRole(newValue!);
                },
                validator: (value) {
                  return validationServices.validateDropDown(value);
                },
              );
            },
          ),
          20.ph,
          LamiButton(
            onPressed: () {
              if (bloc.createProfileFormKey.currentState!.validate()) {
                onNext();
              } else {
                //
              }
            },
            text: LamiString.next,
          ),
        ],
      ),
    );
  }
}

class ConnectDeviceWidget extends StatelessWidget {
  final void Function() onNext;

  const ConnectDeviceWidget({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LamiColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: LamiText(
              text: LamiString.connectYourDevice,
              fontSize: 35,
              color: LamiColors.black,
            ),
          ),
          const LamiText(
            text: LamiString.connectYourDeviceMessage,
            fontSize: 16,
            color: LamiColors.lightestGrey,
            softWrap: true,
          ),
          20.ph,
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LamiColors.black,
              border: Border.all(
                color: LamiColors.black,
                width: 2,
              ),
              gradient: const LinearGradient(colors: [
                LamiColors.lightPink,
                LamiColors.darkPink,
                LamiColors.white,
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LamiColors.black,
                border: Border.all(
                  color: LamiColors.black,
                  width: 2,
                ),
              ),
              child: Image.asset(
                LamiIcons.horseIcon,
                height: 100,
                width: 100,
              ),
            ),
          ),
          20.ph,
          LamiButton(
            onPressed: onNext,
            icon: LamiIcons.bluetooth,
            text: LamiString.pairYourDevice,
          ),
        ],
      ),
    );
  }
}

class EnlistDeviceWidget extends StatelessWidget {
  final BlueCubit bloc;
  final AppBaseState state;
  final void Function() onNext;

  const EnlistDeviceWidget({
    super.key,
    required this.state,
    required this.onNext,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: LamiText(
            text: LamiString.devicePairing,
            fontSize: 35,
            color: LamiColors.black,
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: LamiText(
            text: LamiString.devicePairingMessage,
            fontSize: 16,
            color: LamiColors.lightestGrey,
            softWrap: true,
          ),
        ),
        20.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LamiText(
              text: LamiString.yourBluetoothIs,
              fontSize: 16,
              color: LamiColors.lightestGrey,
              softWrap: true,
            ),
            StreamBuilder(
                stream: bloc.blueService.$blueToothState,
                builder: (context, snapshot) {
                  final bool blueToothAdapterStatus = snapshot.hasData &&
                      (snapshot.data == BluetoothAdapterState.on ||
                          snapshot.data == BluetoothAdapterState.turningOn);
                  return LamiSwitch(
                    value: blueToothAdapterStatus,
                    onChanged: (bool newValue) {
                      bloc.blueService.updateBluetoothAdapterStatus(context);
                    },
                  );
                }),
          ],
        ),
        20.ph,
        Expanded(
          child: StreamBuilder(
            stream: bloc.blueService.$bluetoothScannedDevices,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<ScanResult> scannedDevices = snapshot.data!;
                scannedDevices.retainWhere((device) {
                  return device.advertisementData.advName
                      .toLowerCase()
                      .contains('lami');
                });
                return ListView.builder(
                  itemCount: scannedDevices.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LamiText(
                              text: (scannedDevices[index]
                                      .advertisementData
                                      .advName
                                      .isNotEmpty)
                                  ? scannedDevices[index]
                                      .advertisementData
                                      .advName
                                      .toString()
                                  : scannedDevices[index]
                                      .device
                                      .remoteId
                                      .toString(),
                              fontSize: 16,
                              color: LamiColors.black,
                              softWrap: true,
                            ),
                            (state.busy)
                                ? const Loading()
                                : StreamBuilder(
                                    stream: bloc.blueService.$isConnected,
                                    builder: (context, connectedShot) {
                                      bool isConnected =
                                          connectedShot.data ?? false;
                                      return LamiButton(
                                        onPressed: () async {
                                          if (!isConnected) {
                                            bloc.connectWithDevice(
                                                scannedDevices[index].device);
                                          } else {}
                                          log('Device already connected!');
                                        },
                                        text: (isConnected)
                                            ? LamiString.connected
                                            : LamiString.connect,
                                        width: displayWidth(context) / 4,
                                        padding: EdgeInsets.zero,
                                        backgroundColor: LamiColors.lighterGrey,
                                        textColor: (isConnected)
                                            ? LamiColors.mediumGrey
                                            : LamiColors.black,
                                        fontSize: 12,
                                        borderColor: LamiColors.transparent,
                                      );
                                    },
                                  ),
                          ],
                        ),
                        const Divider(
                          color: LamiColors.lighterGrey,
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else {
                return const Center();
              }
            },
          ),
        ),
        LamiButton(
          onPressed: onNext,
          text: LamiString.next,
        ),
      ],
    );
  }
}
