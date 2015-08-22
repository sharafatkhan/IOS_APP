//
//  MySetDialog.h
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import <UIKit/UIKit.h>
@protocol MySetDialogDelegate<NSObject>

-(void)mySetDialogOnClick:(int)tag Type:(int)type;

@end

@interface MySetDialog : UIView{
    NSMutableArray *btnArr;
    id<MySetDialogDelegate> diaDelegate;
    int mType;
}

@property (nonatomic,assign)id<MySetDialogDelegate> diaDelegate;
@property int mType;
@property (nonatomic,retain)NSMutableArray *btnArr;
- (id)initWithFrame:(CGRect)frame Btn:(int)num;
-(void)setBtnImag:(UIImage *)img Index:(int)index;
-(void)setBtnImag:(UIImage *)img Index:(int)index State:(UIControlState)state;
-(void)setBtnTitle:(NSString *)title Index:(int)index;
-(void)setBtnBackgroundColor:(UIColor *)color Index:(int)index;

-(void)setBtnSelected:(BOOL)flag Index:(int)index;

@end
