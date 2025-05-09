import 'dart:io';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leyrr/EcoBadges.dart';
import 'package:leyrr/MyTools.dart';

class EditorScreen extends StatefulWidget {
  final String templateName;

  const EditorScreen({
    Key? key,
    required this.templateName,
  }) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  int currentPage = 0;
  List<List<Widget>> slideElements = [[]];
  List<TextElement> textElements = [];
  List<ImageElement> imageElements = []; // Liste des éléments image

  GlobalKey<_DraggableTextBoxState>? selectedKey;
  Key? selectedImageKey;
  String activeTool = '';

  final fontSizes = [6.0, 8.0, 10.0, 12.0, 18.0, 24.0];
  double selectedFontSize = 12.0;
  final fontFamilies = ['Arial', 'Roboto', 'Creato'];
  String selectedFontFamily = 'Arial';
  bool isBoldSelected = false;
  bool isItalicSelected = false;

  bool canShowSuccessBanner = false;
  bool showSuccessBanner = false;
  bool showEcoSuggestion = false;
  late ConfettiController _confettiController;


  Map<GlobalKey<_DraggableTextBoxState>, TextStyle> textStyles = {};

  final List<String> availableImageAssets = [
    'Assets/Images/Slide_Image_7.png',
    'Assets/Images/Slide_Image_1.png',
    'Assets/Images/Slide_Image_5.png',
    'Assets/Images/Slide_Image_2.png',
    'Assets/Images/Slide_Image_3.png',
    'Assets/Images/Slide_Image_4.png',
    'Assets/Images/Slide_Image_6.png',
  ];

  final List<String> languages = [
    'French (France)',
    'French (Canada)',
    'French (Belgium)',
    'French (Switzerland)',
    'French (Luxembourg)',
    'French (Senegal)',
    'French (Ivory Coast)',
    'French (Cameroon)',
    'French (Tunisia)',
    'French (Morocco)',
    'French (Algeria)',
    'French (Madagascar)',
    'French (Haiti)',
    'French (DR of the Congo)',
  ];


  final Map<String, Map<String, String>> translations = {
    'English expression': {
      'French (France)': 'Ça ne sert à rien de sans cesse passer du coq à l\'âne.',
      'French (Canada)': 'Ça ne sert à rien de constamment passer du coq à l\'âne.',
      'French (Belgium)': 'Ça ne sert à rien de passer sans arrêt du coq à l\'âne.',
      'French (Switzerland)': 'Ça ne sert à rien de changer de sujet tout le temps, comme ça.',
      'French (Luxembourg)': 'Ça ne sert à rien de constamment passer du coq à l\'âne.',
      'French (Senegal)': 'Ça ne sert à rien de toujours passer du coq à l\'âne comme ça.',
      'French (Ivory Coast)': 'Ça ne sert à rien de sans cesse changer de sujet à gauche et à droite.',
      'French (Cameroon)': 'Ça ne sert à rien de toujours passer du coq à l\'âne sans raison.',
      'French (Tunisia)': 'Ça ne sert à rien de constamment passer du coq à l\'âne.',
      'French (Morocco)': 'Ça ne sert à rien de passer sans arrêt du coq à l\'âne.',
      'French (Algeria)': 'Ça ne sert à rien de changer de sujet sans cesse.',
      'French (Madagascar)': 'Ça ne sert à rien de passer du coq à l\'âne à chaque instant.',
      'French (Haiti)': 'Ça ne sert à rien de toujours changer de sujet comme ça.',
      'French (DR of the Congo)': 'Ça ne sert à rien de passer du coq à l\'âne sans arrêt.',
    },
  };


  String? ecoFontSuggestion = "";
  String? _selectedLanguage;

