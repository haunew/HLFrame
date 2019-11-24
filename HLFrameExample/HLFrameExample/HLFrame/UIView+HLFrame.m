//
//  UIView+HLFrame.m
//  HLFrame
//
//  Created by 刘昊 on 2019/11/22.
//  Copyright © 2019 刘昊. All rights reserved.
//

#import "UIView+HLFrame.h"
#import "Constant.h"

@interface  UIView (verify)
-(BOOL)verifySuperView;
+(BOOL)verifyNSDictionary:(id)object;
+(BOOL)verifyNumber:(id)object;
+(BOOL)verifyOffset:(NSString *)key offsetValue:(id)value;
@end

@interface UIView (Tool)
-(NSArray *)formatStyle:(NSDictionary *)frame;
@end

@implementation UIView (HLFrame)

-(UIView *)makeFrame:(NSDictionary *)frame{
    if([UIView verifyNSDictionary:frame]){
        NSArray *formatStyle = [self formatStyle:frame];
        NSArray *styles = formatStyle.firstObject;
        NSArray *values = formatStyle.lastObject;
        for (NSInteger i = 0; i < styles.count; ++i) {
            NSString *style = [styles objectAtIndex:i];
            id value = [values objectAtIndex:i];
            NSString *method = [NSString stringWithFormat:@"make%@:",style];
            SEL selector = NSSelectorFromString(method);
            if(![self respondsToSelector:selector]){
                continue;
            }
            IMP imp = [self methodForSelector:selector];
            if([UIView verifyNumber:value]){
                UIView * (*func)(id, SEL, CGFloat) = (void *)imp;
                func(self, selector, [value floatValue]);
            }else if ([UIView verifyOffset:style offsetValue:value]){
                UIView * (*func)(id, SEL, NSArray*) = (void *)imp;
                func(self, selector, value);
            }
            
        }
    }
    return self;
}
-(UIView *)makeWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
    return self;
}

-(UIView *)makeHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
    return self;
}

-(UIView *)makeLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
    return self;
}

-(UIView *)makeTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
    return self;
}

-(UIView *)makeRight:(CGFloat)right{
    if([self verifySuperView]){
        CGRect rect = self.frame;
        CGRect superRect = self.superview.frame;
        CGFloat x = superRect.size.width + right;
        rect.origin.x = x;
        self.frame = rect;
    }
    return self;
}

-(UIView *)makeBottom:(CGFloat)bottom{
    if([self verifySuperView]){
        CGRect rect = self.frame;
        CGRect superRect = self.superview.frame;
        CGFloat y = superRect.size.height + bottom;
        rect.origin.y = y;
        self.frame = rect;
    }
    return self;
}

-(UIView *)makeOffset:(NSArray *)offset{
    [self equal:offset.firstObject offset:offset.lastObject];
    return self;
}
@end


@implementation UIView (HLOffest)
-(UIView *)equal:(UIView *)originView offset:(NSDictionary *)offsets{
    if(![originView isKindOfClass:[UIView class]]) return self;
    if (![self verifySuperView]) return self;
    if (![UIView verifyNSDictionary:offsets]) return self;
    CGRect originRect = [self.superview convertRect:originView.frame fromView:originView.superview];
    NSArray *formatStyle = [self formatStyle:offsets];
    NSArray *styles = formatStyle.firstObject;
    NSArray *values = formatStyle.lastObject;
    for (NSInteger i = 0; i < styles.count; ++i) {
        NSString *style = [styles objectAtIndex:i];
        id value = [values objectAtIndex:i];
        NSString *method = [NSString stringWithFormat:@"offset%@:originRect:",style];
        SEL selector = NSSelectorFromString(method);
        if(![UIView verifyNumber:value] || ![self respondsToSelector:selector]){
            continue;
        }
        IMP imp = [self methodForSelector:selector];
        UIView * (*func)(id, SEL, CGFloat, CGRect) = (void *)imp;
        func(self, selector, [value floatValue], originRect);
    }
    return self;
}
-(UIView *)offsetWidth:(CGFloat)width originRect:(CGRect)originRect{
    return [self makeWidth:originRect.size.width + width];
}

