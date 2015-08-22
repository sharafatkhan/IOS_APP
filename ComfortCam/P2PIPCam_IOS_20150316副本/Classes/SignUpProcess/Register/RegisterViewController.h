//
//  RegisterViewController.h
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *txtFirstName;
@property (retain, nonatomic) IBOutlet UITextField *txtLastName;
@property (retain, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtConfirmEmail;

@property (retain, nonatomic) IBOutlet UIScrollView *scrlViewRegister;
@property (retain, nonatomic) IBOutlet UIButton *btnRegister;



- (IBAction)clickedRegister:(id)sender;
- (IBAction)clickedBack:(id)sender;

@end
