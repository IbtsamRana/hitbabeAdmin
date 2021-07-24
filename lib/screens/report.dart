import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u_admin/model/user.dart';
import 'package:hookup4u_admin/screens/user_info.dart';

class Report extends StatefulWidget {
  @override
  _ChangeIdPasswordState createState() => _ChangeIdPasswordState();
}

class _ChangeIdPasswordState extends State<Report> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference collectionReference =
      Firestore.instance.collection("Reports");
  TextEditingController newId = new TextEditingController();
  TextEditingController newPasswd = new TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("User Reports"),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("These are the people reported by Users",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0)),
                  StreamBuilder<QuerySnapshot>(
                    stream: collectionReference
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Text(
                          "No Report found",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ));
                      else if (snapshot.data.documents.length == 0) {
                        return Center(
                            child: Text(
                          "No Report found",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ));
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: 500,
                        child: ListView(
                          children: snapshot.data.documents
                              .map((doc) => Column(
                                    children: [
                                      ListTile(
                                        trailing: Text(
                                            "${doc.data['reason'] ?? "__"}"),
                                        title: Text(
                                            "${doc.data['victim_id'] ?? "__"} was Reported as"),

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Info(
                                        //             doc.data['victim_id'])));
                                      ),
                                      Divider(
                                        thickness: .5,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
