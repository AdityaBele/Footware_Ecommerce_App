import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

FirebaseOptions firebaseOptions = Platform.isAndroid?  FirebaseOptions(
    apiKey: "AIzaSyDNZDZsnVYBUcSXs5NFXTiJaa7m5CZOCX8",
    appId: "1:916963953669:android:6cf5e1e4f437b00b2a606c",
    messagingSenderId:"916963953669",
    projectId: "rapid-projectt-ddf6b"): const FirebaseOptions(
    apiKey: "AIzaSyBoiVCyOUlNlsoLiMSj3r85CRCLBrjn9Ec",
    appId: "1:916963953669:ios:2f79cd713028ccc22a606c",
    messagingSenderId: "916963953669",
    projectId: "rapid-projectt-ddf6b");
