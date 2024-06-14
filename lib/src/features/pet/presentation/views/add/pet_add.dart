import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmeals_local/src/core/app/styles/colors/colors.dart';
import 'package:petmeals_local/src/features/pet/data/models/pet_model.dart';
import 'package:petmeals_local/src/features/pet/domain/entities/pet.dart';
import 'package:petmeals_local/src/features/pet/presentation/provider/pet_provider.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/widgets/add_image.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/widgets/borndate.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/widgets/select_sex.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/widgets/select_specie.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/add/widgets/select_sterillized.dart';
import 'package:petmeals_local/src/shared/shared.dart';
import 'package:provider/provider.dart';

class PetAddPage extends StatefulWidget {
  const PetAddPage({
    super.key,
    required this.myPet,
  });
  final PetEntity? myPet;

  @override
  State<PetAddPage> createState() => _PetAddPageState();
}

class _PetAddPageState extends State<PetAddPage> {
  final formKey = GlobalKey<FormState>();

  final controllerName = TextEditingController();
  final controllerDate = TextEditingController();

  late bool update;

  ValueNotifier<XFile?> imagen = ValueNotifier(null);
  ValueNotifier<FileImage?> imageFile = ValueNotifier(null);
  ValueNotifier<int> specie = ValueNotifier(0);
  ValueNotifier<bool> sex = ValueNotifier(false);
  ValueNotifier<DateTime> borndate = ValueNotifier(DateTime.now());
  ValueNotifier<bool> loading = ValueNotifier(false);
  ValueNotifier<bool> sterillized = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    update = widget.myPet != null;

    if (widget.myPet != null) {
      controllerName.text = widget.myPet!.name!;
      controllerDate.text = format().format(widget.myPet!.borndate!);
      borndate.value = widget.myPet!.borndate!;
      specie.value = widget.myPet!.specie!;
      sex.value = widget.myPet!.sex!;
      sterillized.value = widget.myPet!.sterillized!;
    } else {
      if (controllerDate.text.isEmpty) {
        controllerDate.text = format().format(DateTime.now());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          update ? 'Editar mascota' : 'Agregar mascota',
        ),
      ),
      body: SafeArea(
        child: loading.value
            ? Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 64,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            //*  Imagen
                            Align(
                              alignment: Alignment.center,
                              child: AddImage(
                                petUpdate: widget.myPet,
                                imagen: imagen,
                                imageFile: imageFile,
                              ),
                            ),
                            const SizedBox(height: 24),
                            MyTextField(
                              controller: controllerName,
                              textField: 'Nombre',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese nombre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            //*  Fecha de nacimiento
                            BornDate(
                              controllerDate: controllerDate,
                              borndate: borndate,
                            ),
                            const SizedBox(height: 8),
                            //*  Especie
                            SelectSpecie(specie: specie),
                            const SizedBox(height: 8),
                            //* Sexo
                            SelectSex(sex: sex),
                            const SizedBox(height: 8),
                            //* Esterilizado
                            Sterillized(sterillized: sterillized),
                            const SizedBox(height: 20),
                            //Todo:
                            //* Btn Agregar
                            ButtonPrimary(
                              onPressed: () => validateForm(),
                              child: Text(
                                widget.myPet != null
                                    ? 'Guardar'
                                    : 'Agregar mascota',
                              ),
                            ),
                            update
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 18,
                                      bottom: 24,
                                    ),
                                    //* Btn Eliminar
                                    child: ButtonSecondary(
                                      text: 'Eliminar mascota',
                                      color: mandy,
                                      onPressed: () => deletePet(),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void validateForm() {
    final petProvider = context.read<PetProvider>();
    if (formKey.currentState!.validate()) {
      setState(() {
        loading.value = true;
      });

      if (!update) {
        if (imageFile.value == null) {
          snackBar(
            negativeColor,
            'Agregue imagen',
            context,
          );
          setState(() => loading.value = false);
        } else {
          var newPet = PetEntity(
            name: controllerName.text,
            borndate: borndate.value,
            specie: specie.value,
            sex: sex.value,
            sterillized: sterillized.value,
            userId: [petProvider.userId],
          );

          final img = File(imagen.value!.path);
          petProvider.addPet(newPet, img).then(
            (value) {
              if (value) {
                context.go('/home');
              }
            },
          );
        }
      } else {
        var updatePet = PetModel.fromEntity(widget.myPet!).copyWith(
          name: controllerName.text,
          borndate: borndate.value,
          specie: specie.value,
          sex: sex.value,
          sterillized: sterillized.value,
          userId: [petProvider.userId],
        );

        File? img;
        if (imagen.value != null) {
          img = File(imagen.value!.path);
        }
        petProvider.updatePet(updatePet, img).then(
          (value) {
            if (value != null) {
              context.go('/home');
            }
          },
        );
      }
    }
  }

  void deletePet() {
    final petProvider = context.read<PetProvider>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Deseas eliminar tu mascota?'),
          content: const Text(
              'Al eliminar tu mascota perderás los datos de forma permanente.'),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(mandy)),
              onPressed: () {
                setState(() => loading.value = true);
                petProvider.deletePet(widget.myPet!).then(
                      (value) => context.go('/home'),
                    );
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
