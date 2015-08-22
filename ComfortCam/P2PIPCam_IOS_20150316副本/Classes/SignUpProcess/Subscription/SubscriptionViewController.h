//
//  SubscriptionViewController.h
//  P2PCamera
//
//  Created by Gourav Gupta on 07/03/15.
//
//

#import <UIKit/UIKit.h>
#import "IAPHelper.h"

@interface SubscriptionViewController : UIViewController<UINavigationBarDelegate, IAPHelperDelegate>
{
    int requestType;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UIScrollView *scrlView;

-(IBAction) tapOnMonthSubscription:(id) sender;
-(IBAction) tapOnYearSubscription:(id) sender;
@property (retain, nonatomic) IBOutlet UIView *bgViewStatusBar;


@end
