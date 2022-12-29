import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_downloader/src/features/tiktok_downloader/data/models/notification.dart';

import '../../../../config/routes_manager.dart';
import '../../../../core/helpers/dir_helper.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_enums.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/build_toast.dart';
import '../../../../core/widgets/center_indicator.dart';
import '../../../../core/widgets/custom_elevated_btn.dart';
import '../bloc/downloader_bloc/downloader_bloc.dart';
import '../widgets/download_bottom_sheet.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/text_filed.dart';
import '../..//data/models/downloader_helper.dart';

class DownloaderScreen extends StatefulWidget {
  const DownloaderScreen({Key? key}) : super(key: key);

  @override
  State<DownloaderScreen> createState() => _DownloaderScreenState();
}

class _DownloaderScreenState extends State<DownloaderScreen> {
  late final TextEditingController _videoLinkController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DownloaderHelper downloaderHelper = DownloaderHelper();

  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool? isDowloanding;
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _videoLinkController = TextEditingController();
  }

  @override
  void dispose() {
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloaderBloc, DownloaderState>(
      listener: (context, state) {
        if (state is DownloaderGetVideoFailure) {
          buildToast(msg: state.message, type: ToastType.error);
        }
        if (state is DownloaderGetVideoSuccess &&
            state.tikTokVideo.videoData == null) {
          buildToast(msg: state.tikTokVideo.msg, type: ToastType.error);
        }
        if (state is DownloaderGetVideoSuccess &&
            state.tikTokVideo.videoData != null) {
          buildDownloadBottomSheet(context, state.tikTokVideo);
        }
        if (state is DownloaderSaveVideoSuccess) {
          DirHelper.saveVideoToGallery(state.path);
          buildToast(msg: state.message, type: ToastType.success);
        }
        if (state is DownloaderSaveVideoFailure) {
          buildToast(msg: state.message, type: ToastType.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildScreenBody(context, state),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final allDownloads = context.read<DownloaderBloc>().allDownloads;
    return AppBar(
      title: const Text(AppStrings.appName),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(Routes.downloads),
          child: allDownloads.isNotEmpty
              ? Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    _buildDownloadsIcons(),
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 2, 2, 2),
                      radius: AppSize.s10,
                      child: Text(
                        allDownloads.length.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                )
              : _buildDownloadsIcons(),
        ),
      ],
    );
  }

  Image _buildDownloadsIcons() {
    return const Image(
      width: AppSize.s40,
      height: AppSize.s40,
      image: AssetImage(AppAssets.downloadsIcon),
    );
  }

  Widget _buildScreenBody(BuildContext context, DownloaderState state) =>
      Container(
        padding: const EdgeInsets.all(AppSize.s20),
        alignment: AlignmentDirectional.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //_buildBodyLogo(),
              //const SizedBox(height: AppSize.s20),
              Align(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Tiktok Url',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: AppSize.s10),
              _buildBodyInputField(),
              const SizedBox(height: AppSize.s20),
              if (state is! DownloaderGetVideoLoading)
                _buildBodyDownloadBtn(context),
              if (state is DownloaderGetVideoLoading)
                const CenterProgressIndicator(),
              const SizedBox(height: AppSize.s100),
              _youtubeurl(context),
              const SizedBox(height: AppSize.s20),
              _buildBodyDownloadBtnyt(context),
              if (isLoading) const CenterProgressIndicator(),
            ],
          ),
        ),
      );

  // Widget _buildBodyLogo() => Container(
  //       decoration: BoxDecoration(
  //         color: Color.fromARGB(255, 0, 0, 0).withOpacity(.1),
  //         borderRadius: BorderRadius.circular(AppSize.s10),
  //       ),
  //       child: const Image(
  //         width: AppSize.s150,
  //         height: AppSize.s150,
  //         image: AssetImage(AppAssets.tiktokLogo),
  //       ),
  //     );

  Form _buildBodyInputField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _videoLinkController,
        keyboardType: TextInputType.url,
        validator: (String? value) {
          if (value!.isEmpty) return AppStrings.videoLinkRequired;
          return null;
        },
        decoration: const InputDecoration(
          hintText: AppStrings.inputLinkFieldText,
        ),
      ),
    );
  }

  Widget _buildBodyDownloadBtn(BuildContext context) {
    return CustomElevatedBtn(
      label: AppStrings.download,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          context.read<DownloaderBloc>().add(
                DownloaderGetVideo(_videoLinkController.text),
              );
        }
      },
    );
  }

  Widget _youtubeurl(BuildContext context) {
    return SizedBox(
      child: SafeArea(
        child: Form(
            key: _globalKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              InputField(
                  title: "Youtube Url",
                  hint: "paste video link here",
                  fieldController: textEditingController,
                  onFieldSubmitted: (value) {
                    print(value);
                    fieldValidate();
                  },
                  validatior: (value) {
                    if (textEditingController.text.isEmpty) {
                      return "Video link is Required";
                    }
                    String y1 = "youtu.be";
                    String y2 = "youtube.com";
                    if (!textEditingController.text.contains("youtu")) {
                      return "Enter a YouTube URL !";
                    }
                  }),
            ])),
      ),
    );
  }

  Widget _buildBodyDownloadBtnyt(BuildContext context) {
    return CustomElevatedBtn(
      onPressed: fieldValidate,
      label: AppStrings.download,
    );
  }

  void fieldValidate() {
    if (_globalKey.currentState!.validate()) {
      _validate();
    }
  }

  void _validate() async {
    setState(() {
      isLoading = true;
    });
    var data = await downloaderHelper
        .getVideoInfo(Uri.parse(textEditingController.text));
    setState(() {
      isLoading = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) => MyBottomSheet(
              imageUrl: data['image'].toString(),
              title: data['title'],
              author: data["author"],
              duration: data['duration'].toString(),
              mp3Size: data['mp3'],
              mp4Size: data['mp4'],
              mp3Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Audio Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp3(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Audio Downloaded')
                        ],
                      )));
                });
              },
              isDownloading: isDowloanding,
              mp4Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Video Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp4(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Video Downloaded')
                        ],
                      )));
                });
              },
            ));
  }
}
