import 'dart:io';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:image/image.dart';
import 'package:flutter_launcher_icons/constants.dart';

import 'constants.dart';

/// File to handle the creation of icons for Web platform
class WebIconTemplate {
  WebIconTemplate({this.size, this.name});
  final String name;
  final int size;
}

List<WebIconTemplate> webFavicons = <WebIconTemplate>[
  WebIconTemplate(name: '', size: 48),
  // WebIconTemplate(name: '-16x16', size: 16),
  // WebIconTemplate(name: '-32x32', size: 32),
];

List<WebIconTemplate> webIcons = <WebIconTemplate>[
  WebIconTemplate(name: '-192', size: 192),
  WebIconTemplate(name: '-512', size: 512),
];

void createIcons(Map<String, dynamic> config) {
  final String filePath = config['image_path_web'] ?? config['image_path'];
  final Image image = decodeImage(File(filePath).readAsBytesSync());

  print('Adding Web icons');
  //save favicon, always overwrite
  for (WebIconTemplate template in webFavicons) {
    saveNewFavicons(template, image);
  }
  // If the Web configuration is a string then the user has specified a new icon to be created
  // and for the old icon file to be kept
  final dynamic webConfig = config['web'];
  for (WebIconTemplate template in webIcons) {
    saveIcons(template, image, webConfig is String ? webConfig : webDefaultIconName);
  }
}

/// Note: Do not change interpolation unless you end up with better results (see issue for result when using cubic
/// interpolation)
/// https://github.com/fluttercommunity/flutter_launcher_icons/issues/101#issuecomment-495528733
void saveNewFavicons(WebIconTemplate template, Image image) {
  final Image newFile = createResizedImage(template.size, image);
  File(webRootFolder + 'favicon' + template.name + '.png')
      .create(recursive: true)
      .then((File file) {
    file.writeAsBytesSync(encodePng(newFile));
  });
}

void saveIcons(WebIconTemplate template, Image image, String iconName) {
  final Image newFile = createResizedImage(template.size, image);

  File(webIconsFolder + iconName + template.name + '.png')
      .create(recursive: true)
      .then((File file) {
    file.writeAsBytesSync(encodePng(newFile));
  });
}
