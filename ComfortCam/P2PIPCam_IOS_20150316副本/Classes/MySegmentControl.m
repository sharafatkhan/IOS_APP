//
//  MySegmentControl.m
//  P2PCamera
//
//  Created by Tsang on 14-4-10.
//
//

#import "MySegmentControl.h"
#import <QuartzCore/QuartzCore.h>
@implementation MySegmentControl
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame segmentNumber:(int)num{
    self = [super initWithFrame:frame];
    if (self) {
        int btnWidth=(frame.size.width-num)/num;
        int btnHeight=frame.size.height;
        btnArr=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor clearColor];
        for(int i=0;i<num;i++){
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(btnWidth*i+i,0,btnWidth,btnHeight);
            btn.tag=i;
            btn.layer.cornerRadius=8;
            btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btnArr addObject:btn];
        }
        
    }
    return self;
}
-(void)setSegmentImage:(UIImage *)img ForStatus:(UIControlState)status Index:(int)index{
    [((UIButton*)[btnArr objectAtIndex:index]) setBackgroundImage:img forState:status];
}
-(void)setSegmentTitle:(NSString *)title Index:(int)index{
[[btnArr objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
}
-(void)setSegmentBackgroundColor:(UIColor *)color Index:(int)index{
 ((UIButton*)[btnArr objectAtIndex:index]).backgroundColor=color;
}
-(void)setSegmentSelected:(BOOL)flag Index:(int)index{
 ((UIButton*)[btnArr objectAtIndex:index]).selected=flag;
}
-(void)setSegmentTitleColor:(UIColor *)color ForStatus:(UIControlState)status Index:(int)index{
    [((UIButton*)[btnArr objectAtIndex:index]) setTitleColor:color forState:status];
}
-(void)setSegmentBackgroundImageWithColor:(UIColor*)color ForState:(UIControlState)state Index:(int)index {
    [((UIButton*)[btnArr objectAtIndex:index]) setBackgroundImage:[self createImageFromColor:color] forState:state];
}
-(UIImage*)createImageFromColor:(UIColor*)color{
    CGRect rect=CGRectMake(0, 0, 60, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    return img;
}
-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    if (delegate!=nil) {
        [delegate segmentSelectedIndex:btn.tag];
    }
}

-(void)dealloc{
    if (btnArr!=nil) {
        [btnArr removeAllObjects];
        [btnArr release];
        btnArr=nil;
    }
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
