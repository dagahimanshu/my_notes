import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/screens/notelist.dart';

class notedetails extends StatefulWidget {
  String _page;
  DocumentSnapshot document;

  notedetails(this.document, this._page);

  notedetails.XY(this._page);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    if (_page.compareTo("Edit note") == 0)
      return notedetailsState(document, _page);
    else
      return notedetailsState.XY(_page);
  }
}

class notedetailsState extends State<notedetails> {
  String pageTitle;

  DocumentSnapshot document;
  final documentReference = Firestore.instance.collection('notes');

  notedetailsState(this.document, this.pageTitle);

  notedetailsState.XY(this.pageTitle);

  String _title = null;
  String _description = null;
  int _priority = 0;

  set title(String value) {
    _title = value;
  }

  static var _priorities = ['high', 'low'];
  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey[300],
          appBar: AppBar(
            title: Text(pageTitle),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
              padding: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                      style: TextStyle(
                        color: Colors.blueGrey[900]
                      ),
                        items: _priorities.map((String dropdownItem) {
                          return DropdownMenuItem<String>(

                            value: dropdownItem,
                            child: Text(dropdownItem),
                          );
                        }).toList(),
                        value: _getPriorityAsString(this._priority),
                        onChanged: (valueByUser) {
                          setState(() {
                            _getPriorityAsInt(valueByUser);
                          });
                        }),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                      child: TextField(

                        controller: titleCont,
                        onChanged: (value) {
                          setState(() {
                            updateText();
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                      child: TextField(
                        controller: descCont,
                        onChanged: (value) {
                          setState(() {
                            updateDesc();
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                padding:
                                    EdgeInsets.only(top: 15.0, bottom: 15.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  "Save",
                                  textScaleFactor: 1.2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    onSave();
                                  });
                                }),
                          ),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                padding:
                                    EdgeInsets.only(top: 15.0, bottom: 15.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text("Delete", textScaleFactor: 1.2),
                                onPressed: () {
                                  setState(() {
                                    onDelete();
                                  });
                                }),
                          )
                        ],
                      ))
                ],
              )),
        ));
  }

  String _getPriorityAsString(int i) {
    if (i == 1) {
      return _priorities[0];
    } else
      return _priorities[1];
  }

  void _getPriorityAsInt(String x) {
    if (x == _priorities[0]) {
      this._priority = 1;
    } else {
      this._priority = 2;
    }
  }

  void updateText() {
    this._title = titleCont.text;
  }

  void updateDesc() {
    this._description = descCont.text;
  }

  void onSave() {
    Map<String, dynamic> data = <String, dynamic>{
      "title": _title,
      "desc": _description,
      'priority': _priority,
    };
    if (pageTitle.compareTo("Edit note") != 0) {
      documentReference
          .add(data)
          .whenComplete(() => print("added Successfully"))
          .catchError((e) {
        print(e);
      });
    }
    else {
      String str = document.documentID ;
      Firestore.instance.document('notes/'+str).updateData(data).whenComplete(() => print("updated Successfully"))
          .catchError((e) {
        print(e);
      });
    }
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return notelist();
    }));
  }

  void onDelete() {
    if (pageTitle.compareTo("Edit note") == 0) {
      String str = document.documentID ;
      Firestore.instance.document('notes/'+str).delete().whenComplete(() => print("deleted Successfully"))
          .catchError((e) {
        print(e);
      });
    }
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return notelist();
    }));
  }

  set description(String value) {
    _description = value;
  }

  set priority(int value) {
    _priority = value;
  }
}
