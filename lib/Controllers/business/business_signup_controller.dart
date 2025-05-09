import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../Models/commerce_modele.dart';
import '../../views/business/account_pending_view.dart';

class BusinessSignUpController extends ChangeNotifier {
  // Errors
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  String? businessNameError;
  String? phoneNumberError;
  String? registrationNumberError;
  String? addressError;
  String? registrationFileError;
  String? globalMessage;

  // File state
  PlatformFile? _selectedFile;
  bool isLoading = false;

  // Getters
  String? get fileName => _selectedFile?.name;
  bool get isSuccessMessage => globalMessage?.contains('🎉') ?? false;

  Future<void> pickRegistrationFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        _selectedFile = result.files.first;
        registrationFileError = null;
      } else {
        registrationFileError = "Veuillez sélectionner un fichier PDF";
      }
    } catch (e) {
      registrationFileError = "Erreur lors de la sélection du fichier";
    }
    notifyListeners();
  }

  bool validateFirstPage({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    firstNameError = firstName.isEmpty ? "Prénom requis" : null;
    lastNameError = lastName.isEmpty ? "Nom requis" : null;
    emailError = email.isEmpty ? "Email requis" : null;
    passwordError = password.length < 6 ? "6 caractères minimum" : null;

    notifyListeners();
    return firstNameError == null &&
        lastNameError == null &&
        emailError == null &&
        passwordError == null;
  }

  Future<void> registerBusiness({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String category,
    required String businessName,
    required String phoneNumber,
    required String address,
    required String registrationNumber,
  }) async {
    isLoading = true;
    globalMessage = null;
    notifyListeners();

    // Validation
    addressError = address.isEmpty ? "Adresse requise" : null;
    registrationFileError = _selectedFile == null ? "Fichier requis" : null;

    if (addressError != null || registrationFileError != null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // 1. Créer l'utilisateur
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userId = userCredential.user!.uid;

      // 2. Vérifier que le fichier existe
      final file = File(_selectedFile!.path!);
      if (!file.existsSync()) {
        globalMessage = "Le fichier sélectionné n'existe pas";
        isLoading = false;
        notifyListeners();
        return;
      }

      // 3. Upload du fichier avec métadonnées
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('business_docs/$userId/${_selectedFile!.name}');
      final metadata = SettableMetadata(contentType: 'application/pdf');

      final snapshot = await storageRef.putFile(file, metadata).whenComplete(() {});
      if (snapshot.state != TaskState.success) {
        globalMessage = "Échec de l'upload du fichier";
        isLoading = false;
        notifyListeners();
        return;
      }

      final fileUrl = await storageRef.getDownloadURL();

      // 4. Créer un objet Commerce
      final commercant = Commerce(
        idUtilisateur: userId,
        nom: lastName,
        prenom: firstName,
        email: email,
        motDePasse: password,
        photoDeProfile: '',
        typeUtilisateur: 'Commerce',
        nomCommerce: businessName,
        adresseCommerce: address,
        numTelCommerce: phoneNumber,
        horaires: '',
        description: '',
        numRegistreCommerce: registrationNumber,
        registreCommerce: fileUrl,
        etatCompteCommercant: 'en attente',
        categorie: category,
        note: 0.0,
        nbNotes: 0,
      );

      // 5. Sauvegarder dans Firestore
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userRef = FirebaseFirestore.instance.collection('Utilisateur').doc(userId);
        final businessRef = FirebaseFirestore.instance.collection('Commerce').doc(userId);

        transaction.set(userRef, commercant.toMapUtilisateur());
        transaction.set(businessRef, commercant.toMapCommercant());
      });

      globalMessage = "🎉 Inscription réussie ! Votre compte est en attente de validation.";
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AccountPendingView()),
      );
    } on FirebaseAuthException catch (e) {
      globalMessage = "Erreur d'authentification: ${e.message}";
    } on FirebaseException catch (e) {
      globalMessage = "Erreur Firebase: ${e.code} - ${e.message}";
    } catch (e) {
      globalMessage = "Erreur inattendue: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
