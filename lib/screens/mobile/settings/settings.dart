import 'package:athlete_hub/blocs/exports.dart';

import 'package:athlete_hub/helpers/imports.dart';

class SettingsMobile extends StatefulWidget {
  const SettingsMobile({super.key});

  @override
  State<SettingsMobile> createState() => _SettingsMobileState();
}

class _SettingsMobileState extends State<SettingsMobile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _picture;
  String? _version;

  final Uri url = Uri.parse('mailto:psotakos@gmail.com');

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await showVersion();
    setState(() {
      _version = version;
    });
  }

  Future<void> _launchUrl() async {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<String> showVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  Future<void> _getFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile == null) return;
    File imageFile = File(pickedFile.path);
    Uint8List imageByte = await imageFile.readAsBytes();

    setState(() {
      _imageFile = imageFile;
      _picture = base64.encode(imageByte);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(Images.logo2)),
              ),
            ),
            // const Spacer(),

            // if (_imageFile != null) Image.file(_imageFile!, height: 200),
            const SizedBox(height: 20),

            Card(
              elevation: 2,

              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 10,
                  children: [
                    // IotButton(
                    //   text: 'Pick Image',
                    //   icon: Icon(Icons.image, size: 24),
                    //   borderWidth: 0,
                    //   elevation: 3,
                    //   borderColor: Colors.transparent,
                    //   textStyle: TextStyle(
                    //     fontSize: 18,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    //   width: 300,
                    //   height: 50,
                    //   onPressed: _getFromGallery,
                    // ),

                    // Divider(
                    //   thickness: 2,
                    //   color: Theme.of(context).dividerTheme.color,
                    // ),
                    IotButton(
                      text: 'My profile',
                      icon: FaIcon(FontAwesomeIcons.circleUser, size: 22),
                      borderWidth: 0,
                      elevation: 3,
                      textStyle: TextStyle(
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      width: 300,
                      height: 50,
                      onPressed: () => context.push(Routes.profile),
                    ),
                    if (context.isAdmin) ...[
                      Divider(
                        thickness: 2,
                        color: Theme.of(context).dividerTheme.color,
                      ),
                      IotButton(
                        text: 'Athletes profile',
                        icon: const Icon(Icons.manage_accounts_outlined, size: 24),
                        borderWidth: 0,
                        elevation: 3,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                        width: 300,
                        height: 50,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileCustomerSearchPage(),
                            ),
                          );
                        },
                      ),
                    ],
                    Divider(
                      thickness: 2,
                      color: Theme.of(context).dividerTheme.color,
                    ),
                    IotButton(
                      text: 'Contact us',
                      icon: FaIcon(FontAwesomeIcons.at, size: 22),
                      borderWidth: 0,
                      elevation: 3,
                      textStyle: TextStyle(
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      width: 300,
                      height: 50,
                      onPressed: _launchUrl,
                    ),
                    Divider(
                      thickness: 2,
                      color: Theme.of(context).dividerTheme.color,
                    ),
                    IotButton(
                      text: 'My health',
                      icon: FaIcon(FontAwesomeIcons.heartPulse, size: 22),
                      borderWidth: 0,
                      elevation: 3,
                      textStyle: TextStyle(
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      width: 300,
                      height: 50,
                      onPressed: () => context.push(Routes.health),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            IotButton(
              text: 'Logout',
              borderWidth: 0,
              elevation: 3,
              icon: Icon(Icons.logout_outlined, size: 24),
              backgroundColor: Colors.redAccent,
              textStyle: TextStyle(
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
              width: 300,
              height: 50,
              onPressed: () {
                context.read<ErgometricsCubit>().clearErgometrics();
                context.read<AuthBloc>().add(AuthLoggedOut());
              },
            ),
            Text(_version != null ? "Version: $_version" : "Loading..."),
          ],
        ),
      ),
    );
  }
}
