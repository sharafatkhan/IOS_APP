//
//  MyUIGridView.h
//  MyIosAllDemo
//
//  Created by Tsang on 13-6-16.
//  Copyright (c) 2013年 Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyUIGridViewDelegate<NSObject>
-(CGFloat)heightForRow;
-(UIView *)cellFowColumn:(int)column;
-(int)getCellCount;
@end
@interface MyUIGridView : UIScrollView
{
    id<MyUIGridViewDelegate> myDelegate;
    int numColumns;
    float columnWidth;
    float verticalSpacing;
    float horizontalSpacing;
    float columnHeight;
    NSMutableDictionary *dicView;
}
@property (nonatomic,retain)NSMutableDictionary *dicView;
@property (nonatomic,assign)id<MyUIGridViewDelegate> myDelegate;
@property int numColumns;
@property float columnWidth;
@property float columnHeight;
@property float verticalSpacing;
@property float horizontalSpacing;
-(void)reloadGridViewData;
@end
