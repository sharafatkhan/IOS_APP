//
//  MyVerticalScrollToolBar.h
//  P2PCamera
//
//  Created by Tsang on 14-4-8.
//
//

#import <UIKit/UIKit.h>


@protocol MyVerticalScrollToolBarDelegate<NSObject>
-(void)VerScrollBarClick:(int)type Index:(int)index;
@end
@interface MyVerticalScrollToolBar : UIView
{
   NSMutableArray *btnArr;
   id<MyVerticalScrollToolBarDelegate> delegate;
   int mType;
   UIScrollView *scrollView;
   
   
}
@property (nonatomic,assign)id<MyVerticalScrollToolBarDelegate> delegate;
@property int mType;



- (id)initWithFrame:(CGRect)frame Btn:(int)num BtnSpace:(float)space WithIphone:(BOOL)isPhone;
-(void)setBtnImag:(UIImage *)img Index:(int)index;
-(void)setBtnTitle:(NSString *)title Index:(int)index;
-(void)setBtnTitleColor:(UIColor*)color ForState:(UIControlState)state WithIndex:(int)index;
-(void)setBtnBackgroundColor:(UIColor *)color Index:(int)index;
-(void)setBtnSelected:(BOOL)flag Index:(int)index;
-(void)SetBtnEnable:(BOOL)flag WithIndex:(int)index;
@end
