
# HLFrame 
![](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![](https://img.shields.io/badge/language-OC-orange.svg)
[![](https://img.shields.io/badge/email-haunew@yeah.net-blue.svg)](https://twitter.com/EyreFree777)

Frame布局方法扩展

### 基本布局
```objective-c
    UIView *baseFunctionView = [[UIView alloc] init];
    baseFunctionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:baseFunctionView];
    
    
    [baseFunctionView makeFrame:@{
                                  Width:FloatValue(self.view.bounds.size.width - 24),
                                  Height:@100,
                                  Left:IntegerValue(12),
                                  Top:FloatValue(10)
                                  }];
```
`Width`:对应Frame的width

`Height`:对应Frame的height

`Left`:对应Frame的x，右移为正，左移为负

`Top`:对应Frame的y，下移为正，上移为负

```objective-c
    UILabel *baseFunctionView_lable = [[UILabel alloc] init];
    baseFunctionView_lable.backgroundColor = [UIColor yellowColor];
    [baseFunctionView addSubview:baseFunctionView_lable];
    [baseFunctionView_lable makeFrame:@{
                                        Width:@50.5,
                                        Height:@50,
                                        Right:@-50.5,
                                        Bottom:@-50
                                        }];
```
`Bottom`：距离父视图底边的偏移

`Right`:距离父视图右边的偏移

默认为bounds的(0,0)点作为锚点，即该视图`左上角`的这个点相对父视图Left、Right、Top、Bottom的边偏移

注意：

1. 使用Right和Bottom时要确定该视图添加到了界面
2. 同时使用Left和Right，Right会失效
3. 同时使用Top和Bottom，Bottom会失效 


### 偏移
```objective-c
    UIView *offsetFunctionView = [[UIView alloc] init];
    offsetFunctionView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:offsetFunctionView];
    [offsetFunctionView equal:baseFunctionView offset:@{
                                                        Width:BoolValue(NO),
                                                        Height:@0,
                                                        Left : @0,
                                                        Top : @110
                                                        }];
```
`equal`:后面代入参数为基视图

`Width`:比基视图的宽大多少，正数加，负数减

`Height`:比基视图的高大多少，正数加，负数减

`Left`:距离基视图的左边偏移

`Right`:距离基视图的右边偏移

`Top`:距离基视图的顶部偏移

`Bottom`:距离基视图的底部偏移

默认为bounds的(0,0)点作为锚点，即该视图`左上角`的这个点相对基视图Left、Right、Top、Bottom的边偏移

注意：
1. 同时使用Left和Right，Right会失效
2. 同时使用Top和Bottom，Bottom会失效
3. 确定基视图和该视图在同一控制器下，确定基视图有Frame

```objective-c
    UIImageView *offsetFunctionView_img = [[UIImageView alloc] init];
    [offsetFunctionView addSubview:offsetFunctionView_img];
    offsetFunctionView_img.backgroundColor = [UIColor redColor];
    [offsetFunctionView_img makeFrame:@{
                                        Width:@30,
                                        Height:@50,
                                        Offset:@[baseFunctionView_lable,@{
                                                     Right:@-50.5,
                                                     Bottom:@10
                                                     }]
                                        }];
```

`Offset`:@[基视图,@{偏移属性}]

注意：
1. `makeFrame`方法Offset属性优先级最低，即字典中的Frame设置了Left、Right、Top、Bottom，Offset中的对应属性会失效
2. `makeFrame:`方法不能添加多个Offset，添加多个Offset使用`equal:offset:`方法，Example:

```objective-c
    UIButton *offsetFunctionView_button = [UIButton buttonWithType:UIButtonTypeSystem];
    offsetFunctionView_button.backgroundColor = [UIColor greenColor];
    [offsetFunctionView addSubview:offsetFunctionView_button];
    [offsetFunctionView_button makeFrame:@{
                                           Width:@20,
                                           Offset:@[offsetFunctionView_img,@{
                                                        Bottom:@20
                                                        }
                                                    ]
                                           }];
    [offsetFunctionView_button equal:baseFunctionView_lable offset:@{
                                                                     Height:@-30,
                                                                     Left:@0
                                                                     }];
```         
### 锚点
```objective-c
    UIView *anchorFunctionView = [[UIView alloc] init];
    anchorFunctionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:anchorFunctionView];
    [anchorFunctionView makeFrame:@{
                                    Bottom:@0,
                                    Offset:@[offsetFunctionView,@{
                                                 Height:@0,
                                                 Width:@0,
                                                 Right:@0
                                                 }],
                                    Anchor:@{
                                            Bottom:@0,
                                            Right:@0
                                            }
                                    }];
```
`Anchor`:添加锚点

`Top`:设置垂直方向的锚点在bounds的顶部，锚点下移为正，上移为负

`Bottom`:设置垂直方向的锚点锚点在bounds的底部，锚点下移为正，上移为负

`Left`:设置水平方向的锚点在bounds的左边，锚点右移为正，左移为负

`Right`:设置水平方向的锚点在bounds的右边，锚点右移为正，左移为负

注意：
1. 同时使用Left和Right，Right会失效
2. 同时使用Top和Bottom，Bottom会失效
3. 只对当前`makeFrame:`方法有效

### Example图片
<p align="center" style="background-color: #e1e1e1">
  <img src="https://github.com/haunew/HLFrame/blob/master/img/HLFrame_Example.png?raw=true" alt="HLFrame" title="HLFrame">
</p>
## 说明
* 通过字典来设置相关Frame，类比css设置样式
* 只能实现Frame相关的布局，是基于iOS-Frame布局的扩展
* 与约束混合使用需要Layout一下后使用或者在主线程刷新Frame
* Left、Right、Top、Bottom属性仅仅只是修改`CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)`中对应的值

