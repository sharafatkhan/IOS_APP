//
//  MyDialogView.m
//  P2PCamera
//
//  Created by Tsang on 13-4-17.
//
//

#import "MyDialogView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyDialogView
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize dialogDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
//        contentView.backgroundColor=[UIColor greenColor];
//        [super addSubview:contentView];
//        [contentView release];
        [self initBtn];
    }
    return self;
}

-(void)initBtn{
//    CGRect mainFrame=self.frame;
    btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame=CGRectMake(5,5,60,40);
    [btn1 setTitle:@"关闭" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame=CGRectMake(70, 5, 60, 40);
    [btn2 setTitle:@"全屏" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
}
-(void)setTagClick:(int)tag{
    tg=tag;
}
-(void)btnClick1{
    [dialogDelegate dialogBtnClick:1 Tag:tg];
}
-(void)btnClick2{
    [dialogDelegate dialogBtnClick:2 Tag:tg];
}
-(void)dealloc{
    btn2=nil;
    btn1=nil;
    [super dealloc];
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
