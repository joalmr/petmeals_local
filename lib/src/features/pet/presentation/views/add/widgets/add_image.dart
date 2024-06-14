import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmeals_local/src/core/app/styles/colors/colors.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';

class AddImage extends StatefulWidget {
  const AddImage({
    super.key,
    required this.petUpdate,
    required this.imagen,
    required this.imageFile,
  });
  final PetEntity? petUpdate;
  final ValueNotifier<XFile?> imagen;
  final ValueNotifier<FileImage?> imageFile;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                children: [
                  SimpleDialogOption(
                    onPressed: takePicture,
                    child: const Text('Tomar foto'),
                  ),
                  SimpleDialogOption(
                    onPressed: selectPicture,
                    child: const Text('Seleccionar foto'),
                  ),
                ],
              );
            });
      },
      child: Stack(
        children: [
          Container(
            height: 240,
            width: 240,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: kPrimaryColor),
              color: kContrastColor,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: widget.imageFile.value != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image(
                        image: widget.imageFile.value!, //?
                        fit: BoxFit.cover,
                      ),
                    )
                  : widget.petUpdate != null
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image(
                            image: FileImage(File(widget.petUpdate!.photo!)),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 64,
                            color: kPrimaryColor,
                          ),
                        ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: kPrimaryColor,
                ),
                padding: const EdgeInsets.all(10),
                child: const Center(
                  child: Icon(
                    Icons.edit_rounded,
                    size: 32,
                    color: kTextColorContrast,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePicture() async {
    context.pop();
    widget.imagen.value = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (widget.imageFile.value == null) return;
    setState(() {
      widget.imageFile.value = FileImage(File(widget.imagen.value!.path));
    });
  }

  void selectPicture() async {
    context.pop();
    widget.imagen.value = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (widget.imagen.value == null) return;
    setState(() {
      widget.imageFile.value = FileImage(File(widget.imagen.value!.path));
    });
  }
}
