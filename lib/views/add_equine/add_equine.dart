import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lami_tag/app_base_states/app_base_states.dart';
import 'package:lami_tag/model/equine.dart';
import 'package:lami_tag/res/constants.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';
import 'package:lami_tag/utils/sizedbox_extension.dart';
import 'package:lami_tag/views/add_equine/add_equine_cubit.dart';
import 'package:lami_tag/views/common/lami_button.dart';
import 'package:lami_tag/views/common/lami_drop_down.dart';
import 'package:lami_tag/views/common/lami_text.dart';
import 'package:lami_tag/views/common/lami_text_field.dart';
import 'package:lami_tag/views/common/loading.dart';
import 'package:lami_tag/views/common/profile_image.dart';

class AddEquine extends StatelessWidget {
  final Equine? equine;

  const AddEquine({super.key, this.equine});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => AddEquineCubit(context: context, equine: equine),
        child: BlocBuilder<AddEquineCubit, AppBaseState>(
          builder: (context, state) {
            final bloc = context.read<AddEquineCubit>();
            return Scaffold(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: LamiColors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: bloc.addEquineKey,
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
                              LamiText(
                                text: (equine != null)
                                    ? LamiString.editEquineProfile
                                    : LamiString.addEquine,
                                fontSize: 35,
                                color: LamiColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              const LamiText(
                                text: LamiString.enterEquineInformation,
                                fontSize: 16,
                                color: LamiColors.lightestGrey,
                                fontWeight: FontWeight.bold,
                                softWrap: true,
                              ),
                              20.ph,
                              GestureDetector(
                                onTap: () {
                                  bloc.selectProfileImage(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: LamiColors.lighterGrey,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: LamiColors.lightestGrey,
                                      )),
                                  child: StreamBuilder(
                                    stream: bloc.$equineImage,
                                    builder: (context, snapshot) {
                                      final image = snapshot.data ?? '';
                                      if (image.isNotEmpty) {
                                        return Stack(
                                          children: [
                                            EquineProfileImage(
                                              image: image,
                                              size:
                                                  displayWidth(context) * 0.35,
                                            ),
                                            const Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: CircleAvatar(
                                                backgroundColor: LamiColors.red,
                                                radius: 15,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: LamiColors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            SvgPicture.asset(
                                              LamiIcons.camera,
                                            ),
                                            const LamiText(
                                              text: LamiString.addPhoto,
                                              color: LamiColors.black,
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              20.ph,
                              LamiTextField(
                                  hintText: LamiString.equineName,
                                  controller: bloc.equineName,
                                  validator: (value) {
                                    return bloc.validationServices
                                        .validateField(value);
                                  }),
                              20.ph,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: displayWidth(context) * 0.26,
                                    child: StreamBuilder(
                                      stream: bloc.$selectedEquineType,
                                      builder: (context, snapshot) {
                                        final selectedType = snapshot.data;
                                        return LamiDropDown(
                                          hintText: LamiString.selectType,
                                          validator: (value) {
                                            return bloc.validationServices
                                                .validateDropDown(value);
                                          },
                                          selectedItem: selectedType,
                                          items: LamiConstants.equineTypes,
                                          onChanged: (newValue) {
                                            bloc.updateEquineType(newValue);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: displayWidth(context) * 0.26,
                                    child: LamiTextField(
                                        hintText: LamiString.height,
                                        controller: bloc.height,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          return bloc.validationServices
                                              .validateNumber(value);
                                        }),
                                  ),
                                  SizedBox(
                                    width: displayWidth(context) * 0.26,
                                    child: StreamBuilder(
                                      stream: bloc.$selectedHeightUnit,
                                      builder: (context, snapshot) {
                                        final selectedUnit = snapshot.data;
                                        return LamiDropDown(
                                          hintText: LamiString.unit,
                                          validator: (value) {
                                            return bloc.validationServices
                                                .validateDropDown(value);
                                          },
                                          selectedItem: selectedUnit,
                                          items: LamiConstants.units,
                                          onChanged: (newValue) {
                                            bloc.updateHeightUnit(newValue);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              20.ph,
                              StreamBuilder(
                                stream: bloc.storageService.$availableBreeds,
                                builder: (context, itemSnapshot) {
                                  if (itemSnapshot.hasData) {
                                    List<String> breeds = itemSnapshot.data!;
                                    return StreamBuilder(
                                      stream: bloc.$selectedEquineBreed,
                                      builder: (context, snapshot) {
                                        final selectedType = snapshot.data;
                                        return LamiDropDown(
                                          hintText: LamiString.equineBreed,
                                          validator: (value) {
                                            return bloc.validationServices
                                                .validateDropDown(value);
                                          },
                                          selectedItem: selectedType,
                                          items: breeds,
                                          onChanged: (newValue) {
                                            bloc.updateEquineBreed(newValue);
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center();
                                  }
                                },
                              ),
                              20.ph,
                              (state.busy)
                                  ? const Loading()
                                  : LamiButton(
                                      onPressed: () {
                                        if (bloc.addEquineKey.currentState!
                                            .validate()) {
                                          bloc.saveEquineData();
                                        }
                                      },
                                      text: (equine != null)
                                          ? LamiString.updateChanges
                                          : LamiString.addEquine,
                                    ),
                            ],
                          ),
                        ),
                      ),
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
