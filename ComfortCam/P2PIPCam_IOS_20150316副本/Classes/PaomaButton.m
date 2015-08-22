//
//  PaomaButton.m
//  P2PCamera
//
//  Created by Tsang on 14-5-13.
//
//

#import "PaomaButton.h"

@implementation PaomaButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=YES;
        //self.layer.cornerRadius=8;
        mainScreen=frame;
        bgLabel=[[UILabel alloc]init];
        bgLabel.clipsToBounds=YES;
        bgLabel.frame=CGRectMake(5, 0, frame.size.width-10, frame.size.height);
        bgLabel.backgroundColor=[UIColor clearColor];
        bgLabel.textAlignment=UITextAlignmentCenter;
        
        label=[[UILabel alloc]init];
        label.textAlignment=UITextAlignmentCenter;
        label.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        label.backgroundColor=[UIColor clearColor];
        [bgLabel addSubview:label];
        [self addSubview:bgLabel];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnim) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

-(void)setMyFrame:(CGRect)frame{
    self.frame=frame;
    self.clipsToBounds=YES;
    //self.layer.cornerRadius=8;
    mainScreen=frame;
    
    bgLabel.clipsToBounds=YES;
    bgLabel.frame=CGRectMake(5, 0, frame.size.width-10, frame.size.height);
    bgLabel.backgroundColor=[UIColor clearColor];
    bgLabel.textAlignment=UITextAlignmentCenter;
    
    
    label.textAlignment=UITextAlignmentCenter;
    label.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    label.backgroundColor=[UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnim) name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)setBtnTitleColor:(UIColor*)color{
    label.textColor=color;
}
-(void)setBtnTitle:(NSString *)title Color:(UIColor *)color{
    CGSize size = [title  sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(10000, mainScreen.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    int leftSpace=10;
    if (size.width<bgLabel.frame.size.width) {
        leftSpace=(bgLabel.frame.size.width-size.width)/2;
    }
    CGRect labelframe = CGRectMake(leftSpace, 0, size.width, mainScreen.size.height);
    label.frame=labelframe;
    label.text = title;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = color;
    if (mainScreen.size.width<size.width) {
        isNeedAnim=YES;
    }else{
        isNeedAnim=NO;
    }
    animDuration=(size.width+10)/mainScreen.size.width;
    [self performSelector:@selector(startAnim) withObject:nil afterDelay:2];
}

-(void)startAnim{
    
    if (!isNeedAnim) {
       // NSLog(@"label.text=%@",label.text);
        return;
    }
    [UIView animateWithDuration:10
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (!isStartedAnim) {
                             isStartedAnim=YES;
                             CGRect frame = label.frame;
                             frame.origin.x = -(frame.size.width+15-mainScreen.size.width);
                             label.frame = frame;
                         }else{
                             isStartedAnim=NO;
                             CGRect frame = label.frame;
                             frame.origin.x = +(mainScreen.size.width+10-mainScreen.size.width);
                             label.frame = frame;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //label.frame=labelOldFrame;
                             [self startAnim];
                         }
                     }];
}

-(void)dealloc{
    if (label!=nil) {
        [label release];
    }
    if (bgLabel!=nil) {
        [bgLabel release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
