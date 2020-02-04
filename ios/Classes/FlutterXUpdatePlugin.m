#import "FlutterXUpdatePlugin.h"
#if __has_include(<flutter_xupdate/flutter_xupdate-Swift.h>)
#import <flutter_xupdate/flutter_xupdate-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_xupdate-Swift.h"
#endif

@implementation FlutterXUpdatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterXUpdatePlugin registerWithRegistrar:registrar];
}
@end
