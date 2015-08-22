//
//  ChangePasswordViewController.h
//  P2PCamera
//
//  Created by Sharafat khan on 10/03/15.
//
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
//@property (retain, nonatomic) IBOutlet UIImageView *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtOldPassword;

- (IBAction)tapOnChangePassword:(id)sender;

@end
