import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tododapp/screens/addpage.dart';
import 'package:http/http.dart' as http;
class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
State<TodoList> createState()=> TodoListPage();
  }
  class TodoListPage extends State<TodoList>{
  bool isLoad=true;
  List items=[];


  @override
 void initState(){
    super.initState();
    fetchtodo();
  }

  @override
    Widget build(BuildContext context){
    return  Scaffold(
      appBar:AppBar(
           title: Text("ToDo List"),
      ),
      body: Visibility(
        visible: isLoad,
          child : Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchtodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child:Text("No Todo Task",
            style: Theme.of(context).textTheme.headlineMedium,) ,),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(7),
                itemBuilder:(context,index){
                  final item=items[index] as Map;
                  final id=item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child:Text('${index+1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  //update and delete
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value=='edit'){
                        //open edit
                        navigateToEditPAge(item);
                            
                      }
                      else if(value=='delete'){
                        //delete happen or refrehs
                        deleteit(id);
                            
                            
                            
                      }
                            
                    },
                    itemBuilder: (context){
                      return [
                        PopupMenuItem(child: Text('Edit'),
                         value: 'edit',),
                        PopupMenuItem(child: Text('Delete'),
                        value: 'delete',),
                            
                      ];
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddPAge,
          label: Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditPAge(Map item) async{
    final route =MaterialPageRoute(builder: (context)=>AddToDoPage(todo :item),);
await Navigator.push(context, route);
    setState(() {
      isLoad=true;
    });
    fetchtodo();
  }

  Future <void> navigateToAddPAge() async{
 final route =MaterialPageRoute(builder: (context)=>AddToDoPage(),);
  await Navigator.push(context, route);
  setState(() {
    isLoad=true;
  });
  fetchtodo();
  }



  Future<void> deleteit(String id) async {
    print('Deleting item with ID: $id');

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      print('Deletion successful for ID: $id');

      // remove it
      final filter = items.where((element) => element['_id'] != id).toList();
      // print('Before deletion: $items');
      // print('After deletion: $filter');

      setState(() {
        items = filter;
      });
    } else {
      // print('Deletion failed for ID: $id');
      // show error
      showfailureinfo("Deletion Failed");

    }
  }

  Future<void> fetchtodo() async{
    // setState(() {
    //   isLoad=true;
    // });
    final url="https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri= Uri.parse(url);
    final response= await http.get(uri);
   if(response.statusCode==200){
     final json=jsonDecode(response.body) as Map;
     final result=json['items'] as List;

     setState(() {
       items=result;
     });
   }

   setState(() {
     isLoad=false;
   });
  }

  void showsucessinfo(String message){
    final snackBar=SnackBar(content: Text(message,
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showfailureinfo(String message){
    final snackBar=SnackBar(content: Text(message,
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  }
