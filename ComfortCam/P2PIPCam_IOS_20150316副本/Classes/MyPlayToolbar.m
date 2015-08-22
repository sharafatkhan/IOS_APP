//
//  MyPlayToolbar.m
//  P2PCamera
//
//  Created by Tsang on 14-4-11.
//
//

#import "MyPlayToolbar.h"
#import "PaomaButton.h"
#define WIDTH 40
@implementation MyPlayToolbar
@synthesize mType;
@synthesize mSpace;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame WithBtnNumber:(int)num
{
    self = [super initWithFrame:frame];
    if (self) {
        mSpace=1;
        mBtnNumber=num;
        mainScreen=frame;
        btnSpaceArr=[[NSMutableArray alloc]init];
        btnWidthArr=[[NSMutableArray alloc]init];
        btnArr=[[NSMutableArray alloc]init];
        
        for (int i=0; i<num; i++) {
            [btnWidthArr addObject:[NSNumber numberWithInt:WIDTH]];
        }
        
        
        for (int i=0; i<num; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=i;
            
//            PaomaButton *btn=[[PaomaButton alloc] initWithFrame:CGRectZero];
//            btn.tag=i;
            [btnArr addObject:btn];
        }
        self.backgroundColor=[UIColor clearColor];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       
        scrollView.showsHorizontalScrollIndicator=YES;
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.alwaysBounceVertical=NO;
        scrollView.bounces=YES;
        scrollView.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
        imgViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgViewBg.backgroundColor=[UIColor clearColor];
        //[self addSubview:imgViewBg];
        [self addSubview:scrollView];
        
    }
    return self;
}
-(void)dealloc{
    delegate=nil;
    if (btnArr!=nil) {
        [btnArr removeAllObjects];
        [btnArr release];
        btnArr=nil;
    }
    if (scrollView!=nil) {
        [scrollView release];
        scrollView=nil;
    }
    if (imgViewBg!=nil) {
        [imgViewBg release];
        imgViewBg=nil;
    }
    if (btnSpaceArr!=nil) {
        [btnSpaceArr removeAllObjects];
        [btnSpaceArr release];
        btnSpaceArr=nil;
    }
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"MyPlayToolBar...drawRect...");
    int btnHeight=mainScreen.size.height;
    [btnWidthArr replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:[self getRemainSpace]]];
    int allWidth=0;
    for (int i=0; i<mBtnNumber; i++) {
        int width=[[btnWidthArr objectAtIndex:i] intValue];
        
        allWidth+=width;
    }
    allWidth+=7;
    
    if (allWidth>mainScreen.size.width) {
        
        scrollView.contentSize=CGSizeMake(allWidth, mainScreen.size.height);
    }else{
       // NSLog(@"=======allwidth....mainScreen.size.width=%f",mainScreen.size.width);
        scrollView.contentSize=CGSizeMake(mainScreen.size.width, mainScreen.size.height);
    }
    
    
    for(int i=0;i<mBtnNumber;i++){
       
        if (i!=0) { 
            mAllWith+=[[btnWidthArr objectAtIndex:i-1] intValue];
        }
        int width=[[btnWidthArr objectAtIndex:i] intValue];
        UIButton *btn=(UIButton *)[btnArr objectAtIndex:i];        
        btn.frame=CGRectMake(i*mSpace+mAllWith, 0, width, btnHeight);
        
  //          NSLog(@"btn%d.x=%f width=%d",i,btn.frame.origin.x,width);
        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlEventTouchDown];
        btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.0];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(onBtnDown:) forControlEvents:UIControlEventTouchDown];
        [scrollView addSubview:btn];
        
        
//        PaomaButton *btn=(PaomaButton *)[btnArr objectAtIndex:i];
//        [btn setMyFrame:CGRectMake(i*mSpace+mAllWith, 0, width, btnHeight)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
//        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlEventTouchDown];
//        btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.0];
//        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn addTarget:self action:@selector(onBtnDown:) forControlEvents:UIControlEventTouchDown];
//        [scrollView addSubview:btn];
        
        
    }
}
-(int)getRemainSpace{
    int allWidth=(mBtnNumber-2)*WIDTH+(mBtnNumber-1)*mSpace+[[btnWidthArr objectAtIndex:6] intValue];
    int remainWidth=(mainScreen.size.width-allWidth);
   // NSLog(@"getRemainSpace()...mainScreen.size.width=%f  allWidth=%d" ,mainScreen.size.width,allWidth);
   // NSLog(@"remainWidth=%d",remainWidth);
    
    return remainWidth;
    
}
-(void)SetBtnTitle:(NSString*)title WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
    NSLog(@"MyPlayToolBar...SetBtnTitle...title=%@",title);
   // [[btnArr objectAtIndex:index] setBtnTitle:title Color:[UIColor whiteColor]];
}
-(void)SetBtnTitleColor:(UIColor *)color ForState:(UIControlState)state WithIndex:(int)index {
    
    [(UIButton *)[btnArr objectAtIndex:index] setTitleColor:color forState:state];

}
-(void)SetBtnBackgroudImage:(UIImage*)img ForState:(UIControlState)state WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setBackgroundImage:img  forState:state];
}
-(void)SetBtnImage:(UIImage*)img ForState:(UIControlState)state WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setImage:img forState:state];
}
-(void)SetBtnSpace:(int)space WithIndex:(int)index{
    //[btnSpaceArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:space]];
}
-(void)SetBtnWidth:(int)width WithIndex:(int)index{
 [btnWidthArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:width]];
}
-(void)SetBtnSelect:(BOOL)flag WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setSelected:flag];
}

-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index{
    [(UIButton *)[btnArr objectAtIndex:index] setEnabled:flag];
}
-(void)SetBtnBackgroudColor:(UIColor*)color WithIndex:(int)index{
    ((UIButton *)[btnArr objectAtIndex:index]).backgroundColor=color;
}

-(void)onClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if (delegate!=nil) {
        [delegate playToolbarClick:mType Index:btn.tag];
    }
}
-(void)onBtnDown:(id)sender{
    NSLog(@"MyPlayToolbar....onBtnDown");
    UIButton *btn=(UIButton*)sender;
    if (delegate!=nil) {
        [delegate playToolbarDownClick:mType Index:btn.tag];
    }
}
@end
