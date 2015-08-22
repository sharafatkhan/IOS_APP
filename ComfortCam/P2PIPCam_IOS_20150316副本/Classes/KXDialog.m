//
//  KXDialog.m
//  P2PCamera
//
//  Created by Tsang on 14-6-27.
//
//

#import "KXDialog.h"
#import <QuartzCore/QuartzCore.h>
@implementation KXDialog

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame Msg:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        mNumber=20;
        strText=str;
        bgView=[[UIImageView alloc]init];
        bgView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [bgView setImage:[self createImageFromColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8] W:frame.size.width H:frame.size.height]];
        [self addSubview:bgView];
        bgView.userInteractionEnabled=NO;
        pgView=[[UIView alloc]init];
        pgView.frame=CGRectMake((frame.size.width-60)/2, (frame.size.height-60)/2, 60, 60);
        pgView.backgroundColor=[UIColor whiteColor];
        pgView.layer.cornerRadius=8;
        UIActivityIndicatorView *activeView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activeView.center=CGPointMake(pgView.bounds.size.width/2, pgView.bounds.size.height/2);
        [activeView startAnimating];
        [pgView addSubview:activeView];
        [activeView release];
        [self addSubview:pgView];
        label=[[UILabel alloc]init];
        label.frame=CGRectMake((frame.size.width-200)/2, pgView.frame.origin.y+pgView.frame.size.height+5, 200, 20);
        
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=UITextAlignmentCenter;
        [self addSubview:label];
        
        label.text=[NSString stringWithFormat:@"%d %@",mNumber,strText];
    }
    return self;
}

-(void)dealloc{
    if (label!=nil) {
        [label release];
        label=nil;
    }
    if (pgView!=nil) {
        [pgView release];
        pgView=nil;
    }
    if (bgView!=nil) {
        [bgView release];
        bgView=nil;
    }
    [super dealloc];
}

-(void)show{
    self.hidden=NO;
   mTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ScheduTime) userInfo:nil repeats:YES];
    
}
-(void)ScheduTime{
    mNumber--;
    if (mNumber==0) {
        if (mTimer!=nil) {
            [mTimer invalidate];
            mTimer=nil;
        }
        [self hide];
        return;
    }
   
    label.text=[NSString stringWithFormat:@"%d %@",mNumber,strText];
    
}
-(void)hide{
    NSLog(@"KXDialog....hide");
    if (mTimer!=nil) {
        [mTimer invalidate];
        mTimer=nil;
    }
    
    self.hidden=YES;
    //[self removeFromSuperview];
    if (delegate!=nil) {
        [delegate dialogHide];
    }
}

-(UIImage*)createImageFromColor:(UIColor*)color W:(int)w H:(int)h{
    CGRect rect=CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    return img;
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
