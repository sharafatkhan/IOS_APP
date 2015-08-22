//
//  InAppAlertView.h
//  P2PCamera
//
//  Created by Sharafat khan on 16/03/15.
//
//

#import <UIKit/UIKit.h>

@interface InAppAlertView : UIView

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (retain, nonatomic) IBOutlet UILabel *lblSubscriptionMessage;
@property (retain, nonatomic) IBOutlet UILabel *lblSubsriptionTitle;


@end
