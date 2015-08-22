//
//  KXStatusBar.m
//  IOSDemo
//
//  Created by Tsang on 14-6-25.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import "KXStatusBar.h"

@implementation KXStatusBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor redColor];
        
        label=[[UILabel alloc]init];
        label.textAlignment=UITextAlignmentCenter;
        label.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}
-(void)dealloc{
    if (label!=nil) {
        [label release];
        label=nil;
    }
    
    [super dealloc];
  }
-(void)showWithString:(NSString*)str{
    label.text=str;
    self.hidden=NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:2];
}
-(void)hide{
    self.hidden=YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
