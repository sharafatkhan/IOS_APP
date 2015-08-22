//
//  MyVerticalScrollToolBar.m
//  P2PCamera
//
//  Created by Tsang on 14-4-8.
//
//

#import "MyVerticalScrollToolBar.h"
#define MaxHeight 120
#define BTNHEIGHT 40
@implementation MyVerticalScrollToolBar
@synthesize delegate;
@synthesize mType;


- (id)initWithFrame:(CGRect)frame Btn:(int)num BtnSpace:(float)space WithIphone:(BOOL)isPhone
{
    self = [super initWithFrame:frame];
    if (self) {
        btnArr=[[NSMutableArray alloc]init];
        int width=frame.size.width;
        int btnHoriSpace=10;
        int btnHeight=BTNHEIGHT;
        int btnWidth=(width-btnHoriSpace)/2;
        int numm=num/2+num%2;
        
        
        scrollView=[[UIScrollView alloc]init];
        scrollView.frame=CGRectMake(0, 0, width, MaxHeight);
        scrollView.contentSize=CGSizeMake(width, BTNHEIGHT*numm+space*(numm-1));
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.showsVerticalScrollIndicator=YES;
        scrollView.alwaysBounceVertical=NO;
        scrollView.bounces=NO;
        scrollView.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
        
        numm=num/2;
        
        for(int i=0;i<numm;i++){
            
            int j=i*2;
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(0,space*i+btnHeight*i,btnWidth,btnHeight);
            btn.tag=j;
            btn.titleLabel.font=[UIFont systemFontOfSize:10];
            // btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.0];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlEventTouchDown];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
            [btnArr addObject:btn];
            
            j++;
            
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(btnWidth+btnHoriSpace,space*i+btnHeight*i,btnWidth,btnHeight);
            btn.tag=j;
            btn.titleLabel.font=[UIFont systemFontOfSize:10];
            // btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.0];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlEventTouchDown];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
            [btnArr addObject:btn];
        }
        numm=num%2;
        if (numm==1) {
            int i=num/2;
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(0,space*i+btnHeight*i,btnWidth,btnHeight);
            btn.tag=i*2;
            btn.titleLabel.font=[UIFont systemFontOfSize:10];
            // btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.0];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlEventTouchDown];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
            [btnArr addObject:btn];
        }
        [self addSubview:scrollView];
    }
    return self;
}

-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    NSLog(@"onClick...tag=%d",btn.tag);
    if (delegate!=nil) {
        [delegate VerScrollBarClick:mType Index:btn.tag];
    }
}
-(void)setBtnImag:(UIImage *)img Index:(int)index{
    [[btnArr objectAtIndex:index] setImage:img forState:UIControlStateNormal];
}
-(void)setBtnTitle:(NSString *)title Index:(int)index{
    [[btnArr objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
}
-(void)setBtnBackgroundColor:(UIColor *)color Index:(int)index{
    ((UIButton*)[btnArr objectAtIndex:index]).backgroundColor=color;
    
}
-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setEnabled:flag];
}
-(void)setBtnSelected:(BOOL)flag Index:(int)index{
    ((UIButton*)[btnArr objectAtIndex:index]).selected=flag;
}
-(void)setBtnTitleColor:(UIColor*)color ForState:(UIControlState)state WithIndex:(int)index{
    [(UIButton*)[btnArr objectAtIndex:index] setTitleColor:color forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    if (btnArr!=nil) {
        [btnArr removeAllObjects];
        [btnArr release];
        btnArr=nil;
    }
    [super dealloc];
}
@end
