//
//  ForgotPasswordViewController.h
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)clickedSendMail:(id)sender;
- (IBAction)clickedBack:(id)sender;

@end
