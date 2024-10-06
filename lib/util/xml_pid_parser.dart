import 'package:xml/xml.dart' as xml;

class XmlPidParser {
  static Map<String, String> parse(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);

    final resultMap = <String, String>{};

    // Get the <Data> element
    final dataElement = document.findAllElements('Data').firstOrNull;
    final dataText = dataElement?.text.trim() ?? '';
    final dataType = dataElement?.getAttribute('type') ?? '';

    resultMap['Data'] = dataText;
    resultMap['DataType'] = dataType;

    // Get the <Resp> element
    final respElement = document.findAllElements('Resp').firstOrNull;
    resultMap['errCode'] = respElement?.getAttribute('errCode') ?? '';
    resultMap['errInfo'] = respElement?.getAttribute('errInfo') ?? '';
    resultMap['fCount'] = respElement?.getAttribute('fCount') ?? '';
    resultMap['fType'] = respElement?.getAttribute('fType') ?? '';
    resultMap['iCount'] = respElement?.getAttribute('iCount') ?? '';
    resultMap['iType'] = respElement?.getAttribute('iType') ?? '';
    resultMap['nmPoints'] = respElement?.getAttribute('nmPoints') ?? '';
    resultMap['pCount'] = respElement?.getAttribute('pCount') ?? '';
    resultMap['pType'] = respElement?.getAttribute('pType') ?? '';
    resultMap['qScore'] = respElement?.getAttribute('qScore') ?? '';

    // Get the <Hmac> element
    final hmacElement = document.findAllElements('Hmac').firstOrNull;
    resultMap['Hmac'] = hmacElement?.text.trim() ?? '';

    // Get the <Skey> element
    final skeyElement = document.findAllElements('Skey').firstOrNull;
    resultMap['Skey'] = skeyElement?.text.trim() ?? '';
    resultMap['SkeyCI'] = skeyElement?.getAttribute('ci') ?? '';

    // Get the <DeviceInfo> element
    final deviceInfoElement = document.findAllElements('DeviceInfo').firstOrNull;
    resultMap['DeviceInfoDC'] = deviceInfoElement?.getAttribute('dc') ?? '';
    resultMap['DeviceInfoDpId'] = deviceInfoElement?.getAttribute('dpId') ?? '';
    resultMap['DeviceInfoMC'] = deviceInfoElement?.getAttribute('mc') ?? '';
    resultMap['DeviceInfoMI'] = deviceInfoElement?.getAttribute('mi') ?? '';
    resultMap['DeviceInfoRdsVer'] = deviceInfoElement?.getAttribute('rdsVer') ?? '';
    resultMap['DeviceInfoRdsId'] = deviceInfoElement?.getAttribute('rdsId') ?? '';

    // Get the <additional_info> element
    final additionalInfoElement = deviceInfoElement?.findElements('additional_info').firstOrNull;

    // Extract values from <additional_info> and add them to the HashMap
    resultMap['srno'] = _getParamValue(additionalInfoElement, 'srno');
    resultMap['sysid'] = _getParamValue(additionalInfoElement, 'sysid');
    resultMap['ts'] = _getParamValue(additionalInfoElement, 'ts');

    return resultMap;
  }

  static String _getParamValue(xml.XmlElement? additionalInfoElement, String paramName) {
    if (additionalInfoElement == null) return '';
    final paramElement = additionalInfoElement.findElements('Param')
        .firstWhere(
          (node) => node.getAttribute('name') == paramName,
      orElse: () => xml.XmlElement(xml.XmlName('Param')),
    );
    return paramElement.getAttribute('value') ?? '';
  }
}
