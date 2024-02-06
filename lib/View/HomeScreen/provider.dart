import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 class NotifyProvider extends ChangeNotifier {
   bool isNotificationOpen = false;


    openclose(){
       isNotificationOpen = !isNotificationOpen;
      notifyListeners();
    }

 }