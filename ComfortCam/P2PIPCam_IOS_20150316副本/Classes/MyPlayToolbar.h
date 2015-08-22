//
//  MyPlayToolbar.h
//  P2PCamera
//
//  Created by Tsang on 14-4-11.
//
//

#import <UIKit/UIKit.h>
@protocol MyPlayToolbarDelegate<NSObject>
-(void)playToolbarClick:(int)type Index:(int)index;
-(void)playToolbarDownClick:(int)type Index:(int)index;
@end
@interface MyPlayToolbar : UIView
{
    UIScrollView *scrollView;
    UIImageView *imgViewBg;
    NSMutableArray *btnArr;
    NSMutableArray *btnSpaceArr;
    NSMutableArray *btnWidthArr;
    int mType;
    int mSpace;
    int mBtnNumber;
    int mAllWith;
    id<MyPlayToolbarDelegate>delegate;
    CGRect mainScreen;
    float remainSpace;
}
@property (nonatomic,assign)id<MyPlayToolbarDelegate>delegate;
@property int mType;
@property int mSpace;
- (id)initWithFrame:(CGRect)frame WithBtnNumber:(int)num;
-(void)SetBtnTitle:(NSString*)title WithIndex:(int)index;
-(void)SetBtnTitleColor:(UIColor *)color ForState:(UIControlState)state WithIndex:(int)index;
-(void)SetBtnBackgroudImage:(UIImage*)img ForState:(UIControlState)state WithIndex:(int)index;
-(void)SetBtnBackgroudColor:(UIColor*)color WithIndex:(int)index;
-(void)SetBtnImage:(UIImage*)img ForState:(UIControlState)state WithIndex:(int)index;
-(void)SetBtnSpace:(int)space WithIndex:(int)index;
-(void)SetBtnWidth:(int)width WithIndex:(int)index;
-(void)SetBtnSelect:(BOOL)flag WithIndex:(int)index;
-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index;

@end
