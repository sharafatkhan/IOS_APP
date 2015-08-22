//
//  MyCheckBox.m
//  P2PCamera
//
//  Created by Tsang on 14-4-8.
//
//

#import "MyCheckBox.h"
static const CGFloat kHeight = 36.0f;
@implementation MyCheckBox
@synthesize delegate;
@synthesize titleText;
@synthesize checked;

- (id)initWithFrame:(CGRect)frame Checked:(BOOL)checked{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        delegate=nil;
        titleText=@"";
        self.checked=NO;
        self.userInteractionEnabled=YES;
       
        mainScreen=frame;
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


-(void)dealloc{
    [imgViewBg release];
    imgViewBg=nil;
    [titleLabel release];
    titleLabel=nil;
    [super dealloc];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    if ([titleText length]>0) {
        imgViewBg=[[UIImageView alloc]init];
        UIImage *img=[self imgWithChecked:checked];
        
        imgViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, img.size.width, img.size.height)];
        [imgViewBg setImage:img];
        [self addSubview:imgViewBg];
        
        titleLabel=[[UILabel alloc]init];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.text=titleText;
        titleLabel.frame=CGRectMake(10+img.size.width+5, 10, 100, 20);
        [self addSubview:titleLabel];
        
    }else{
        imgViewBg=[[UIImageView alloc]init];
        UIImage *img=[self imgWithChecked:checked];
        
        imgViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, img.size.width, img.size.height)];
        [imgViewBg setImage:img];
        [self addSubview:imgViewBg];
    
    }
    
    
    
}
-(void)setMyChecked:(BOOL)flag{
    checked=flag;
    imgViewBg.image=[self imgWithChecked:checked];
}
-(UIImage*)imgWithChecked:(BOOL)flag{
    UIImage *img=nil;
    if (flag) {
        img=[UIImage imageNamed:@"cbx_on.png"];
    }else{
        img=[UIImage imageNamed:@"cbx_off.png"];
    }
    return img;
}
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    return CGRectMake(5.0f, y, img.size.width, img.size.height);
}
#pragma  mark TouchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha=0.8f;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha=1.0f;
    if ([self superview]) {
//        UITouch *touch=[touches anyObject];
//        CGPoint point=[touch locationInView:[self superview]];
//        CGRect validTouchAera=CGRectMake(self.frame.origin.x-10, self.frame.origin.y-10, self.frame.size.width+10, self.frame.size.height+10);
//        validTouchAera=self.frame;
//        if (CGRectContainsPoint(validTouchAera, point)) {
//            checked=!checked;
//            imgViewBg.image=[self imgWithChecked:checked];
//            if (delegate!=nil) {
//                [delegate statusChanged:checked Tag:tag];
//            }
//        }
        checked=!checked;
        
        imgViewBg.image=[self imgWithChecked:checked];
        if (delegate!=nil) {
            [delegate statusChanged:checked Tag:self.tag];
        }
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}
@end
