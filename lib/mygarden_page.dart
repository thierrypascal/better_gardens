import 'package:biodiversity/drawer.dart';
import 'package:biodiversity/garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyGarden extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyGardenState();
  }

}

class _MyGardenState extends State<MyGarden>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Garden")
      ),
      drawer: MyDrawer(),
      body: _myGardenSteamBuilder(),
    );
  }
}

Widget _myGardenSteamBuilder(){
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('gardens').snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData)  return const Center(child: Text("Hurti es momentli..."));

      return _buildBody(context, snapshot.data.documents);
    },
  );
}

Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot){
  final garden = Garden.fromSnapshot(snapshot.first);
  return Center(
      child:Text("Name: ${garden.name}\nStreet: ${garden.street}\nCity: ${garden.city}")
  );
}