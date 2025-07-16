// ignore_for_file: non_constant_identifier_names

part of 'lib.dart';

/// The device service controller
final class Service {
  final ServiceSpec spec;
  Service._(this.spec);
  factory Service.build(ServiceSpec spec) => Service._(spec);

  late Map<String, ActionSpec> _actionsMap;

  Future<void> _init() async {
    spec.actionList = <ActionSpec>[];
    _actionsMap = <String, ActionSpec>{};
    final resp = await Http.get(spec.scpdReqURL, ScpdServiceSpec.fromXml);
    spec.actionList.addAll(resp.data.actionList);
    for (var actionSpec in spec.actionList) {
      _actionsMap[actionSpec.name] = actionSpec;
    }
  }

  Future<OUTPUT> invoke<INPUT, OUTPUT>(
    String action,
    INPUT input,
    Map<String, String> Function(INPUT input) inputConvertor,
    OUTPUT Function(Map<String, String>) outputConvertor,
  ) async {
    try {
      final xmlBody = _buildXml(action, inputConvertor(input));
      final resp = await Http.post(
        spec.controlReqURL,
        (xml) => _parseXml(xml, action),
        body: xmlBody,
        headers: _headers(spec, action),
      );
      return Future.value(outputConvertor(resp.data));
    } catch (e) {
      print("❌ Service.invoke error: $e");
      return Future.value(outputConvertor({}));
    }
  }

  Future<Map<String, String>> invokeMap(
      String action, Map<String, String> input) async {
    try {
      return await invoke<Map<String, String>, Map<String, String>>(
        action,
        input,
        (m) => m,
        (m) => m,
      );
    } catch (e) {
      print("❌ invokeMap error for '$action': $e");
      return {};
    }
  }

  String _buildXml(String action, Map<String, String> arguments) {
    final xb = XmlBuilder();
    xb.processing('xml', 'version="1.0"');
    xb.element('s:Envelope', nest: () {
      xb.attribute('xmlns:s', 'http://schemas.xmlsoap.org/soap/envelope/');
      xb.attribute(
          's:encodingStyle', 'http://schemas.xmlsoap.org/soap/encoding/');
      xb.element('s:Body', nest: () {
        xb.element('u:$action', nest: () {
          xb.attribute('xmlns:u', spec.serviceType);
          arguments.forEach((k, v) => xb.element(k, nest: v));
        });
      });
    });
    return xb.buildDocument().toXmlString();
  }

  Map<String, String> _parseXml(XmlDocument xml, String action) {
    final m = <String, String>{};

    final actionSpec = _actionsMap[action];
    if (actionSpec == null) {
      print("⚠️ Action '$action' not found in _actionsMap.");
      return m;
    }

    final outArgs =
        actionSpec.argumentList.where((arg) => arg.direction == 'out');
    for (var arg in outArgs) {
      try {
        final xpathResult = xml.xpathEvaluate(_xpath(action, arg.name));
        final value = xpathResult.string;
        if (value.isNotEmpty) {
          m[arg.name] = value;
        } else {
          print("⚠️ Missing or empty argument '${arg.name}' in response XML.");
        }
      } catch (e) {
        print("⚠️ Error parsing argument '${arg.name}': $e");
      }
    }

    return m;
  }

  static Map<String, String> _headers(ServiceSpec spec, String action) => {
        "Content-Type": "text/xml; charset=utf-8",
        "SOAPAction": '"${spec.serviceType}#$action"'
      };

  static String _xpath(String action, String argument) =>
      '/s:Envelope/s:Body/u:${action}Response/$argument/text()';
}

/// The device service spec.
final class ServiceSpec {
  final String URLBase;
  final String serviceType;
  final String serviceId;
  final String controlURL;
  final String SCPDURL;
  final String eventSubURL;
  final String controlReqURL;
  final String scpdReqURL;

  late List<ActionSpec> actionList;

  ServiceSpec(
    this.URLBase,
    this.serviceType,
    this.serviceId,
    this.controlURL,
    this.SCPDURL,
    this.eventSubURL,
    this.controlReqURL,
    this.scpdReqURL,
  );

  factory ServiceSpec.fromXml(XmlDocument xml, int index) {
    String _safeXpath(String path) {
      try {
        return xml.xpathEvaluate(path).string;
      } catch (_) {
        print("⚠️ Missing or invalid XML path: $path");
        return '';
      }
    }

    final urlBaseFromRoot = _safeXpath('/root/URLBase/text()');
    String fallbackHost = '';

// Extract base URL from injected processing instruction
    final baseNode = xml.children.whereType<XmlProcessing?>().firstWhere(
          (e) => e?.target == 'baseURL',
          orElse: () => null,
        );
    if (baseNode != null && baseNode is XmlProcessing) {
      try {
        final uri = Uri.parse(baseNode.text.trim());
        fallbackHost =
            '${uri.scheme}://${uri.host}:${uri.hasPort ? uri.port : 80}';
      } catch (e) {
        print('⚠️ Failed to parse fallback host: $e');
      }
    }

    final URLBase = urlBaseFromRoot.isNotEmpty ? urlBaseFromRoot : fallbackHost;
    final serviceType = _safeXpath(_xpath(index, 'serviceType'));
    final serviceId = _safeXpath(_xpath(index, 'serviceId'));
    final controlURL = _safeXpath(_xpath(index, 'controlURL'));
    final SCPDURL = _safeXpath(_xpath(index, 'SCPDURL'));
    final eventSubURL = _safeXpath(_xpath(index, 'eventSubURL'));

    final controlReqURL = URLBase +
        ((controlURL.endsWith('/') || controlURL.startsWith('/')) ? '' : '/') +
        controlURL;
    final scpdReqURL = URLBase +
        ((SCPDURL.endsWith('/') || SCPDURL.startsWith('/')) ? '' : '/') +
        SCPDURL;

    return ServiceSpec(
      URLBase,
      serviceType,
      serviceId,
      controlURL,
      SCPDURL,
      eventSubURL,
      controlReqURL,
      scpdReqURL,
    );
  }

  static String _xpath(int index, String name) =>
      '/root/device/serviceList/service[$index]/$name/text()';
}

final class ScpdServiceSpec {
  final List<ActionSpec> actionList;
  const ScpdServiceSpec(this.actionList);

  factory ScpdServiceSpec.fromXml(XmlDocument xml) {
    final nodes = xml.xpath('/scpd/actionList/action');
    final length = nodes.length;

    if (length == 0) {
      print("⚠️ No actions found in actionList");
    }

    return ScpdServiceSpec(
      List.generate(length, (index) => ActionSpec.fromXml(xml, index + 1)),
    );
  }
}
