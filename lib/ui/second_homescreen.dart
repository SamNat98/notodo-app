import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notodo/models/item_Class.dart';
import 'package:notodo/utils/data_storage.dart';
import 'package:notodo/utils/dateformatter.dart';

class Second_Screen extends StatefulWidget {
  @override
  _Second_ScreenState createState() => _Second_ScreenState();
}

class _Second_ScreenState extends State<Second_Screen> {

  final List<Items> _itemlists = <Items>[];

  var db = new DatabaseHelper();
  final TextEditingController _enteredItem = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _showFirst();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,

      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemCount: _itemlists.length,
              reverse: false,
              padding: new EdgeInsets.all(8.0),
              itemBuilder: (_, int index) {
                return new Card(
                    color: Colors.white10,
                    elevation: 4.0,
                    child: new ListTile(
                      title: new Text(_itemlists[index].itemname,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.9
                        ),),
                      contentPadding: new EdgeInsets.all(4.5),
                      subtitle: new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new Text(
                          "Created on: ${_itemlists[index].DataCreated}",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0
                          ),),
                      ),
                      onLongPress:()=> updateItem(_itemlists[index], index),
                      trailing: new Listener(
                        child: new Icon(Icons.remove_circle_outline,
                          color: Colors.redAccent,),
                        onPointerDown: (pointerEvent) {
                          deletitem(_itemlists[index].id, index);
                        },
                      ),
                    )
                );
              },
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ]
        ,
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: _showDialog,
        backgroundColor: Colors.redAccent,
        tooltip: "Add Item",
        child: new ListTile(
            title: new Icon(Icons.add)
        ),
      ),
    );
  }

  void _showDialog() {
    var alert = new AlertDialog(
      title: new Text("Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _enteredItem,
                autofocus: true,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.note_add),
                    labelText: "Enter Item",
                    hintText: "eg: Buy Clothes"
                ),
              )
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _ShowinList(_enteredItem.text);
            Navigator.pop(context);
          },
          child: new Text("Save"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        )
      ],
    );
    showDialog(context: context, builder: (_) {
      return alert;
    });
  }

  void _ShowinList(String text) async {
    _enteredItem.clear();
    Items notodoitem = new Items(text, formatteddate());

    var saveditem = await db.saveuser(notodoitem);

    print("Item saved $saveditem");

    Items additem = await db.getSingleUser(saveditem);
    setState(() {
      _itemlists.insert(0, additem);
    });
  }

  void _showFirst() async {
    List item = await db.getAllUsers();
    item.forEach((item) {
      Items itemlist = Items.fromMap(item);
      print("Db item ${itemlist.itemname}");
      setState(() {
        _itemlists.add(Items.map(item));
      });
    });
  }

  void deletitem(int id, int index) async {
    await db.delete(id);

    setState(() {
      _itemlists.removeAt(index);
    });
  }

  updateItem(Items itemlist, int index) {
    var alerts = new AlertDialog(
      title: new Text("Update"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _enteredItem,
              autofocus: true,
              decoration: new InputDecoration(
                hintText: "eg: Don't Drink",
                labelText: "New Item",
                icon: new Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            Items updateditem = Items.fromMap({
              "itemname": _enteredItem.text,
              "datecreated": formatteddate(),
              "id": itemlist.id
            });
            deleteolditem(itemlist, index);
            await db.update(updateditem);
            setState(() {
              _showFirst();
           });

            Navigator.pop(context);
          },
          child: new Text("Update"),
        ),
        new FlatButton(onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        )
      ],

    );

    showDialog(context: context,builder: (_){
      return alerts;
    });

  }


  void deleteolditem(Items itemlist, int index) {
    setState(() {
      _itemlists.removeWhere((element) {
        _itemlists[index].itemname == itemlist.itemname;
      });
    });
  }
}
