import 'package:flutter/material.dart';
import 'package:castscreen/castscreen.dart';

class CastDialog extends StatefulWidget {
  final String url;
  final String title;

  const CastDialog({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  _CastDialogState createState() => _CastDialogState();
}

class _CastDialogState extends State<CastDialog> {
  bool isCasting = false;
  List<Device> devices = [];
  Device? curDev;

  @override
  void initState() {
    super.initState();
    _discoverDevices();
  }

  Future<void> _discoverDevices() async {
    final found =
        await CastScreen.discoverDevice(timeout: Duration(seconds: 3));
    setState(() {
      devices = found;
      curDev = null;
    });
  }

  Future<void> _startCasting() async {
    if (curDev == null) return;
    setState(() => isCasting = true);

    final spec = curDev!.spec;

    print('--- Device Info ---');
    print('Friendly Name: ${spec.friendlyName}');
    print('Manufacturer: ${spec.manufacturer}');
    print('Model Name: ${spec.modelName}');
    print('Device Type: ${spec.deviceType}');

    // if (widget.url == null || widget.url!.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Media URL is missing or invalid')),
    //   );
    //   return;
    // }

    // try {
    //   print('Trying to cast: ${widget.url}');
    //   await curDev!.setAVTransportURI(SetAVTransportURIInput(widget.url!));
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Casting started')),
    //   );
    // } catch (e, stack) {
    //   print('Casting error: $e');
    //   print(stack);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to cast: $e')),
    //   );
    // } finally {
    //   setState(() => isCasting = false);
    //   Navigator.pop(context);
    // }

    // Use a static test video URL for casting
    final testUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    if (testUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Media URL is missing or invalid')),
      );
      return;
    }

    try {
      print('Trying to cast: $testUrl');
      await curDev!.setAVTransportURI(SetAVTransportURIInput(testUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Casting started')),
      );
    } catch (e, stack) {
      print('Casting error: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cast: $e')),
      );
    } finally {
      setState(() => isCasting = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: isCasting
          ? Center(child: CircularProgressIndicator())
          : devices.isEmpty
              ? Text('No DLNA/UPnP devices found.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<Device>(
                      value: curDev,
                      hint: Text('Select device'),
                      onChanged: (dev) => setState(() => curDev = dev),
                      items: devices.map((dev) {
                        return DropdownMenuItem<Device>(
                          value: dev,
                          child: Text(dev.spec.friendlyName),
                        );
                      }).toList(),
                    ),
                  ],
                ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        if (!isCasting)
          TextButton(
            onPressed: _startCasting,
            child: Text('Cast'),
          ),
      ],
    );
  }
}
