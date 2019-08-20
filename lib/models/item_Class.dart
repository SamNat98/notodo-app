import 'package:flutter/material.dart';


class Items {


  String _itemname;
  String _DataCreated;
  int _id;

  String get itemname=> _itemname;
  String get DataCreated=>_DataCreated;
  int get id => _id;

  Items(this._itemname,this._DataCreated);

  Items.map(dynamic obj){

    this._itemname=obj["itemname"];
    this._DataCreated=obj["datecreated"];
    this._id=obj["id"];
  }

  Map<String,dynamic> toMap(){

    var map= new Map<String,dynamic>();
    map["itemname"]=_itemname;
    map["datecreated"]=_DataCreated;
    if(_id!=null){
      map["id"]=_id;
    }
     return map;
  }

  Items.fromMap(Map<String,dynamic> map){

    this._itemname=map["itemname"];
    this._DataCreated=map["datecreated"];
    this._id=map["id"];

  }
}
