import 'package:athlete_hub/helpers/imports.dart';

class SettingsDesktop extends StatefulWidget {
  const SettingsDesktop({super.key});

  @override
  State<SettingsDesktop> createState() => _SettingsDesktopState();
}

class _SettingsDesktopState extends State<SettingsDesktop> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _picture;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) Image.file(_imageFile!, height: 200),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _getFromGallery,
              child: const Text("Pick Image"),
            ),
          ],
        ),
      ),
    );
  }
}