  GlobalKey<_DraggableTextBoxState>? selectedTextKey;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          _updateSelection(textKey: null, imageKey: null);
        });
      },
      child: Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back, color: Colors.white)),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.arrowRotateLeft, color: Colors.white, size: 25),
                      SizedBox(width: 30),
                      FaIcon(FontAwesomeIcons.arrowRotateRight, color: Colors.white, size: 25),
                    ],
                  )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.smart_display, color: Colors.white),
                      onPressed: () {
                        // Implémenter la sauvegarde
                      },
                    ),
                    Transform.rotate(
                      angle: 90 * math.pi / 180,
                      child: IconButton(
                        onPressed: (){
                          CustomModal.openCustomModal(
                              context: context,
                              options: [
                                ModalOption(
                                    icon: Icons.save_outlined,
                                    label: 'Save changes',
                                    color: Colors.black,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      if(!showEcoSuggestion && canShowSuccessBanner){
                                        showEcoFontSuccess();
                                      }
                                    }
                                ),
                                ModalOption(
                                    icon: Icons.access_time_sharp,
                                    label: 'Version history',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.format_paint_outlined,
                                    label: 'Change template',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.expand_rounded,
                                    label: 'Resize',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.remove_red_eye_outlined,
                                    label: 'View',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.help_outline_rounded,
                                    label: 'Help',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.settings,
                                    label: 'Edit project',
                                    color: Colors.black
                                ),
                                ModalOption(
                                    icon: Icons.delete_forever_rounded,
                                    label: 'Delete project',
                                    color: Colors.red
                                ),
                              ]
                          );
                        },
                        icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          body: Column(
            children: [
              // Container principal avec Stack pour les éléments de la diapositive
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0, // Utilisation de Positioned pour ajuster la taille
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width / 1.7,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _updateSelection(textKey: null, imageKey: null);
                              });
                            },
                            onPanUpdate: (_) {
                              setState(() {
                                _updateSelection(textKey: null, imageKey: null);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: InteractiveViewer(
                                  panEnabled: false,
                                  boundaryMargin: const EdgeInsets.all(100),
                                  minScale: 0.5,
                                  maxScale: 3.0,
                                  child: Stack(
                                    children: slideElements[currentPage],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Affichage des outils en bas en fonction de l'outil actif
                    if (activeTool == 'image') ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: availableImageAssets.length,
                            itemBuilder: (context, index) {
                              final path = availableImageAssets[index];
                              return GestureDetector(
                                onTap: () => _addImageFromAsset(path),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.asset(path, width: 50, height: 50),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ] else if (activeTool == 'text') ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildTextOptionsBar(),
                      ),
                    ],

                    // Section pour l'outil de traduction
                    if (activeTool == 'traduire') ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: _buildDropdownField(
                                  label: "Language",
                                  value: _selectedLanguage,
                                  items: languages,
                                  onChanged: (value) => setState(() => _selectedLanguage = value),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  _updateTextBasedOnLanguage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text('Translate', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Affichage de la barre de navigation des slides
                    if (activeTool == 'slide') ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: slideElements.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => setState(() => currentPage = index),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: currentPage == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Center(child: Text("${index + 1}")),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    if(activeTool == "text" && showSuccessBanner)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            // Confettis
                            AbsorbPointer(
                              child: Container(
                                height: 150,
                                color: Colors.red, // juste pour visualiser
                                child: ConfettiWidget(
                                  confettiController: _confettiController,
                                  blastDirection: -math.pi / 2,
                                  emissionFrequency: .01,
                                  numberOfParticles: 20,
                                  gravity: 0.3,
                                  shouldLoop: false,
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ],
                                  // Personnalise la taille ici :
                                  createParticlePath: (size) {
                                    final Path path = Path();
                                    // Un petit cercle de rayon 2
                                    path.addOval(Rect.fromCircle(center: Offset(0, 0), radius: 4));
                                    return path;
                                  },
                                ),
                              ),
                            ),

                            // Bannière de succès animée
                            AnimatedSlide(
                              duration: const Duration(milliseconds: 500),
                              offset: showSuccessBanner ? Offset.zero : const Offset(0, 1),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: showSuccessBanner ? 1.0 : 0.0,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Column(
                                    children: [
                                      // Row with icon and text
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.emoji_events, color: Colors.green),
                                          SizedBox(width: 8),
                                          Text(
                                            "You've saved 100g of CO2! 🎉",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Spacer for better layout
                                      SizedBox(height: 12),

                                      // Button to navigate to badges page
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigate to the Badges Page (you need to define the BadgesPage)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EcoBadges()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green, // Green button
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "View Badges",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),

                    if(activeTool == "text")
                    // Ajout de la suggestion de police juste en dessous de la présentation
                    Positioned(
                      bottom: 80,  // Ajustez cette valeur selon la hauteur de vos éléments en bas
                      left: 16,
                      right: 16,
                      child: _buildEcoFontSuggestion(),
                    ),

                    // Confettis et succès visuel (positionné exactement comme la suggestion)


                  ],
                ),
              ),

              // Barre d'outils en bas
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildToolButton(Icons.text_fields, "Text", () {
                      setState(() {
                        activeTool = 'text';
                      });
                    }),
                    _buildToolButton(Icons.image, "Image", () {
                      setState(() {
                        activeTool = 'image';
                      });
                    }),
                    _buildToolButton(Icons.translate, "Translate", () {
                      setState(() {
                        activeTool = 'traduire';
                      });
                    }),
                    _buildToolButton(Icons.add_box, "Slide", () {
                      setState(() {
                        //_addNewSlide();
                        activeTool = 'slide';
                      });
                    }),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  void _updateTextBasedOnLanguage() {
    if (selectedTextKey == null || _selectedLanguage == null) return;

    final key = selectedTextKey!; // Déjà un GlobalKey<_DraggableTextBoxState>
    final selectedTranslation = translations['English expression']?[_selectedLanguage!];

    print(_selectedLanguage);
    print(selectedTranslation);

    if (selectedTranslation != null) {
      final textWidget = slideElements[currentPage].firstWhere(
            (element) => element.key == selectedTextKey,
        orElse: () => _DraggableTextBox(
          key: key,
          textStyle: TextStyle(fontSize: selectedFontSize, color: Colors.black),
          initialText: "Text not found",
        ),
      ) as _DraggableTextBox;

      // Modifier le texte du widget sélectionné
      key.currentState?.updateText(selectedTranslation);
    }
  }


  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      validator: (value) =>
      value == null ? 'Veuillez sélectionner une option' : null,
    );
  }


  void _updateTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
  }) {
    if (selectedTextKey == null) return;

    final key = selectedTextKey!; // Déjà un GlobalKey<_DraggableTextBoxState>

    final oldStyle = textStyles[key] ?? const TextStyle();

    final newStyle = oldStyle.copyWith(
      fontSize: fontSize ?? oldStyle.fontSize,
      fontWeight: fontWeight ?? oldStyle.fontWeight,
      fontStyle: fontStyle ?? oldStyle.fontStyle,
      fontFamily: fontFamily ?? oldStyle.fontFamily,
    );

    // ✅ Affectation directe, types alignés
    textStyles[key] = newStyle;

    // ✅ Appel méthode sur state via GlobalKey
    key.currentState?.updateTextStyle(newStyle);

    setState(() {});
  }


  void _updateSelection({
    GlobalKey<_DraggableTextBoxState>? textKey,
    Key? imageKey,
  }) {
    selectedTextKey = textKey;
    selectedImageKey = imageKey;

    for (var element in slideElements[currentPage]) {
      if (element is _DraggableTextBox && element.key is GlobalKey<_DraggableTextBoxState>) {
        final key = element.key as GlobalKey<_DraggableTextBoxState>;
        key.currentState?.setSelected(key == textKey);
      }

      if (element is _DraggableImageBox && element.key is GlobalKey<_DraggableImageBoxState>) {
        final key = element.key as GlobalKey<_DraggableImageBoxState>;
        key.currentState?.setSelected(key == imageKey);
      }
    }

    setState(() {}); // Pour déclencher un léger rebuild global si nécessaire
  }


  Widget _buildTextOptionsBar() {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          // Bold button
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
              icon: Icon(Icons.add,
                  color: Colors.black),
              onPressed: () {
                _addTextElement();
              },
            ),
          ),

          // Font size dropdown
          DropdownButton<double>(
            value: selectedFontSize,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15),
            underline: Container(height: 0),
            onChanged: (value) {
              setState(() {
                selectedFontSize = value!;
              });
              if (value != null) _updateTextStyle(fontSize: value);
            },
            items: fontSizes.map((size) {
              return DropdownMenuItem<double>(
                value: size,
                child: Text("${size.toInt()} pt"),
              );
            }).toList(),
          ),

          // Font family dropdown
          DropdownButton<String>(
            value: selectedFontFamily,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15),
            underline: Container(height: 0),
            onChanged: (value) {
              setState(() {
                selectedFontFamily = value!;
              });
              if (value != null){
                _updateTextStyle(fontFamily: value);
                _showEcoFontSuggestion(value);
              }

            },
            items: fontFamilies.map((font) {
              return DropdownMenuItem<String>(
                value: font,
                child: Text(font),
              );
            }).toList(),
          ),



          // Bold button
          Container(
            decoration: BoxDecoration(
              color: isBoldSelected ? Colors.grey : Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
              icon: Icon(Icons.format_bold,
                  color: isBoldSelected ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  isBoldSelected = !isBoldSelected;
                });
                _updateTextStyle(
                  fontWeight: !isBoldSelected ? FontWeight.normal : FontWeight.bold,
                );
              },
            ),
          ),

          // Italic button
          Container(
            decoration: BoxDecoration(
                color: isItalicSelected ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
              icon: Icon(Icons.format_italic,
                  color: isItalicSelected ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  isItalicSelected = !isItalicSelected;
                });
                _updateTextStyle(
                  fontStyle: !isItalicSelected ? FontStyle.normal : FontStyle.italic,
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void showEcoFontSuccess() {
    setState(() {
      showSuccessBanner = true;
    });
    _confettiController.play();
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        showSuccessBanner = false;
      });
    });
  }


  void _showEcoFontSuggestion(String selectedFont) {
    final ecoFonts = ['Roboto', 'Arial', 'Open Sans', 'Noto Sans', 'Helvetica'];
    if (!ecoFonts.contains(selectedFont)) {
      setState(() {
        showEcoSuggestion = true;
        ecoFontSuggestion = 'Did you know that "$selectedFont" is less energy-efficient? Try a font like "Roboto" to reduce your carbon footprint!';
      });
    } else {
      setState(() {
        if(showEcoSuggestion){
          canShowSuccessBanner = true;
          showEcoSuggestion = false;
        }
        ecoFontSuggestion = null;  // Aucune suggestion si la police est écologique
      });
    }
  }

  Widget _buildEcoFontSuggestion() {
    if (ecoFontSuggestion == "") {
      return Text(""); // Si la suggestion est vide, ne rien afficher.
    }

    if (ecoFontSuggestion != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF9DCFFA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue,
              width: 2, // Épaisseur de la bordur
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Permet au texte de faire un retour à la ligne
            children: [
              Icon(
                Icons.info_outline, // L'icône que vous souhaitez à gauche du texte
                color: Colors.black87,
                size: 20, // Ajustez la taille de l'icône selon votre besoin
              ),
              SizedBox(width: 8), // Espacement entre l'icône et le texte
              Flexible( // Utilise Flexible pour permettre au texte de s'ajuster et passer à la ligne
                child: Text(
                  ecoFontSuggestion!,
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                  softWrap: true, // Permet au texte de faire un retour à la ligne
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox.shrink(); // Si aucune suggestion, ne rien afficher.
  }



  Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12))
      ],
    );
  }

  void _addTextElement() {
    final elementKey = GlobalKey<_DraggableTextBoxState>();
    final defaultStyle = TextStyle(fontSize: selectedFontSize, color: Colors.black);

    textStyles[elementKey] = defaultStyle;

    final textWidget = _DraggableTextBox(
      key: elementKey,
      textStyle: defaultStyle,
      onTap: () => _updateSelection(textKey: elementKey),
      onRemove: () {
        setState(() {
          slideElements[currentPage].removeWhere((element) => element.key == elementKey);
          textStyles.remove(elementKey);
          if (selectedTextKey == elementKey) selectedTextKey = null;
        });
      },
      isSelected: false,
    );

    // 🔁 1. Ajoute l'élément
    setState(() {
      slideElements[currentPage].add(textWidget);
    });

    // ✅ 2. Sélectionne l'élément APRES l’avoir ajouté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelection(textKey: elementKey);
    });
  }

  void _addImageFromAsset(String assetPath) {
    final imageKey = GlobalKey<_DraggableImageBoxState>();

    final imageWidget = _DraggableImageBox(
      key: imageKey,
      image: AssetImage(assetPath),
      initialX: 50,
      initialY: 50,
      onTap: () => _updateSelection(imageKey: imageKey),
      onRemove: () {
        setState(() {
          slideElements[currentPage].removeWhere((element) => element.key == imageKey);
          if (selectedImageKey == imageKey) selectedImageKey = null;
        });
      },
      isSelected: false,
    );


    setState(() {
      slideElements[currentPage].add(imageWidget);
    });
  }


}

