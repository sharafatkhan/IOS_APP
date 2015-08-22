//
//  MySetDialog.m
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import "MySetDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "PaomaButton.h"
@implementation MySetDialog
@synthesize btnArr;
@synthesize diaDelegate;
@synthesize mType;
- (id)initWithFrame:(CGRect)frame Btn:(int)num
{

    self = [super initWithFrame:frame];
    btnArr=[[NSMutableArray alloc]init];
    
    if (self) {
        int width=frame.size.width;
        int height=frame.size.height;
        int btnHeight=(height-5*(num+1))/num;
        int btnWidth=width-10;
        for (int i=0; i<num; i++) {
            
            PaomaButton *btn=[[PaomaButton alloc] initWithFrame:CGRectMake(5,5*(i+1)+btnHeight*i,btnWidth,btnHeight)];
           
           
            btn.tag=i;
           // btn.titleLabel.adjustsFontSizeToFitWidth=YES;
            btn.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
           
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [btnArr addObject:btn];

        }
        
       //[(UIButton *)[btnArr objectAtIndex:2] setTitle:<#(NSString *)#> forState:<#(UIControlState)#>]
    }
    
    
    return self;
}

-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    int tag=btn.tag;
    NSLog(@"tag=%d mType=%d",tag,mType);
    
    switch (tag) {
        case 0:{

            [diaDelegate mySetDialogOnClick:0 Type:mType];
        }
            break;
        case 1:
        {
//            ((UIButton *)[btnArr objectAtIndex:1]).selected=YES;
//            ((UIButton *)[btnArr objectAtIndex:0]).selected=NO;
            [diaDelegate mySetDialogOnClick:1 Type:mType];
        }
            break;
        case 2:
            [diaDelegate mySetDialogOnClick:2 Type:mType];
            break;
        case 3:
            [diaDelegate mySetDialogOnClick:3 Type:mType];
            break;
        case 4:
            [diaDelegate mySetDialogOnClick:4 Type:mType];
            break;
        case 5:
            [diaDelegate mySetDialogOnClick:5 Type:mType];
            break;
        case 6:
            [diaDelegate mySetDialogOnClick:6 Type:mType];
            break;
        case 7:
            [diaDelegate mySetDialogOnClick:7 Type:mType];
            break;
        case 8:
            [diaDelegate mySetDialogOnClick:8 Type:mType];
            break;
        default:
            break;
    }
}

-(void)setBtnImag:(UIImage *)img Index:(int)index {
    [[btnArr objectAtIndex:index] setImage:img forState:UIControlStateNormal];
}
-(void)setBtnImag:(UIImage *)img Index:(int)index State:(UIControlState)state{
    [[btnArr objectAtIndex:index] setImage:img forState:state];
}
-(void)setBtnTitle:(NSString *)title Index:(int)index{
   [[btnArr objectAtIndex:index] setBtnTitle:title Color:[UIColor blackColor]];
}
-(void)setBtnBackgroundColor:(UIColor *)color Index:(int)index{
    
    ((UIButton*)[btnArr objectAtIndex:index]).backgroundColor=color;
}

-(void)setBtnSelected:(BOOL)flag Index:(int)index{
    ((UIButton*)[btnArr objectAtIndex:index]).selected=flag;
    if (flag) {
        [[btnArr objectAtIndex:index] setBtnTitleColor:[UIColor blueColor]];
    }else{
        [[btnArr objectAtIndex:index] setBtnTitleColor:[UIColor blackColor]];
    }
}

-(void)dealloc{
    
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
