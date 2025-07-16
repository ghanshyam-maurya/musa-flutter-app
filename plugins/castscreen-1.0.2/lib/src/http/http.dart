part of 'lib.dart';

abstract final class Http {
  static Future<int> head(String url) async {
    try {
      await http.get(Uri.parse(url));
      return 200;
    } catch (_) {
      return 0;
    }
  }

  static Future<Model<T>> get<T>(String url, Converter<T> converter) async {
    var m = <String, dynamic>{};
    int statusCode = 0;
    try {
      final response = await http.get(Uri.parse(url));
      statusCode = response.statusCode;

      if (statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final xmlDoc = XmlDocument.parse(body);
        xmlDoc.children.insert(
            0,
            XmlProcessing('baseURL',
                url)); // attach source URL as a processing instruction
        m['xml'] = xmlDoc;
      } else {
        m['msg'] = response.body;
      }
    } catch (error) {
      m['msg'] = '$error';
    }

    m['code'] = statusCode;
    return Model.fromMap(m, converter);
  }

  static Future<Model<T>> post<T>(
    String url,
    Converter<T> converter, {
    String? body,
    Map<String, String>? headers,
  }) async {
    var m = <String, dynamic>{};
    int statusCode = 0;

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      statusCode = response.statusCode;

      if (statusCode == 200 && response.body.isNotEmpty) {
        final xml = utf8.decode(response.bodyBytes);
        m['xml'] = XmlDocument.parse(xml);
      } else {
        m['msg'] = response.body;
      }
    } catch (error) {
      print("❌ Http.post error for $url: $error");
      m['msg'] = '$error';
    }

    m['code'] = statusCode;
    return Model.fromMap(m, converter);
  }
}

class Model<T> {
  final int code;
  final String msg;
  final T data;
  const Model(this.code, this.msg, this.data);

  factory Model.fromMap(Map<String, dynamic> m, Converter<T> converter) {
    return Model(
      m['code'] as int? ?? 0,
      m['msg'] as String? ?? "ok",
      converter(m['xml'] ?? XmlDocument()),
    );
  }

  @override
  String toString() => '{code: $code, msg: $msg, data: $data}';
}

typedef Converter<T> = T Function(XmlDocument xml);
