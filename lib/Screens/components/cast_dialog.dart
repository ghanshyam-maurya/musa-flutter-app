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
      curDev =
          found.isNotEmpty ? found.first : null; // auto-select first device
    });
  }

  Future<void> _startCasting() async {
    if (curDev == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a device')),
      );
      return;
    }

    setState(() => isCasting = true);
    final spec = curDev!.spec;

    print('--- Device Info ---');
    print('Friendly Name: ${spec.friendlyName}');
    print('Manufacturer: ${spec.manufacturer}');
    print('Model Name: ${spec.modelName}');
    print('Device Type: ${spec.deviceType}');

    final testUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    //final testUrl = 'https://www.w3schools.com/html/mov_bbb.mp4';

    final metadata = '''
<?xml version="1.0"?>
<DIDL-Lite xmlns:dc="http://purl.org/dc/elements/1.1/"
           xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/"
           xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/">
  <item id="0" parentID="-1" restricted="1">
    <dc:title>Sample MP4</dc:title>
    <upnp:class>object.item.videoItem</upnp:class>
    <res protocolInfo="http-get:*:video/mp4:DLNA.ORG_PN=AVC_MP4_BL_CIF15">$testUrl</res>
  </item>
</DIDL-Lite>
''';

    try {
      print('Trying to cast: $testUrl');

      await curDev!.setAVTransportURI(SetAVTransportURIInput(
        testUrl,
        CurrentURIMetaData: metadata,
      ));

      await curDev!.play(PlayInput(
        InstanceID: '0',
        Speed: '1',
      ));

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
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<Device>(
                            isExpanded: true,
                            value: curDev,
                            hint: Text('Select device'),
                            onChanged: (dev) => setState(() => curDev = dev),
                            items: devices.map((dev) {
                              return DropdownMenuItem<Device>(
                                value: dev,
                                child: Text(
                                  dev.spec.friendlyName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
