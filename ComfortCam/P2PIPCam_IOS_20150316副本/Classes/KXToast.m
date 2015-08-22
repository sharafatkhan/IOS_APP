//
//  KXToast.m
//  IOSDemo
//
//  Created by Tsang on 14-6-25.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import "KXToast.h"
#import <QuartzCore/QuartzCore.h>
@interface KXToast()
- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat) duration_;

- (void)dismisToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset_;
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;
@end

@implementation KXToast

#pragma mark---KXToast 实例方法
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    if (contentView!=nil) {
        [contentView release];
        contentView=nil;
    }
    [super dealloc];
}
-(id)initWithText:(NSString *)text_{
    if (self==[super init]) {
        text=[text_ copy];
        UIFont *font=[UIFont boldSystemFontOfSize:14];
        CGSize textSize=[text sizeWithFont:font constrainedToSize:CGSizeMake(280, 100) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width+12, textSize.height+10)];
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.textColor=[UIColor whiteColor];
        textLabel.textAlignment=UITextAlignmentCenter;
        textLabel.font=font;
        textLabel.text=text;
        textLabel.numberOfLines=0;
        
        contentView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius=5.0f;
        contentView.layer.shadowOffset=CGSizeMake(0, 3);
        contentView.layer.shadowColor=[UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity=1;
        contentView.layer.shadowRadius=5;
//        contentView.layer.borderWidth=1;
//        contentView.layer.borderColor=[UIColor orangeColor].CGColor;
        contentView.backgroundColor=[UIColor redColor];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchUpInside];
        contentView.alpha=0.0f;
//        [textLabel release];
        duration=Default_Dismiss_Duration;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    return self;
}

#pragma mark---设备转动调用的方法
-(void)deviceOrientationDidChange:(NSNotification *)notify{
    
    
    [self hideAnimation];
}
-(void)dismisToast{
    [contentView removeFromSuperview];
}
-(void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
}
-(void)setDuration:(CGFloat)duration_{
    duration=duration_;
}
-(void)showAnimation{
    [self changeContentViewOrientation];
    [UIView beginAnimations:@"KXShow" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha=1.0f;
    [UIView commitAnimations];
    
    
}
-(void)hideAnimation{
    [UIView beginAnimations:@"KXHide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(dismisToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha=0.0f;
    [UIView commitAnimations];
}
-(void)show{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    contentView.center=CGPointMake(25, window.center.y);
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}
-(void)showFromTopOffset:(CGFloat)topOffset_{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    contentView.center=CGPointMake(window.center.x, topOffset_+contentView.frame.size.height/2);
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}
-(void)showFromBottomOffset:(CGFloat)bottomOffset_{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    contentView.center=CGPointMake(window.center.x, window.frame.size.height-(bottomOffset_+contentView.frame.size.height));
    [window addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

#pragma mark---判断屏幕所处的方向，根据方向来旋转contentView
-(void)changeContentViewOrientation{
 
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation(M_PI/2);
    contentView.transform = CGAffineTransformConcat(window.transform, rotateTransform);
    return;
    
    
    CGFloat centerX=contentView.center.x;
    CGFloat centerY=contentView.center.y;
    CGFloat windowCenterX = window.center.x;
    CGFloat windowCenterY = window.center.y;
    NSLog(@"centerX=%f centerY=%f windowCenterX=%f windowCenterY=%f",centerX,centerY,windowCenterX,windowCenterY);
    UIInterfaceOrientation currentOrientation=[UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation==UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Orientation UIInterfaceOrientationLandscapeLeft");
         CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation(-M_PI/2);
         contentView.transform = CGAffineTransformConcat(window.transform, rotateTransform);
         //contentView.center=CGPointMake(windowCenterX, windowCenterY);
    }else if(currentOrientation ==UIInterfaceOrientationLandscapeRight){
        NSLog(@"Orientation UIInterfaceOrientationLandscapeRight");
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation(M_PI/2);
         contentView.transform = CGAffineTransformConcat(window.transform, rotateTransform);
         //contentView.center=CGPointMake(windowCenterX, windowCenterY);
    }else if(currentOrientation==UIInterfaceOrientationPortrait){
        NSLog(@"Orientation UIInterfaceOrientationPortrait");
    }else if(currentOrientation==UIInterfaceOrientationPortraitUpsideDown){
        NSLog(@"Orientation UIInterfaceOrientationPortraitUpsideDown");
    }else {
        NSLog(@"Orientation Other");
    }
   
}

#pragma mark---KXToast 类方法
+(void)showWithText:(NSString *)text_ duration:(CGFloat)duration_{
    KXToast *toast=[[[KXToast alloc]initWithText:text_] autorelease];
    [toast setDuration:duration_];
    [toast show];
}
+(void)showWithText:(NSString *)text_{
    [KXToast showWithText:text_ duration:Default_Dismiss_Duration];
}


+(void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset duration:(CGFloat)duration_{
    KXToast *toast=[[[KXToast alloc]initWithText:text_] autorelease];
    [toast setDuration:duration_];
    [toast showFromTopOffset:topOffset];
}
+(void)showWithText:(NSString *)text_ topOffset:(CGFloat)topOffset_{
    [KXToast showWithText:text_ topOffset:topOffset_ duration:Default_Dismiss_Duration];
}

+(void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset_ duration:(CGFloat)duration_{
    KXToast *toast=[[[KXToast alloc]initWithText:text_] autorelease];
    [toast setDuration:duration_];
    [toast showFromBottomOffset:bottomOffset_];
}
+(void)showWithText:(NSString *)text_ bottomOffset:(CGFloat)bottomOffset_{
    [KXToast showWithText:text_ bottomOffset:bottomOffset_ duration:Default_Dismiss_Duration];
}
@end
