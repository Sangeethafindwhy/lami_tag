import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/model/user.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/add_equine/add_equine.dart';
import 'package:lami_tag/views/common/lami_switch.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/loading.dart';
import 'package:lami_tag/views/common/profile_image.dart';
import 'package:lami_tag/views/equine/equine_detail.dart';
import 'package:lami_tag/views/home/equines_home_cubit.dart';
import 'package:lami_tag/views/profile/profile_screen.dart';

class EquinesHome extends StatelessWidget {
  const EquinesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => EquinesHomeCubit(context: context),
        child: BlocBuilder<EquinesHomeCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = (context).read<EquinesHomeCubit>();
            return Scaffold(
              backgroundColor: LamiColors.black,
              body: Container(
                height: displayHeight(context),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: bloc.storageService.$userProfile,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
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
                          } else {
                            return const Center();
                          }
                        }),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: LamiColors.mediumGrey),
                      child: Column(
                        children: [
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
                                  stream: bloc.blueService.$adapterState,
                                  builder: (context, snapshot) {
                                    final bool blueToothAdapterStatus =
                                        snapshot.hasData &&
                                            (snapshot.data ==
                                                    BluetoothAdapterState.on ||
                                                snapshot.data ==
                                                    BluetoothAdapterState
                                                        .turningOn);

                                    return LamiSwitch(
                                      value: blueToothAdapterStatus,
                                      onChanged: (bool newValue) {
                                        // Manual Bluetooth toggle is no longer supported
                                        // User must enable Bluetooth from device settings
                                      },
                                    );
                                  }),
                            ],
                          ),
                          20.ph,
                          Container(
                            alignment: Alignment.center,
                            height: displayHeight(context) * 0.65,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: LamiColors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: StreamBuilder<List<Equine>>(
                              stream: bloc.$equines,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final equines = snapshot.data!;
                                  return RefreshIndicator(
                                    onRefresh: () {
                                      return bloc.getAllEquines();
                                    },
                                    child: (equines.isNotEmpty)
                                        ? ListView.builder(
                                            itemCount: equines.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                    color:
                                                        LamiColors.lighterGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: LamiColors.black
                                                            .withOpacity(0.2),
                                                        offset: const Offset(
                                                          5.0,
                                                          5.0,
                                                        ),
                                                        blurRadius: 5.0,
                                                        spreadRadius: 2.0,
                                                      ), //BoxShadow
                                                    ]),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: EquineProfileImage(
                                                      image: equines[index]
                                                          .imageURL),
                                                  title: SizedBox(
                                                    width:
                                                        displayWidth(context) *
                                                            0.65,
                                                    child: LamiText(
                                                      text: equines[index]
                                                          .equineName,
                                                      color: LamiColors.black,
                                                      softWrap: true,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  subtitle: LamiText(
                                                    text: equines[index].type,
                                                    color:
                                                        LamiColors.mediumGrey,
                                                    softWrap: true,
                                                    fontSize: 20,
                                                  ),
                                                  trailing: IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      EquineDetail(
                                                                        equine:
                                                                            equines[index],
                                                                      )));
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_forward,
                                                      color: LamiColors.black,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EquineDetail(
                                                                  equine:
                                                                      equines[
                                                                          index],
                                                                )));
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        : const LamiText(
                                            text: LamiString.noEquines,
                                            color: LamiColors.red,
                                            softWrap: true,
                                            fontSize: 20,
                                          ),
                                  );
                                } else if (state.busy) {
                                  return const Loading();
                                } else {
                                  return const LamiText(
                                    text: LamiString.noEquines,
                                    color: LamiColors.red,
                                    softWrap: true,
                                    fontSize: 20,
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: LamiColors.red,
                onPressed: () async {
                  Equine? equine = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEquine()));
                  if (equine != null) {
                    bloc.updateEquinesList([equine], update: true);
                  }
                },
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: LamiColors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
