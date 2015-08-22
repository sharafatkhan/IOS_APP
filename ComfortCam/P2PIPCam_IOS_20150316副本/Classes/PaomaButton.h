//
//  PaomaButton.h
//  P2PCamera
//
//  Created by Tsang on 14-5-13.
//
//

#import <UIKit/UIKit.h>

@interface PaomaButton : UIButton
{
    UILabel *label;
    BOOL isStartedAnim;
    BOOL isNeedAnim;
    CGRect mainScreen;
    UILabel *bgLabel;
    int animDuration;
}

-(void)setMyFrame:(CGRect)frame;
-(void)setBtnTitle:(NSString*)title Color:(UIColor*)color;
-(void)setBtnTitleColor:(UIColor*)color;
-(void)startAnim;
@end
