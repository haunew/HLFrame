//
//  UIView+HLFrame.h
//  HLFrame
//
//  Created by 刘昊 on 2019/11/22.
//  Copyright © 2019 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HLFrame)
-(UIView *)makeFrame:(NSDictionary *)frame;
@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HLOffest)
-(UIView *)equal:(UIView *)originView offset:(NSDictionary *)offsets;
@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface UIView (calculater)
-(CGFloat)originXFromCentryView;
-(CGFloat)originYFromCentryView;
@end

NS_ASSUME_NONNULL_END
