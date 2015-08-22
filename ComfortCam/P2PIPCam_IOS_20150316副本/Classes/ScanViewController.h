//
//  ScanViewController.h
//  二维码生成和扫描
//
//  Created by king on 14/12/31.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScanQRCodeResultDelegate<NSObject>
-(void)scanQRCodeResult:(NSString*)result;
@end
@interface ScanViewController : UIViewController
{
    id<ScanQRCodeResultDelegate>delegate;
}
@property (nonatomic,assign)id<ScanQRCodeResultDelegate>delegate;
@end