-(UIView *)offsetHeight:(CGFloat)height originRect:(CGRect)originRect{
    return [self makeHeight:originRect.size.height + height];
}

-(UIView *)offsetLeft:(CGFloat)left originRect:(CGRect)originRect{
    CGRect rect = self.frame;
    rect.origin.x = left + CGRectGetMinX(originRect);
    self.frame = rect;
    return self;
}

-(UIView *)offsetTop:(CGFloat)top originRect:(CGRect)originRect{
    CGRect rect = self.frame;
    rect.origin.y = top + CGRectGetMinY(originRect);
    self.frame = rect;
    return self;
}

-(UIView *)offsetRight:(CGFloat)right originRect:(CGRect)originRect{
    CGRect rect = self.frame;
    CGFloat x = CGRectGetMaxX(originRect) + right;
    rect.origin.x = x;
    self.frame = rect;
    return self;
}

-(UIView *)offsetBottom:(CGFloat)bottom originRect:(CGRect)originRect{
    CGRect rect = self.frame;
    CGFloat y = CGRectGetMaxY(originRect) + bottom;
    rect.origin.y = y;
    self.frame = rect;
    return self;
}
@end

@implementation UIView (verify)
-(BOOL)verifySuperView{
    return self.superview && [self.superview isKindOfClass:[UIView class]] ? YES : NO;
}
+(BOOL)verifyView:(id)view{
    return [view isKindOfClass:[UIView class]];
}
+(BOOL)verifyNSDictionary:(id)object{
    return [object isKindOfClass:[NSDictionary class]];
}

+ (BOOL)verifyNumber:(id)object{
    if(!([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]])){
        return NO;
    }
    NSString *string = [NSString stringWithFormat:@"%@",object];
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c) && c != '-' && c != '.') {
            return NO;
        }
    }
    return YES;
}
+(BOOL)verifyOffset:(NSString *)key offsetValue:(id)value{
    if([key isEqualToString:Offset] && [value isKindOfClass:[NSArray class]]){
        NSArray *arrValue = value;
        if(arrValue.count == 2 && [UIView verifyView:arrValue.firstObject] && [UIView verifyNSDictionary:arrValue.lastObject]){
            return YES;
        }
    }
    return NO;
}

@end

