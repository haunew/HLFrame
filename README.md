# HLFrame
Frame布局方法扩展

### 基本布局
```oc
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

`Left`:对应Frame的x，正数右移，负数左移

`Top`:对应Frame的y，正数下移，负数上移

```oc
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
`Bottom`：距离底部的偏移

`Right`:距离右边的偏移

默认为bounds的(0,0)点作为锚点，即视图`左上角`对应父视图Left、Right、Top、Bottom的偏移

注意：

1. 使用Right和Bottom要确定该视图添加到了父视图
2. 使用Left和Right，Right会失效
3. 使用Top和Bottom，Bottom会失效

###偏移
```
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
`equal`:后面为基视图

`Width`:比基视图的宽大多少，正数加，负数减

`Height`:比基视图的高大多少，正数加，负数减

`Left`:距离基视图的左边偏移

`Right`:距离基视图的右边偏移

`Top`:距离基视图的顶部偏移

`Bottom`:距离基视图的底部偏移

默认为bounds的(0,0)点作为锚点，即视图`左上角`对应基视图Left、Right、Top、Bottom的偏移

注意：
1. 使用Left和Right，Right会失效
2. 使用Top和Bottom，Bottom会失效
3. 确定基视图在同一控制器下，有Frame

```oc
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
1. Frame的优先级大于Offset，即字典中的Frame设置了Left、Right、Top、Bottom，Offset中的对应属性会失效
2. `makeFrame`方法不能添加多个Offset，添加多个Offset使用`equal:offset:`方法，Example:

```oc
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