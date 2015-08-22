//
//  KXDialog.h
//  P2PCamera
//
//  Created by Tsang on 14-6-27.
//
//

#import <UIKit/UIKit.h>
@protocol KXDialogDelegate<NSObject>
-(void)dialogHide;
@end
@interface KXDialog : UIView
{
    UIImageView *bgView;
    UILabel *label;
    UIView *pgView;
    int mNumber;
    NSTimer *mTimer;
    id<KXDialogDelegate>delegate;
    NSString *strText;
}
@property (nonatomic,assign) id<KXDialogDelegate>delegate;

- (id)initWithFrame:(CGRect)frame Msg:(NSString*)str;
-(void)show;
-(void)hide;
@end