@implementation UIView(Tool)
-(NSArray *)formatStyle:(NSDictionary *)frame{
    NSMutableArray *styles = [NSMutableArray arrayWithArray:frame.allKeys];
    NSMutableArray *values = [NSMutableArray arrayWithArray:frame.allValues];
    [self formatWidthHeight:styles values:values];
    [self formatContradiction:styles values:values];
    if([styles containsObject:Offset]){
        [self analysisOffset:styles values:values];
    }
    if([styles containsObject:Anchor]){
        NSUInteger aIndex = [styles indexOfObject:Anchor];
        if([UIView verifyNSDictionary:[values objectAtIndex:aIndex]]){
            NSUInteger aIndex = [styles indexOfObject:Anchor];
            NSDictionary *anchor = [values objectAtIndex:aIndex];
            [self formatAnchor:styles values:values anchor:anchor];
        }
    }
    return @[styles,values];
}
-(void)formatWidthHeight:(NSMutableArray *)styles values:(NSMutableArray *)values{
    if([styles containsObject:Width]){
        NSUInteger index = [styles indexOfObject:Width];
        [styles exchangeObjectAtIndex:0 withObjectAtIndex:index];
        [values exchangeObjectAtIndex:0 withObjectAtIndex:index];
    }
    if([styles containsObject:Height]){
        NSUInteger index = [styles indexOfObject:Height];
        NSUInteger destinationIndex = 0;
        if([styles containsObject:Width]) destinationIndex = 1;
        [styles exchangeObjectAtIndex:destinationIndex withObjectAtIndex:index];
        [values exchangeObjectAtIndex:destinationIndex withObjectAtIndex:index];
    }
}
-(void)formatContradiction:(NSMutableArray *)styles values:(NSMutableArray *)values{
    if([styles containsObject:Left] && [styles containsObject:Right]){
        NSUInteger rIndex = [styles indexOfObject:Right];
        [styles removeObjectAtIndex:rIndex];
        [values removeObjectAtIndex:rIndex];
    }
    if([styles containsObject:Top] && [styles containsObject:Bottom]){
        NSUInteger bIndex = [styles indexOfObject:Bottom];
        [styles removeObjectAtIndex:bIndex];
        [values removeObjectAtIndex:bIndex];
    }

}
-(void)analysisOffset:(NSMutableArray *)styles values:(NSMutableArray *)values{
    NSUInteger oIndex = [styles indexOfObject:Offset];
    id oValue = [values objectAtIndex:oIndex];
    if([UIView verifyOffset:Offset offsetValue:oValue]){
        NSDictionary *offset = [NSArray arrayWithArray:oValue].lastObject;
        NSMutableArray *oStyles = [NSMutableArray arrayWithArray:offset.allKeys];
        NSMutableArray *oValues = [NSMutableArray arrayWithArray:offset.allValues];
        [self formatContradiction:oStyles values:oValues];

        [self removeContradictionOffset:styles offsetStyles:oStyles offsetValues:oValues frameStyle:@[Width]];
        [self removeContradictionOffset:styles offsetStyles:oStyles offsetValues:oValues frameStyle:@[Height]];
        [self removeContradictionOffset:styles offsetStyles:oStyles offsetValues:oValues frameStyle:@[Right,Left]];
        [self removeContradictionOffset:styles offsetStyles:oStyles offsetValues:oValues frameStyle:@[Bottom,Top]];
        if([styles containsObject:Anchor]){
            NSUInteger aIndex = [styles indexOfObject:Anchor];
            if([UIView verifyNSDictionary:[values objectAtIndex:aIndex]]){
                NSUInteger aIndex = [styles indexOfObject:Anchor];
                NSDictionary *anchor = [values objectAtIndex:aIndex];
                [self formatAnchor:oStyles values:oValues anchor:anchor];
            }
        }
        
        NSMutableDictionary *oDictionary = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < oStyles.count; ++i) {
            NSString *oStype = [oStyles objectAtIndex:i];
            id oValue = [oValues objectAtIndex:i];
            [oDictionary setValue:oValue forKey:oStype];
        }
        
        [values replaceObjectAtIndex:oIndex withObject:@[[NSArray arrayWithArray:oValue].firstObject,[NSDictionary dictionaryWithDictionary:oDictionary]]];
    }
}

