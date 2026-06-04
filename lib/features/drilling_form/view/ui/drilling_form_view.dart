import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safepedia_drilling_app/features/drilling_form/controller/drilling_form_controller.dart';

class DrillingFormView extends GetView<DrillingFormController> {
  const DrillingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Drilling')),
      body: const Center(
        child: Text('Form Input (Sensor, Foto, dll) akan di sini'),
      ),
    );
  }
}
