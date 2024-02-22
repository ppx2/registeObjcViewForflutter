## 项目结构：flutter和ios原生混合项目
###### tips：这种方式开销大能不用就不用 

#### 一个简化注册ios插件的类 （flutter加载ios原生view）只需继承PXFlutterPluginView，与flutter通信直接使用提供好的channel即可

- ios使用： LoginView : PXFlutterPluginView

1.注册插件 可以放在appdelegate函数中或者其他函数中


```
[PXFlutterPluginRegister registeWithClass:[LoginView class]];
```

2.自定义类必须实现PXFlutterPluginViewDelegate
```
#import "LoginView.h"

@interface LoginView ()<PXFlutterPluginViewDelegate>
@end

@implementation LoginView

- (UIView *)contentView
{
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.lightGrayColor;
    
    UIButton * redview = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width-40, 50)];
    redview.layer.masksToBounds = YES;
    redview.layer.cornerRadius = 25;
    [redview setTitle:@"ios原生登录(有事件)-loginView" forState:UIControlStateNormal];
    redview.backgroundColor = [UIColor redColor];
    [bgView addSubview:redview];
    
    //添加交互事件
    [redview addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    return bgView;
}

- (void)loginAction
{
    [self.methodChannel invokeMethod:@"loginActionInvoked" arguments:nil];
}

@end
```

- flutter使用：（建议ios原生处理好逻辑只需回传一个信号到flutter即可）
```
class _HomePageState extends State<HomePage> {
  final MethodChannel channel = MethodChannel('LoginView_methodChannel');

  Future<dynamic> _loginAction(MethodCall call) async {
    print('flutter收到ios原生点击了登录');
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              child: UiKitView(
                viewType: 'LoginView_viewId',
                onPlatformViewCreated: (index) {
                  channel.setMethodCallHandler(_loginAction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
