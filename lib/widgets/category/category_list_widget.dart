import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shapeyouadmin_web/services/firebase_services.dart';
import 'category_card_widget.dart';

class CategoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseServices _services = FirebaseServices();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.category.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          try{
            if(snapshot.hasError){
              return Text('Something went wrong..');
            }
          }catch(e,s){
            print('Error is: $e');
            print('Stack Trace is: $s');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return Wrap(
            direction: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document){
              return CategoryCard(document);
            }).toList(),
          );
        },
      ),
    );
  }
}
