//
//  VideoPicView.m
//  P2PCamera
//
//  Created by Tsang on 14-5-17.
//
//

#import "VideoPicView.h"
#import <QuartzCore/QuartzCore.h>
@implementation VideoPicView
@synthesize imageView;
@synthesize flagImgView;
@synthesize hookImgView;
@synthesize line;
@synthesize labelSize;
@synthesize labelTime;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        BOOL isPad=NO;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            isPad=YES;
        }
        self.layer.cornerRadius=4;
        self.backgroundColor=[UIColor whiteColor];
        imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(2, 2, frame.size.width-4,frame.size.width-4);
        imageView.layer.cornerRadius=4;
        imageView.image=[UIImage imageNamed:@"back.png"];
        [self addSubview:imageView];
        
        flagImgView=[[UIImageView alloc]init];
        flagImgView.frame=CGRectMake((imageView.frame.size.width-30)/2, (imageView.frame.size.height-30)/2, 30, 30);
        flagImgView.image=[UIImage imageNamed:@"play_video.png"];
        [self addSubview:flagImgView];
        
        hookImgView=[[UIImageView alloc]init];
        hookImgView.frame=CGRectMake(CGRectGetMaxX(imageView.frame)-28, CGRectGetMaxY(imageView.frame)-25, 30, 30);
        hookImgView.image=[UIImage imageNamed:@"del_hook.png"];
        hookImgView.hidden=YES;
        [self addSubview:hookImgView];
        
        
        line=[[UILabel alloc]init];
        line.frame=CGRectMake(0, CGRectGetMaxY(imageView.frame)+2, frame.size.width, 1);
        line.backgroundColor=[UIColor grayColor];
        [self addSubview:line];
        
        labelTime=[[UILabel alloc]init];
        labelTime.frame=CGRectMake(2, CGRectGetMaxY(line.frame)+2, frame.size.width-4, 10);
        labelTime.backgroundColor=[UIColor clearColor];
        labelTime.textAlignment=UITextAlignmentCenter;
        labelTime.textColor=[UIColor blackColor];
        if (isPad) {
            labelTime.font=[UIFont systemFontOfSize:12];
        }else{
            labelTime.font=[UIFont systemFontOfSize:12];
        }
        
        labelTime.text=@"2014-05-17";
        labelTime.adjustsFontSizeToFitWidth=YES;
        [self addSubview:labelTime];
        
        labelSize=[[UILabel alloc]init];
        labelSize.frame=CGRectMake(2, CGRectGetMaxY(labelTime.frame)+2, frame.size.width-4, 10);
        labelSize.backgroundColor=[UIColor clearColor];
        labelSize.textColor=[UIColor blackColor];
        labelSize.adjustsFontSizeToFitWidth=YES;
        if (isPad) {
            labelSize.font=[UIFont systemFontOfSize:12];
        }else{
            labelSize.font=[UIFont systemFontOfSize:12];
        }
        labelSize.hidden=YES;
        labelSize.text=@"50M";
        [self addSubview:labelSize];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor=[UIColor grayColor];
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor=[UIColor whiteColor];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor=[UIColor whiteColor];
}

-(void)dealloc{
    imageView=nil;
    flagImgView=nil;
    hookImgView=nil;
    labelSize=nil;
    labelTime=nil;
    line=nil;
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
