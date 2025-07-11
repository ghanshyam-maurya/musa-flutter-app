import 'package:flutter/material.dart';
import 'cast_media_dialog.dart';

class MediaCastButton extends StatelessWidget {
  final List<dynamic> fileList;

  const MediaCastButton({
    Key? key,
    required this.fileList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cast),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                final file = fileList[index];
                final url = file is Map ? file['file_link'] : file.fileLink;
                final name = url.toString().split('/').last;

                return ListTile(
                  title: Text(name),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => CastMediaDialog(
                        url: url.toString(),
                        title: name,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
