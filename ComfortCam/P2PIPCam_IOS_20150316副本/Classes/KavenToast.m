//
//  KavenToast.m
//  P2PCamera
//
//  Created by Tsang on 14-5-4.
//
//

#import "KavenToast.h"
#import <QuartzCore/QuartzCore.h>
@implementation KavenToast

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        mainScreen=frame;
    }
    return self;
}
-(void)showWithText:(NSString*)title{
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.numberOfLines=0;
    UIFont *font=[UIFont systemFontOfSize:12];
    CGSize size=CGSizeMake(mainScreen.size.width, 100);
    CGSize labelSize=[title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    label.frame=CGRectMake((mainScreen.size.width-labelSize.width)/2, (mainScreen.size.height-labelSize.height)/2, labelSize.width+5, labelSize.height);
    label.backgroundColor=[UIColor blackColor];
    label.layer.cornerRadius=4;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.text=title;
    label.font=font;
    [self addSubview:label];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}
-(void)removeFromSuperviewK{

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
