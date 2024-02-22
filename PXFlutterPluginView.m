//
//  PXFlutterPluginView.m
//  Runner
//
//  Created by zuluoji on 2024/2/20.
//

#import "PXFlutterPluginView.h"

@implementation PXFlutterPluginRegister

+ (void)registeWithClass:(Class)objcClass
{
    NSString *className = NSStringFromClass(objcClass);
    NSString *pluginKey = [NSString stringWithFormat:@"%@_pluginKey",className];
    NSString *viewId = [NSString stringWithFormat:@"%@_viewId",className];
    FlutterAppDelegate * appDelegate  = (FlutterAppDelegate *)[UIApplication sharedApplication].delegate;
    NSObject<FlutterPluginRegistrar>* plugin = [appDelegate registrarForPlugin:pluginKey];
    NSObject<FlutterPlatformViewFactory> *factory =[[NSClassFromString(@"PXFlutterPluginViewFactory") alloc] init];
    [factory setValue:plugin.messenger forKey:@"_binaryMessenger"];
    [factory setValue:className forKey:@"_className"];
    [plugin registerViewFactory:factory withId:viewId];
}

@end


@interface PXFlutterPluginView ()<FlutterPlatformView>

@property (readonly, nonatomic, strong)NSString *frameString;
@property (nonatomic, strong)NSObject<FlutterBinaryMessenger> * binaryMessenger;
@property (nonatomic, weak)NSObject<PXFlutterPluginViewDelegate>* delegate;

@end

@implementation PXFlutterPluginView

- (UIView *)view {
    if ([self.delegate respondsToSelector:@selector(contentView)]) {
        UIView *view =self.delegate.contentView;
        view.frame = CGRectFromString(self.frameString);
        return view;
    }
    NSLog(@"子类必须实现 - contentView协议");
    return  nil;
}

@end


@interface PXFlutterPluginViewFactory : NSObject<FlutterPlatformViewFactory>

@property (nonatomic, strong)NSString * className;
@property (nonatomic, strong)NSObject<FlutterBinaryMessenger> * binaryMessenger;

@end

@implementation PXFlutterPluginViewFactory


- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    PXFlutterPluginView<PXFlutterPluginViewDelegate> *view =[[NSClassFromString(self.className) alloc] init];
    NSString *methodChannel = [NSString stringWithFormat:@"%@_methodChannel",self.className];
    FlutterMethodChannel * channel = [[FlutterMethodChannel alloc] initWithName:methodChannel binaryMessenger:self.binaryMessenger codec:[FlutterStandardMethodCodec sharedInstance]];
    [view setValue:view forKey:@"_delegate"];
    [view setValue:self.binaryMessenger forKey:@"_binaryMessenger"];
    [view setValue:channel forKey:@"_methodChannel"];
    [view setValue:NSStringFromCGRect(frame) forKey:@"_frameString"];
    
    NSString *pluginKey = [NSString stringWithFormat:@"%@_pluginKey",self.className];
    NSString *viewID = [NSString stringWithFormat:@"%@_viewId",self.className];
    NSDictionary *info= @{
        @"flutter-plugin-key": pluginKey,
        @"flutter-plugin-viewId":viewID,
        @"flutter-plugin-method-channel":methodChannel,
        @"flutter-plugin-class":self.className
    };
    NSLog(@"flutter引擎注册的基本信息:%@", info);
    [view setValue:info forKey:@"_configInfo"];
    
    return view;
}

@end