class TransparencyGrid extends StatelessWidget {
  final double squareSize;
  final Color color1;
  final Color color2;

  const TransparencyGrid({
    super.key,
    this.squareSize = 10,
    this.color1 = const Color(0xFFDADADA),
    this.color2 = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckerboardPainter(
        squareSize: squareSize,
        color1: color1,
        color2: color2,
      ),
      size: Size.infinite,
    );
  }
}

class _CheckerboardPainter extends CustomPainter {
  final double squareSize;
  final Color color1;
  final Color color2;

  _CheckerboardPainter({
    required this.squareSize,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        final isEven = ((x / squareSize).floor() + (y / squareSize).floor()) % 2 == 0;
        paint.color = isEven ? color1 : color2;
        canvas.drawRect(Rect.fromLTWH(x, y, squareSize, squareSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _DraggableTextBox extends StatefulWidget {
  final VoidCallback? onRemove;
  final bool isSelected;
  final VoidCallback? onTap;
  final TextStyle textStyle;
  final String initialText;

  const _DraggableTextBox({
    super.key,
    this.onRemove,
    this.isSelected = false,
    this.onTap,
    required this.textStyle,
    this.initialText = '',
  });

  @override
  State<_DraggableTextBox> createState() => _DraggableTextBoxState();
}

class _DraggableTextBoxState extends State<_DraggableTextBox> {
  double x = 50;
  double y = 50;
  double width = 150;
  double height = 100;
  bool _isSelected = false;


  late TextEditingController _controller;
  late TextStyle currentTextStyle;

  void setSelected(bool selected) {
    setState(() {
      _isSelected = selected;
    });
  }

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _controller = TextEditingController(text: widget.initialText);
    currentTextStyle = widget.textStyle;
  }

  void updateTextStyle(TextStyle newStyle) {
    setState(() {
      currentTextStyle = newStyle;
    });
  }

  // Ajout de la méthode pour mettre à jour le texte
  void updateText(String newText) {
    setState(() {
      _controller.text = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
        },
        onPanUpdate: (details) {
          setState(() {
            x += details.delta.dx;
            y += details.delta.dy;
          });
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: width,
                height: height,
                decoration: _isSelected ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent),
                ) : null,
                child: TextField(
                  controller: _controller,
                  style: currentTextStyle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type text...',
                  ),
                  onTap: () {
                    widget.onTap?.call();
                  },
                ),
              ),
            ),
            if (_isSelected) ...[
              // Ajustement des poignées de redimensionnement avec un décalage de 8px
              ResizeHandle(
                bottom: 0, right: 0, // Décalage de 8 pixels vers l'intérieur
                onPanUpdate: (details) {
                  setState(() {
                    width += details.delta.dx;
                    height += details.delta.dy;
                    width = width.clamp(50, 1000);
                    height = height.clamp(30, 1000);
                  });
                },
              ),
              // BOTTOM LEFT avec décalage de 8px vers l'intérieur
              ResizeHandle(
                bottom: 0, left: 0,
                onPanUpdate: (details) {
                  setState(() {
                    width -= details.delta.dx;
                    height += details.delta.dy;
                    x += details.delta.dx; // Déplace le coin gauche
                    width = width.clamp(50, 1000);
                    height = height.clamp(30, 1000);
                  });
                },
              ),
              // TOP LEFT avec décalage de 8px vers l'intérieur
              ResizeHandle(
                top: 0, left: 0,
                onPanUpdate: (details) {
                  setState(() {
                    width -= details.delta.dx;
                    height -= details.delta.dy;
                    x += details.delta.dx;
                    y += details.delta.dy;
                    width = width.clamp(50, 1000);
                    height = height.clamp(30, 1000);
                  });
                },
              ),
              // TOP RIGHT avec décalage de 8px vers l'intérieur
              ResizeHandle(
                top: 0, right: 0,
                onPanUpdate: (details) {
                  setState(() {
                    width += details.delta.dx;
                    height -= details.delta.dy;
                    y += details.delta.dy;
                    width = width.clamp(50, 1000);
                    height = height.clamp(30, 1000);
                  });
                },
              ),
            ],
            if (_isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                    onTap: widget.onRemove,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.white,))),

              ),
          ],
        ),
      ),
    );
  }

}

