import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_rounded,
        color: Colors.yellow,
        size: 32.0,
      ),
      onPressed: () async {
        return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Stages information'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Pressure ulcers are also known as bedsores and decubitus ulcers. They range from closed to open wounds and are classified into a series of four stages based on how deep the wound is:'),
                    SizedBox(height: 14.0),
                    Text('Stage 1 ulcers have not yet broken through the skin.'),
                    SizedBox(height: 10.0),
                    Text('Stage 2 ulcers have a break in the top two layers of skin.'),
                    SizedBox(height: 10.0),
                    Text('Stage 3 ulcers affect the top two layers of skin, as well as fatty tissue.'),
                    SizedBox(height: 10.0),
                    Text('Stage 4 ulcers are deep wounds that may impact muscle, tendons, ligaments, and bone.'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
