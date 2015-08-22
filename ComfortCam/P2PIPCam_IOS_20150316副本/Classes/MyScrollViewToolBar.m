//
//  MyScrollViewToolBar.m
//  P2PCamera
//
//  Created by Tsang on 14-4-9.
//
//

#import "MyScrollViewToolBar.h"
#define BTN_MINWIDTH 100
#define BTN_MINHEIGHT 30
#define BTN_MINSPACE 4
@implementation MyScrollViewToolBar
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame WithBtnNumber:(int)num
{
    self = [super initWithFrame:frame];
    if (self) {
        btnArr=[[NSMutableArray alloc]init];
        int btnWidth=(frame.size.width-BTN_MINSPACE*(num+1))/num;
        int btnHeight=frame.size.height-8;
        if (btnWidth<BTN_MINWIDTH) {
            btnWidth=BTN_MINWIDTH;
        }
        imgViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:imgViewBg];
        
        for(int i=0;i<num;i++){
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(BTN_MINSPACE*(i+1)+btnWidth*i, (frame.size.height-btnHeight)/2, btnWidth, btnHeight);
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake( 0,6,0,6)];
            btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.tag=i;
            [self addSubview:btn];
            
            [btnArr addObject:btn];
        }
        
       
    }
    
   
    return self;
}

-(void)setBtnTitle:(NSString*)title Index:(int)index{
    NSLog(@"setBtnTitle index=%d",index);
    [(UIButton*)[btnArr objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
}
-(void)setBtnTitleColor:(UIColor *)color ForStatus:(UIControlState)status Index:(int)index{
    [(UIButton*)[btnArr objectAtIndex:index] setTitleColor:color forState:status];
}
-(void)setBtnBackgroudImage:(UIImage*)img ForStatus:(UIControlState)status Index:(int)index{
    [(UIButton*)[btnArr objectAtIndex:index] setBackgroundImage:img forState:status];
}
-(void)setBtnSelected:(BOOL)flag  Index:(int)index{
    [(UIButton*)[btnArr objectAtIndex:index] setSelected:flag];
}
-(void)setScrollToolBarBackgroudImage:(UIImage*)img{
    [imgViewBg setImage:img];
}
-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setEnabled:flag];
}
-(void)onClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    NSLog(@"onClick...tag=%d",btn.tag);
    if (delegate!=nil) {
        [delegate scrollBarOnClicked:btn.tag];
    }
}
-(void)dealloc{
    if (btnArr!=nil) {
        [btnArr removeAllObjects];
        [btnArr release];
        btnArr=nil;
    }
    if (imgViewBg!=nil) {
        [imgViewBg release];
        imgViewBg=nil;
    }
    if (scrollView!=nil) {
        [scrollView release];
        scrollView=nil;
    }
    delegate=nil;
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
