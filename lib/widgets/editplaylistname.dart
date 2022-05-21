import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../db/box.dart';

// ignore: must_be_immutable
class EditPlaylist extends StatelessWidget {
  EditPlaylist({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  //final _box = Boxes.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
  final Controller _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: Border.all(
        width: 1,
        color: Colors.white,
      ),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              top: 20,
            ),
            child: Text(
              "Edit your playlist name.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Form(
              key: formkey,
              child: TextFormField(
                initialValue: playlistName,
                cursorHeight: 25,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                onChanged: (value) {
                  _title = value;
                },
                validator: (value) {
                  return _controller.editPlaylistName(value);
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    top: 5,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    top: 5,
                  ),
                  child: TextButton(
                    onPressed: () {
                      _controller.deletePlaylist(formkey,_title!,playlistName);
                    },
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  
}
