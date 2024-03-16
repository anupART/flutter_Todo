import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToDoPage extends StatefulWidget {
  final  Map? todo;

 const AddToDoPage({
    super.key,
   this.todo,
});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();

  bool isEdit=false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      final title = todo?['title'];
      final description = todo?['description']; // Corrected typo
      titleController.text = title; // Use .text to set text for TextEditingController
      descriptionController.text = description; // Use .text to set text for TextEditingController
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
            isEdit? 'Edit Todo':
            "Add Todo",),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [

          TextField(
            controller: titleController,
            decoration:InputDecoration(
              hintText: 'Title'),
            ) ,
    TextField(
      controller: descriptionController,
    decoration: InputDecoration(hintText: 'Description'),
    keyboardType: TextInputType.multiline,
    minLines: 3,
    maxLines: 10,
    ),
 SizedBox(height: 20,),
 ElevatedButton(onPressed: isEdit? updateData : submitData,
     child: Padding(
       padding: const EdgeInsets.all(15.0),
       child: Text(
       isEdit? 'Update' :'Submit',),
     ))
        ],
      ),
    );
  }
Future<void>  updateData() async{
    final todo=widget.todo;
    if(todo==null){
      print("Add something");
      return;
    }
    final id=todo['_id'];
    // final isCompleted=todo['is_completed'];
  final title=titleController.text;
  final description=descriptionController.text;
  final body={

    "title": title,
    "description": description,
    "is_completed": false,

  };
  //submit update data  to server
  final url='https://api.nstack.in/v1/todos/$id';
  final uri=Uri.parse(url);
  final response = await http.put(
      uri,
      body: jsonEncode(body), // Encode body as JSON
  headers: {'Content-Type': 'application/json'},
  );
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
    if (response.statusCode == 200) {
      titleController.text='';
      descriptionController.text='' ;

      showsucessinfo('Updation Successful '); // Corrected typo
    } else {
      showfailureinfo(" Updation Failed"); // Added response body for debugging
    }
}

Future<void> submitData() async{
  //get the data fom form
  final title=titleController.text;
  final description=descriptionController.text;
  final body={

      "title": title,
      "description": description,
      "is_completed": false

  };
  //submit the data to server
  final url='https://api.nstack.in/v1/todos';
  final uri=Uri.parse(url);
  final response = await http.post(
    uri,
    body: jsonEncode(body), // Encode body as JSON
    headers: {'Content-Type': 'application/json'},
  );



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

  //shown sucess o fail message based on status
  if (response.statusCode == 201) {
    titleController.text='';
    descriptionController.text='' ;

    showsucessinfo('Creation Successful'); // Corrected typo
  } else {
    showfailureinfo("Failed: ${response.body}"); // Added response body for debugging
  }
}
}
