//
//  ViewController.m
//  HLFrameExample
//
//  Created by 刘昊 on 2019/11/24.
//  Copyright © 2019 刘昊. All rights reserved.
//

#import "ViewController.h"
#import "HLFrame.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     基本方法
     ***********************/
    UIView *baseFunctionView = [[UIView alloc] init];
    baseFunctionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:baseFunctionView];
    [baseFunctionView makeFrame:@{
                                  Width:FloatValue(self.view.bounds.size.width - 24),
                                  Height:@100,
                                  Left:IntegerValue(12),
                                  Top:FloatValue(10)
                                  }];
    
    UILabel *baseFunctionView_lable = [[UILabel alloc] init];
    baseFunctionView_lable.backgroundColor = [UIColor yellowColor];
    [baseFunctionView addSubview:baseFunctionView_lable];
    [baseFunctionView_lable makeFrame:@{
                                        Width:@50.5,
                                        Height:@50,
                                        Right:@-50.5,
                                        Bottom:@-50
                                        }];
    /*
     偏移
     ***********************/
    UIView *offsetFunctionView = [[UIView alloc] init];
    offsetFunctionView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:offsetFunctionView];
    [offsetFunctionView equal:baseFunctionView offset:@{
                                                        Width:BoolValue(NO),
                                                        Height:@0,
                                                        Left : @0,
                                                        Top : @110
                                                        }];
    
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
    /*
     锚点
     ***********************/
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
    
}


@end
