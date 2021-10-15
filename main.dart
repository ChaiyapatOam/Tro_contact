import 'dart:ffi';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Permission permission;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  void _listenForPermission() async {
    final status = await Permission.contacts.status;
    setState(() {
      permissionStatus = status;
    });
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();

        break;
      case PermissionStatus.granted:
        //Do Nothing
        break;
      case PermissionStatus.limited:
        Navigator.pop(context);

        break;
      case PermissionStatus.restricted:
        Navigator.pop(context);

        break;
      case PermissionStatus.permanentlyDenied:
        Navigator.pop(context);

        break;
    }
  }

  Future<void> requestForPermission() async {
    final status = await Permission.contacts.request();
    setState(() {
      permissionStatus = status;
    });
  }

  @override
  void initState() {
    _listenForPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Permission",
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text("Let's Begin"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName.toString()),
                  subtitle: Text(contact.phones.toString()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
