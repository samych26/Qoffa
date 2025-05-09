import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddQoffaController with ChangeNotifier {
  // Champs
  final titleController = TextEditingController();
  final initialPriceController = TextEditingController();
  final discountedPriceController = TextEditingController();
  final descriptionController = TextEditingController();

  // Erreurs
  String? titleError;
  String? initialPriceError;
  String? discountedPriceError;
  String? descriptionError;
  String? imageError;

  // Image sélectionnée
  File? selectedImage;

  bool get isFormValid {
    return titleError == null &&
        initialPriceError == null &&
        discountedPriceError == null &&
        descriptionError == null &&
        imageError == null;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      selectedImage = File(result.files.single.path!);
      imageError = null;
      notifyListeners();
    }
  }

  void validateFields() {
    titleError = titleController.text.trim().isEmpty ? "Title is required" : null;

    initialPriceError = initialPriceController.text.trim().isEmpty
        ? "Initial price is required"
        : double.tryParse(initialPriceController.text.trim()) == null
        ? "Invalid number"
        : null;

    discountedPriceError = discountedPriceController.text.trim().isEmpty
        ? "Discounted price is required"
        : double.tryParse(discountedPriceController.text.trim()) == null
        ? "Invalid number"
        : null;

    descriptionError = descriptionController.text.trim().isEmpty ? "Description is required" : null;

    imageError = selectedImage == null ? "You must select an image" : null;

    notifyListeners();
  }

  void resetForm() {
    titleController.clear();
    initialPriceController.clear();
    discountedPriceController.clear();
    descriptionController.clear();
    selectedImage = null;

    titleError = null;
    initialPriceError = null;
    discountedPriceError = null;
    descriptionError = null;
    imageError = null;

    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    initialPriceController.dispose();
    discountedPriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