class ResizeHandle extends StatelessWidget {
  final void Function(DragUpdateDetails) onPanUpdate;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? padding;

  const ResizeHandle({
    super.key,
    required this.onPanUpdate,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // Appliquer un décalage de 8 pixels vers l'intérieur pour chaque position
      top: top != null ? top! + 24 : null,
      left: left != null ? left! + 24 : null,
      right: right != null ? right! + 24 : null,
      bottom: bottom != null ? bottom! + 24 : null,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        child: CustomPaint(
          size: const Size(10, 10),
          painter: _CornerPainter(top, left, right, bottom),
        ),
      ),
    );
  }
}


class _CornerPainter extends CustomPainter {
  final double? top, left;
  final double? right, bottom;
  _CornerPainter(this.top, this.left, this.right, this.bottom);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = Path();

    if (top == 0 && right == 0) {
      // top-right
      path.moveTo(size.width, 0);
      path.lineTo(size.width - 20, 0);
      path.lineTo(size.width, 20);
    } else if (top == 0 && left == 0) {
      // top-left
      path.moveTo(0, 0);
      path.lineTo(20, 0);
      path.lineTo(0, 20);
    } else if (bottom == 0 && left == 0) {
      // bottom-left
      path.moveTo(0, size.height);
      path.lineTo(0, size.height - 20);
      path.lineTo(20, size.height);
    } else if (bottom == 0 && right == 0) {
      // bottom-right
      path.moveTo(size.width, size.height);
      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width - 20, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


// Nouvelle classe pour gérer les images
class ImageElement {
  final Key key;
  double x;
  double y;

  ImageElement({
    required this.key,
    required this.x,
    required this.y,
  });
}

class TextElement {
  final Key key;
  double x; // Position horizontale
  double y; // Position verticale
  TextElement({
    required this.key,
    required this.x,
    required this.y,
  });
}

class _DraggableImageBox extends StatefulWidget {
  final ImageProvider image;
  final double initialX;
  final double initialY;
  final bool isSelected;
  final VoidCallback? onTap;  // Ajout du callback pour la sélection
  final VoidCallback? onRemove; // Ajout du callback pour la suppression

  const _DraggableImageBox({
    super.key,
    required this.image,
    this.isSelected = false,
    this.initialX = 100,
    this.initialY = 100,
    this.onTap, // Ajout de onTap
    this.onRemove, // Ajout de onRemove
  });

  @override
  State<_DraggableImageBox> createState() => _DraggableImageBoxState();
}

class _DraggableImageBoxState extends State<_DraggableImageBox> {
  double x = 0;
  double y = 0;
  double height = 70;
  double width = 70 * 16/9;
  double rotation = 0.0;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    x = widget.initialX;
    y = widget.initialY;
  }

  void setSelected(bool selected) {
    setState(() {
      _isSelected = selected;
    });
  }

  int _pointerCount = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Listener(
        onPointerDown: (_) {
          _pointerCount++;
        },
        onPointerUp: (_) {
          _pointerCount--;
        },
        child: GestureDetector(
          onTap: () {
            widget.onTap?.call();
          }, // Sélectionner l'image au clic
          onPanUpdate: (details) {
            if (_pointerCount == 1) {
              // un seul doigt => déplacement simple
              setState(() {
                x += details.delta.dx;
                y += details.delta.dy;
              });
            }
          },
          child: Stack(
            children: [
              Transform.rotate(
                angle: rotation,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.image,
                      ),
                    ),
                  ),
                ),
              ),

              if (_isSelected) ...[
                // BOTTOM RIGHT
                ResizeHandle(
                  bottom: 0, right: 0,
                  onPanUpdate: (details) {
                    setState(() {
                      height += details.delta.dy;
                      width = height * (16 / 9);
                      height = height.clamp(25, 1000);
                      width = width.clamp(25, 1000);
                    });
                  },
                ),

                // BOTTOM LEFT
                ResizeHandle(
                  bottom: 0, left: 0,
                  onPanUpdate: (details) {
                    setState(() {
                      double oldWidth = width;
                      height += details.delta.dy;
                      height = height.clamp(25, 1000);
                      width = height * (16 / 9);
                      x -= (width - oldWidth); // décale correctement
                    });
                  },
                ),

                // TOP LEFT
                ResizeHandle(
                  top: 0, left: 0,
                  onPanUpdate: (details) {
                    setState(() {
                      double oldWidth = width;
                      double oldHeight = height;

                      height -= details.delta.dy;
                      height = height.clamp(25, 1000);
                      width = height * (16 / 9);

                      x += (oldWidth - width); // décale selon le nouveau width
                      y += (oldHeight - height); // idem pour la hauteur
                    });
                  },
                ),

                // TOP RIGHT
                ResizeHandle(
                  top: 0, right: 0,
                  onPanUpdate: (details) {
                    setState(() {
                      height -= details.delta.dy;
                      width = height * (16 / 9);
                      y += details.delta.dy;
                      height = height.clamp(25, 1000);
                      width = width.clamp(25, 1000);
                    });
                  },
                ),
              ],
              if(_isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                    onTap: widget.onRemove,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.white,))),

              ),
            ],
          ),

        ),
      ),
    );
  }
}