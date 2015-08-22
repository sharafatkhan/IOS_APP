//
//  KXStatusBar.h
//  IOSDemo
//
//  Created by Tsang on 14-6-25.
//  Copyright (c) 2014年 Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KXStatusBar : UIWindow
{
    UILabel *label;
}
-(void)showWithString:(NSString*)str;
@end
