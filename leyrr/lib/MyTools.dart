import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomModal{
  GlobalKey headerKey = GlobalKey();
  double headerHeight = 0;

  static void openCustomModal({
    required BuildContext context,
    required List<ModalOption> options,
    Widget? header,
  }) {
    PageController pageController = PageController();
    GlobalKey headerKey = GlobalKey();
    double headerHeight = 0;
    double modalHeight = setModalHeight(options.length, 0);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 10,
              right: 10,
              top: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                if (header != null) ...[
                  Container(key: headerKey, child: header),
                  const Divider(),
                ],

                // Bloc options
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: option.onTap,
                            child: _buildTextButton(
                              option.icon,
                              option.label,
                              option.color,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 16),

                // Bloc Annuler
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // ferme la modal
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Annuler", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }

    );
  }

  static double setModalHeight(int optionsLength, double headerHeight){
    if(Platform.isIOS){
      return optionsLength * 66 + 50 + headerHeight;
    }
    return optionsLength * 66 + 35 + headerHeight;
  }

  static Padding buildHeader({
    String? title,
    required List<Widget> subtitles,
    String? imageURL,
    Future<File>? imageFile,
    bool isImage = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 48),
      child: Column(
        children: [
          Row(
            children: [
              if (!isImage)
                _buildPdfPreview()
              else if (imageFile != null)
                FutureBuilder<File>(
                  future: imageFile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingPreview();
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return _buildErrorPreview();
                    } else {
                      return _buildImageFilePreview(snapshot.data!);
                    }
                  },
                )
              else if (imageURL != null && imageURL.isNotEmpty)
                  _buildImageNetworkPreview(imageURL),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(title != null && title.isNotEmpty) Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...subtitles,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildImageFilePreview(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.file(
        file,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget _buildImageNetworkPreview(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        url,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget _buildPdfPreview() {
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey.shade300,
      ),
      child: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  static Widget _buildLoadingPreview() {
    return Container(
      height: 75,
      width: 75,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  static Widget _buildErrorPreview() {
    return Container(
      height: 75,
      width: 75,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image,
        color: Colors.grey,
      ),
    );
  }
}

// Modèle pour représenter une option de la modale
class ModalOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  ModalOption({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

// Fonction pour construire les boutons de la modale
Widget _buildTextButton(IconData icon, String text, Color color) {
  return Container(
    padding: EdgeInsets.all(16),
    width: double.infinity,
    child: Row(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: color),
        ),
      ],
    ),
  );
}