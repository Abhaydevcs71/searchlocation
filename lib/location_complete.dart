import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class LocationAutoCompletePage extends StatefulWidget {
  const LocationAutoCompletePage({super.key});

  @override
  State<LocationAutoCompletePage> createState() =>
      _LocationAutoCompletePageState();
}

class _LocationAutoCompletePageState extends State<LocationAutoCompletePage> {
  final searchController = TextEditingController();
  final String token = '1234567890';
  var uuid = Uuid();
  List<dynamic> listofLocation = [];
  @override
  void initState() {
    
    super.initState();
    searchController.addListener(() {
      _onChange();
    },);
    
  }

  _onChange(){
    placeSuggestion(searchController.text);
  }

 void placeSuggestion(String input) async{
 const String apiKey = "AIzaSyAUwzSrtSrBENvX_j0DuU-9UTA8YsNUjWk";
 try{
  String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  String request = '$baseUrl?input=$input&key=$apiKey&sessiontoken=$token';
  var response = await http.get(Uri.parse(request));
  var data = json.decode(response.body);
  if(kDebugMode){
    print(data);
  }
  if(response.statusCode == 200){
    setState(() {
      listofLocation = json.decode(response.body)['predictions'];
    });
  }
  else{}
  throw Exception( "fail to load");
 }catch(e){
  print(e.toString());
 }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent,),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Search Place..",
              ),
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  
                });
              },
            ),
            Visibility(
              visible: searchController.text.isEmpty ? false : true,
              child: Expanded(child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listofLocation.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Text(listofLocation[index]["description"]),
                  );
                },
              )),
            ),
            Visibility(
              visible: searchController.text.isEmpty ? true :false,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(onPressed: () {
                  
                }, child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location,
                    color: Colors.green,
                    ),
                    SizedBox(width: 10,),
                    Text("My Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green
                    ),
                    )
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
