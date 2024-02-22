//
//  PXFlutterPluginView.h
//  Runner
//
//  Created by zuluoji on 2024/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - 插件注册辅助
@interface PXFlutterPluginRegister : NSObject

+ (void)registeWithClass:(Class)objcClass;

@end

// MARK: - 插件视图代理
@protocol PXFlutterPluginViewDelegate <NSObject>

@required
- (UIView *)contentView;

@end

// MARK: - 插件基类
@class PXFlutterPluginViewFactory;
@interface PXFlutterPluginView : NSObject<FlutterPlatformView>

//基本配置信息
@property (readonly,nonatomic, strong)NSDictionary *configInfo;
//插件交互
@property (readonly,nonatomic, strong)FlutterMethodChannel *methodChannel;

@end

NS_ASSUME_NONNULL_END