-(void)removeContradictionOffset:(NSMutableArray *)styles offsetStyles:(NSMutableArray *)oStyles offsetValues:(NSMutableArray *)oValues frameStyle:(NSArray *)fTyles{
    BOOL hasTyle = NO;
    for (NSString *type in fTyles) {
        if([styles containsObject:type]){
            hasTyle = YES;
            break;
        }
    }
    if(hasTyle == YES){
        for (NSString *type in fTyles) {
            if([oStyles containsObject:type]){
                NSUInteger oIndex = [oStyles indexOfObject:type];
                [oStyles removeObjectAtIndex:oIndex];
                [oValues removeObjectAtIndex:oIndex];
            }
        }
    }
}
-(void)formatAnchor:(NSMutableArray *)styles values:(NSMutableArray *)values anchor:(NSDictionary *)anchor{
    
    NSMutableArray *aStyles = [NSMutableArray arrayWithArray:anchor.allKeys];
    NSMutableArray *aValues = [NSMutableArray arrayWithArray:anchor.allValues];
    [self formatContradiction:aStyles values:aValues];
    
    for (NSInteger i = 0; i < aStyles.count; ++i) {
        NSString *aStyle = [aStyles objectAtIndex:i];
        NSString *sel = [NSString stringWithFormat:@"formatAnchor%@:frameStyles:frameValues:",aStyle];
        SEL selector = NSSelectorFromString(sel);
        if([self respondsToSelector:selector]){
            IMP imp = [self methodForSelector:selector];
            void * (*function)(id,SEL,id,NSMutableArray *,NSMutableArray *) = (void *)imp;
            function(self,selector,[aValues objectAtIndex:i],styles,values);
        }
    }
}
-(void)formatAnchorTop:(id)aValue frameStyles:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    if(![UIView verifyNumber:aValue]) return;
    if([styles containsObject:Top]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Top countType:0];
    }else if ([styles containsObject:Bottom]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Bottom countType:0];
    }
}
-(void)formatAnchorBottom:(id)aValue frameStyles:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    if(![UIView verifyNumber:aValue]) return;
    if([styles containsObject:Top]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Top countType:1];
    }else if ([styles containsObject:Bottom]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Bottom countType:1];
    }
}
-(void)formatAnchorLeft:(id)aValue frameStyles:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    if(![UIView verifyNumber:aValue]) return;
    if([styles containsObject:Left]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Left countType:0];
    }else if ([styles containsObject:Right]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Right countType:0];
    }
}
-(void)formatAnchorRight:(id)aValue frameStyles:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    if(![UIView verifyNumber:aValue]) return;
    if([styles containsObject:Left]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Left countType:2];
    }else if ([styles containsObject:Right]){
        [self anchorCountFrame:aValue frameStyles:styles frameValues:values frameType:Right countType:2];
    }
}
/**
 0:-
 1:Height -
 2:Width -
 */
-(void)anchorCountFrame:(id)countValue frameStyles:(NSMutableArray *)styles frameValues:(NSMutableArray *)values frameType:(NSString *)fType countType:(NSInteger)cType{
    CGFloat countNumber = [countValue floatValue];
    
    NSInteger index = [styles indexOfObject:fType];
    id value = [values objectAtIndex:index];
    if(![UIView verifyNumber:value]) return;
    
    CGFloat number = [value floatValue];
    switch (cType) {
            case 0:
            [values replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:number - countNumber]];
            break;
            case 1:
            [values replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:number - countNumber - [self getFrameHeight:styles frameValues:values]]];
            break;
            case 2:
            [values replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:number - countNumber - [self getFrameWidth:styles frameValues:values]]];
            break;
        default:
            break;
    }
    
}
-(CGFloat)getFrameHeight:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    CGFloat heigh = self.frame.size.height;
    if([styles containsObject:Height]){
        NSInteger hIndex = [styles indexOfObject:Height];
        id hValue = [values objectAtIndex:hIndex];
        if([UIView verifyNumber:hValue]){
            heigh = [hValue floatValue];
        }
    }
    return heigh;
}
-(CGFloat)getFrameWidth:(NSMutableArray *)styles frameValues:(NSMutableArray *)values{
    CGFloat width = self.frame.size.width;
    if([styles containsObject:Width]){
        NSInteger wIndex = [styles indexOfObject:Width];
        id wValue = [values objectAtIndex:wIndex];
        if([UIView verifyNumber:wValue]){
            width = [wValue floatValue];
        }
    }
    return width;
}
@end

@implementation UIView(calculater)
-(CGFloat)originXFromCentryView{
    CGFloat x = 0;
    if([self verifySuperView]){
        x = (self.superview.bounds.size.width - self.bounds.size.width) / 2.0;
    }
    return x;
}
-(CGFloat)originYFromCentryView{
    CGFloat y = 0;
    if([self verifySuperView]){
        y = (self.superview.bounds.size.height - self.bounds.size.height) / 2.0;
    }
    return y;
}

@end
