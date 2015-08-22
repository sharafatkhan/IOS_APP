//
//  MyDialogView.h
//  P2PCamera
//
//  Created by Tsang on 13-4-17.
//
//

#import <UIKit/UIKit.h>
@protocol MyDialogViewDelegate<NSObject>
//@optional
-(void)dialogBtnClick:(int)index Tag:(int)tag;

@end
@interface MyDialogView : UIView
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    id<MyDialogViewDelegate> dialogDelegate;
    int tg;
}
@property (nonatomic,assign) id<MyDialogViewDelegate> dialogDelegate;
@property (nonatomic,retain) UIButton *btn1;
@property (nonatomic,retain) UIButton *btn2;
@property (nonatomic,retain) UIButton *btn3;
-(void)setTagClick:(int)tag;
@end
