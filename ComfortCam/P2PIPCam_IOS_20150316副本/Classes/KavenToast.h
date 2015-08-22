//
//  KavenToast.h
//  P2PCamera
//
//  Created by Tsang on 14-5-4.
//
//

#import <UIKit/UIKit.h>

@interface KavenToast : UIView
{
    UILabel *label;
    CGRect mainScreen;
}
-(void)showWithText:(NSString*)title;
@end
