import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:shapeyouadmin_web/services/sidebar.dart';
import 'package:shapeyouadmin_web/widgets/deliveryboy/approved_boys.dart';
import 'package:shapeyouadmin_web/widgets/deliveryboy/create_deliveryboy.dart';
import 'package:shapeyouadmin_web/widgets/deliveryboy/new_boys.dart';

class DeliveryBoyScreen extends StatelessWidget {
  static const String id = 'deliveryboy-screen';
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return DefaultTabController(
      length: 2,
      child: AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Grocery App Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        sideBar: _sideBar.sideBarMenus(context, DeliveryBoyScreen.id),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Boys',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                Text('Create new Delivery Boys and Manage all Delivery Boys'),
                Divider(
                  thickness: 5,
                ),
                CreateNewBoyWidget(),
                Divider(
                  thickness: 5,
                ),
                //list of delivery boys
                TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'NEW',),
                    Tab(text: 'APPROVED',),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        NewBoys(),
                        ApprovedBoys(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
