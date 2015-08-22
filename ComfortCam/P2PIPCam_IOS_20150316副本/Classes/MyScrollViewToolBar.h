//
//  MyScrollViewToolBar.h
//  P2PCamera
//
//  Created by Tsang on 14-4-9.
//
//

#import <UIKit/UIKit.h>
@protocol MyScrollViewToolBarDelegate<NSObject>
-(void)scrollBarOnClicked:(int)index;
@end
@interface MyScrollViewToolBar : UIView
{
    id<MyScrollViewToolBarDelegate> delegate;
    UIImageView *imgViewBg;
    NSMutableArray *btnArr;
    UIScrollView *scrollView;
}
@property (nonatomic,assign)id<MyScrollViewToolBarDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithBtnNumber:(int)num;
-(void)setBtnTitle:(NSString*)title Index:(int)index;
-(void)setBtnTitleColor:(UIColor *)color ForStatus:(UIControlState)status Index:(int)index;
-(void)setBtnBackgroudImage:(UIImage*)img ForStatus:(UIControlState)status Index:(int)index;
-(void)setBtnSelected:(BOOL)flag  Index:(int)index;
-(void)setScrollToolBarBackgroudImage:(UIImage*)img;
-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index;
@end
