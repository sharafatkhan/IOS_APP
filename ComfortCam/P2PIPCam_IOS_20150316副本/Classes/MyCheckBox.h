//
//  MyCheckBox.h
//  P2PCamera
//
//  Created by Tsang on 14-4-8.
//
//

#import <UIKit/UIKit.h>
typedef enum CheckBoxTitleStyle_{
    CheckBoxTitleTop=0,
    CheckBoxTitleBottom,
    CheckBoxTitleLeft,
    CheckBoxTitleRight
}CheckBoxTitleStyle;
@protocol  MyCheckBoxDelegate<NSObject>
-(void)statusChanged:(BOOL)isChecked Tag:(int)tag;
@end
@interface MyCheckBox : UIView
{
    CheckBoxTitleStyle titleStyle;
    id<MyCheckBoxDelegate> delegate;
    UIImageView *imgViewBg;
    UILabel *titleLabel;
    int myTag;
    BOOL checked;
    NSString *titleText;
    CGRect mainScreen;
}

@property (nonatomic,retain)id<MyCheckBoxDelegate> delegate;
@property (nonatomic,copy)NSString *titleText;
@property BOOL checked;

- (id) initWithFrame:(CGRect)frame Checked:(BOOL)checked;
-(void)setMyChecked:(BOOL)flag;
@end
