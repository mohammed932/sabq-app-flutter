import 'dart:io';
import 'package:Sabq/blocs/competition_details_bloc.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadClipDialogue {
  static openDailogue({BuildContext context, Competition competition}) {
    bool isSelectFile = false;
    bool isUpload = false;
    File selectedFile;
    num selectedType;
    var uint8list;
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          CompetitionDetailsBloc competitionDetailsBloc =
              Provider.of<CompetitionDetailsBloc>(context);
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: General.buildTxt(
                    txt: TranslationBase.of(context)
                        .getStringLocaledByKey('UPLOAD_CLIP'),
                    fontSize: 16.0,
                    isBold: true,
                    color: Theme.of(context).primaryColor),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      General.buildTxt(
                          txt: TranslationBase.of(context)
                              .getStringLocaledByKey('ALLOWED_EXTENTIONS_ARE'),
                          fontSize: 11.0,
                          color: Theme.of(context).primaryColor),
                      General.sizeBoxVerical(6.0),
                      General.buildTxt(
                          txt: "Mp4, Mp3, Avi, MPG",
                          fontSize: 11.0,
                          color: Colors.black54),
                      General.sizeBoxVerical(10.0),
                      General.buildTxt(
                          txt: TranslationBase.of(context)
                              .getStringLocaledByKey('MIXIMUM_SIZE_25_MEGA'),
                          fontSize: 11.0,
                          color: Colors.black54),
                      General.sizeBoxVerical(30.0),
                      !isSelectFile || selectedFile == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                dialogueActionIconWidget(
                                    icon: "assets/imgs/audio.png",
                                    txt: TranslationBase.of(context)
                                        .getStringLocaledByKey('AUDIO'),
                                    onPress: () async {
                                      try {
                                        selectedFile = await FilePicker.getFile(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'm4a',
                                              'mp3',
                                              'caf',
                                              'wave',
                                              'mp4',
                                              'aac'
                                            ]);
                                        selectedType = 1;
                                        setState(() => isSelectFile = true);
                                        print(
                                            'selected audio is :$selectedFile');
                                      } catch (e) {
                                        print('audio picker error :$e');
                                      }
                                    }),
                                dialogueActionIconWidget(
                                    icon: "assets/imgs/video.png",
                                    txt: TranslationBase.of(context)
                                        .getStringLocaledByKey('VIDEO'),
                                    onPress: () async {
                                      try {
                                        selectedFile = await FilePicker.getFile(
                                          type: FileType.video,
                                        );

                                        print(
                                            "uploaded file length : ${selectedFile.lengthSync()}");
                                        print(
                                            'slected video file is :$selectedFile');
                                        uint8list =
                                            await VideoThumbnail.thumbnailData(
                                          video: selectedFile.path,
                                          imageFormat: ImageFormat.JPEG,
                                          maxHeight: 150,
                                          maxWidth:
                                              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                          quality: 100,
                                        );
                                        selectedType = 2;
                                        setState(() => isSelectFile = true);
                                      } catch (e) {
                                        print('video picker error :$e');
                                      }
                                    }),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                General.buildTxt(
                                    txt: TranslationBase.of(context)
                                        .getStringLocaledByKey('ATTACHED_CLIP'),
                                    fontSize: 11.0),
                                General.sizeBoxVerical(6.0),
                                !isUpload
                                    ? uint8list != null
                                        ? Stack(
                                            children: <Widget>[
                                              Image.memory(uint8list),
                                              Positioned(
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: 30.0,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() =>
                                                              isSelectFile =
                                                                  false);
                                                        }),
                                                  ))
                                            ],
                                          )
                                        : General.buildTxt(
                                            txt: basename(selectedFile.path))
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: LinearPercentIndicator(
                                          lineHeight: 16.0,
                                          leading: Container(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: General.buildTxt(
                                                txt:
                                                    "${competitionDetailsBloc.progressIndicator}%"),
                                          ),
                                          percent: competitionDetailsBloc
                                                  .progressIndicator /
                                              100,
                                          backgroundColor: Color(
                                              General.getColorHexFromStr(
                                                  '#B4B4B4')),
                                          progressColor: Constants.OrangeColor,
                                        ),
                                      ),
                                General.sizeBoxVerical(10.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: RoundButton(
                                      onPress: !isUpload
                                          ? () async {
                                              if (selectedFile.lengthSync() /
                                                      1000 >=
                                                  25000) {
                                                General.showDialogue(
                                                    txtWidget: General.buildTxt(
                                                        txt: TranslationBase.of(
                                                                context)
                                                            .getStringLocaledByKey(
                                                                'MIXIMUM_SIZE_25_MEGA')),
                                                    context: context);
                                              } else {
                                                setState(() => isUpload = true);
                                                await competitionDetailsBloc
                                                    .enrollInCompetition(
                                                        competitionId:
                                                            competition.id);
                                                competitionDetailsBloc
                                                    .uploadMedia(
                                                        file: selectedFile,
                                                        fileType: selectedType,
                                                        context: context);
                                              }
                                            }
                                          : null,
                                      color: Constants.OrangeColor,
                                      disableColor:
                                          Constants.OrangeColor.withOpacity(
                                              0.6),
                                      roundVal: 100.0,
                                      buttonTitle: General.buildTxt(
                                          txt: TranslationBase.of(context)
                                              .getStringLocaledByKey(
                                                  'ATTACH_CLIP'),
                                          color: Colors.white)),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  static dialogueActionIconWidget({String icon, String txt, Function onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Constants.OrangeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100.0)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                icon,
                height: 35.0,
                width: 35.0,
              ),
            ),
          ),
          General.sizeBoxVerical(10.0),
          General.buildTxt(txt: txt, color: Constants.OrangeColor)
        ],
      ),
    );
  }
}
