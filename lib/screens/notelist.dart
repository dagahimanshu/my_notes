import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notedetails.dart';

class notelist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return noteliststate();
  }
}

class noteliststate extends State<notelist> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("my notes"),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[300],
      body: noteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) {
            return notedetails.XY("Add note");
          }));
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  StreamBuilder noteListView() {
    Color x;
    TextStyle tstyle = Theme.of(context).textTheme.subhead;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('notes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                if (document['priority'] == 1) {
                  x = Colors.red;
                } else
                  x = Colors.yellow;
                return Card(
                    color: Theme.of(context).primaryColorLight,
                    elevation: 2.0,
                    child: ListTile(
                      title: new Text(document['title'],style: tstyle,),
                      subtitle: new Text(document['desc'],style: TextStyle(color: Colors.blueGrey[900])),
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                        child: Icon(Icons.list, color: x),
                      ),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) {
                          return notedetails(document,"Edit note");
                        }));
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.grey,
                        onPressed: () {
                          String str = document.documentID;
                          Firestore.instance.document('notes/'+str).delete().whenComplete(() => print("deleted Successfully"))
                              .catchError((e) {
                            print(e);
                          });
                        },
                      ),
                    ));
              }).toList(),
            );
        }
      },
    );

  }
}
