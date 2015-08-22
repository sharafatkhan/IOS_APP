//
//  InAppAlertView.m
//  P2PCamera
//
//  Created by Sharafat khan on 16/03/15.
//
//

#import "InAppAlertView.h"


@implementation InAppAlertView
@synthesize delegate, navigationController;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
     _lblSubscriptionMessage.text =  NSLocalizedStringFromTable(@"freeDays", @STR_LOCALIZED_FILE_NAME, nil);
    _lblSubsriptionTitle.text =  NSLocalizedStringFromTable(@"inApp", @STR_LOCALIZED_FILE_NAME, nil);
    // Drawing code
}



- (void)dealloc {
    [_lblSubscriptionMessage release];
    [_lblSubsriptionTitle release];
    [super dealloc];
}
@end
