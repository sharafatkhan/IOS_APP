//
//  MyUIGridView.m
//  MyIosAllDemo
//
//  Created by Tsang on 13-6-16.
//  Copyright (c) 2013年 Tsang. All rights reserved.
//

#import "MyUIGridView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyUIGridView
@synthesize myDelegate;
@synthesize columnWidth;
@synthesize columnHeight;
@synthesize numColumns;
@synthesize verticalSpacing;
@synthesize horizontalSpacing;
@synthesize dicView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView *imgV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
//        imgV.frame=frame;
//        [self addSubview:imgV];
//        [imgV release];
    }
    return self;
}
-(void)reloadGridViewData{
    NSLog(@"reloadGridViewData。。");
    int count= [myDelegate getCellCount];
    int allRow=count/numColumns+(count%numColumns>0?1:0);
    NSLog(@"allRow=%d",allRow);
    [self setContentSize:CGSizeMake(columnWidth*numColumns+horizontalSpacing*(numColumns+1), columnHeight*allRow+verticalSpacing*(allRow+1))];
    
    for (int i=0; i<count; i++) {
        int column=i%numColumns;
        int row=i/numColumns;
        
        UIView *view=[myDelegate cellFowColumn:i];
        view.frame=CGRectMake(column*(columnWidth+horizontalSpacing)+horizontalSpacing, row*(columnHeight+verticalSpacing)+verticalSpacing, columnWidth, columnHeight);
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer *doubleTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
        [doubleTag setNumberOfTapsRequired:2];
        [view addGestureRecognizer:doubleTag];
        
        UILongPressGestureRecognizer *longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
        [view addGestureRecognizer:longGesture1];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewPressed:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [view addGestureRecognizer:singleTap];
        [doubleTag release];
        [longGesture1 release];
        [singleTap release];
        [self addSubview:view];
        
        
    }
}
-(void)ImageViewDoubleTapped:(UITapGestureRecognizer *)recognizer{
    
    UIView *view = [recognizer view];
    NSLog(@"ImageViewDoubleTapped...index=%d",view.tag);

}
-(void)ImageViewLongPressed:(UILongPressGestureRecognizer *)recognizer{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        UIView *view = [recognizer view];
        NSLog(@"ImageViewLongPressed...index=%d",view.tag);
    }
}
- (void) ImageViewPressed:(UIGestureRecognizer *)recognizer
{
    UIView *view = [recognizer view];
    
    view.layer.masksToBounds = YES;
    //cell.ImageView1.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 4.0;
    view.layer.borderColor = [[UIColor blueColor] CGColor];
    
    [self performSelector:@selector(viewSeleted:) withObject:view afterDelay:0.3];
    NSLog(@"ImageViewPressed...index=%d",view.tag);
}
-(void)viewSeleted:(UIView *)view{
    view.layer.masksToBounds = YES;
    //cell.ImageView1.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor blueColor] CGColor];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     NSLog(@"MyUIGridView...touchesBegan");
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"MyUIGridView....drawRect()");
    int count= [myDelegate getCellCount];
    int allRow=count/numColumns+(count%numColumns>0?1:0);
    NSLog(@"allRow=%d",allRow);
    [self setContentSize:CGSizeMake(columnWidth*numColumns+horizontalSpacing*(numColumns+1), columnHeight*allRow+verticalSpacing*(allRow+1))];
    
    for (int i=0; i<count; i++) {
        int column=i%numColumns;
        int row=i/numColumns;
        
        UIView *view=[myDelegate cellFowColumn:i];
        view.frame=CGRectMake(column*(columnWidth+horizontalSpacing)+horizontalSpacing, row*(columnHeight+verticalSpacing)+verticalSpacing, columnWidth, columnHeight);
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer *doubleTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
        [doubleTag setNumberOfTapsRequired:2];
        [view addGestureRecognizer:doubleTag];
        
        UILongPressGestureRecognizer *longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
        [view addGestureRecognizer:longGesture1];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewPressed:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [view addGestureRecognizer:singleTap];
        [doubleTag release];
        [longGesture1 release];
        [singleTap release];
        [self addSubview:view];
        
        
    }
}


@end
