import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FilterListProvider extends ChangeNotifier {
  List<String> addAllergies = [];
  List<String> addDietaryRestrictions = [];
  List<String> addPreferredProtein = [];
  List<String> addKitchenResources = [];
  List<String> addRegionalDelicacy = [];

  addAllergy(String allergies) {
    addAllergies.add(allergies);
    notifyListeners();
  }

  removeAllergy(String allergies) {
    addAllergies.remove(allergies);
    notifyListeners();
  }

  addDietary(String diataries) {
    addDietaryRestrictions.add(diataries);
    notifyListeners();
  }

  removeDietary(String diataries) {
    addDietaryRestrictions.remove(diataries);
    notifyListeners();
  }

///////////////////
  addproteins(String proteins) {
    addPreferredProtein.add(proteins);
    notifyListeners();
  }

  removeProteins(String proteins) {
    addPreferredProtein.remove(proteins);
    notifyListeners();
  }

////////////////////////////////
  addRegional(String regional) {
    addRegionalDelicacy.add(regional);
    notifyListeners();
  }

  removeRegional(String regional) {
    addRegionalDelicacy.remove(regional);
    notifyListeners();
  }

////////////////////////////////
  addKitchenResource(String resources) {
    addKitchenResources.add(resources);
    notifyListeners();
  }

  removeKitchenResource(String resources) {
    addKitchenResources.remove(resources);
    notifyListeners();
  }

  dellAllergy() {
    addAllergies.clear();
    addDietaryRestrictions.clear();
    addPreferredProtein.clear();
    addRegionalDelicacy.clear();
    addKitchenResources.clear();
    notifyListeners();
  }
}
