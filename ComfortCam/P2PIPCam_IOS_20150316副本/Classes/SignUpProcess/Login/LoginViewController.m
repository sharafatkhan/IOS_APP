//
//  LoginViewController.m
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import "LoginViewController.h"
#import "RequestClass.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "ChangePasswordViewController.h"

@interface LoginViewController ()<RequestClassDelegate, UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *btnRemember;
@property (retain, nonatomic) IBOutlet UIImageView *imgRememberme;
@property (nonatomic, retain) RequestClass *connection;
@end

@implementation LoginViewController

- (void)setLanguageData
{
    _txtEmail.placeholder = NSLocalizedStringFromTable(@"hintemail", @STR_LOCALIZED_FILE_NAME, nil);
    _txtPassword.placeholder = NSLocalizedStringFromTable(@"hintPassword", @STR_LOCALIZED_FILE_NAME, nil);
    _lblRememberMe.text = NSLocalizedStringFromTable(@"rememberme", @STR_LOCALIZED_FILE_NAME, nil);
    [_btnForgetPwd setTitle: NSLocalizedStringFromTable(@"forgotpass", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [_btnLogin setTitle: NSLocalizedStringFromTable(@"login", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [_btnSignUp setTitle: NSLocalizedStringFromTable(@"signup", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLanguageData];
    self.connection = [[RequestClass alloc] init];
    self.connection.delegate = self;
    // Do any additional setup after loading the view from its nib.
    

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberME"] == YES)
    {
        NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        NSString *strUserPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPassword"];
        
        _txtEmail.text = strUserName;
        _txtPassword.text = strUserPassword;
        _btnRemember.selected = YES;
        [_imgRememberme setImage:[UIImage imageNamed:@"check"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtEmail release];
    [_txtPassword release];
    [_connection release];
    [_imgRememberme release];
    [_btnRemember release];
    [_lblRememberMe release];
    [_btnForgetPwd release];
    [_btnSignUp release];
    [_btnLogin release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtEmail:nil];
    [self setTxtPassword:nil];
    [self.connection stopConnection];
    [self setImgRememberme:nil];
    [self setBtnRemember:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)clickedSignUp:(id)sender {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else
    {
        RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

- (IBAction)clickedForgotPassword:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        ForgotPasswordViewController *fpvc = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:fpvc animated:YES];
    }
    else
    {
        ForgotPasswordViewController *fpvc = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:fpvc animated:YES];
    }
 
}



-(void) login
{
    
    if (self.txtEmail.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"fill_in_username", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self.txtEmail becomeFirstResponder];
    }
    else if (self.txtPassword.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"fill_in_password", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self.txtPassword becomeFirstResponder];
    }
//    else if (!isEmailValid(self.txtEmail.text))
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:@"Please fill valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        [self.txtEmail becomeFirstResponder];
//    }
    else
    {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"LOGIN" forKey:@"action"];
        [param setValue:self.txtEmail.text forKey:@"email"];
        [param setValue:self.txtPassword.text forKey:@"password"];
        [param setValue:@"2" forKey:@"platform"];
        [self.connection makePostRequestFromDictionary:param];
    }
    
    
    
}

- (IBAction)clickedLogin:(id)sender
{
    [self login];
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -  Request Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    if (!error)
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictResponse = [result valueForKey:@"response"];
            int tempUserValue = [[dictResponse valueForKey:@"isTemp"] intValue];
            if (tempUserValue == 1)
            {
                if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
                    ChangePasswordViewController *rvc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
                    [self.navigationController pushViewController:rvc animated:YES];
                    
                }else
                {
                    ChangePasswordViewController *rvc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController_iPad" bundle:nil];
                    [self.navigationController pushViewController:rvc animated:YES];
                }
            }
            else
            {
                NSDictionary *dictResponse = [result valueForKey:@"response"];
                NSInteger isSubscribed = [[dictResponse valueForKey:@"isSubscribed"] intValue];
                
                [[NSUserDefaults standardUserDefaults] setInteger:isSubscribed forKey:@"isUserSubscribed"];
                
                if (![[dictResponse valueForKey:@"subscriptionEndDate"] isKindOfClass:[NSNull class]]) {
                    NSString *str = [dictResponse valueForKey:@"subscriptionEndDate"];
                    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"subscriptionEndDate"];
                }   
                
                if (_btnRemember.selected)
                {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberME"];
                }else{
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberME"];
                }
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIN"];
                
                [[NSUserDefaults standardUserDefaults] setValue:self.txtEmail.text forKey:@"UserName"];
                [[NSUserDefaults standardUserDefaults] setValue:self.txtPassword.text forKey:@"UserPassword"];
                
                IpCameraClientAppDelegate *IPCamDelegate =  [[UIApplication sharedApplication] delegate] ;
                [IPCamDelegate changeP2PAndDDNS:YES];
            }
            
        }
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Error1", @STR_LOCALIZED_FILE_NAME, nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -  Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag)
    {
        case Email:
            [self.txtPassword becomeFirstResponder];
            break;
        case Password:
            [textField resignFirstResponder];
            [self login];
            NSLog(@"Save data");
            break;
        default:
            break;
    }
    return YES;
}
- (IBAction)onBtnRemeberMe:(id)sender {
    
    _btnRemember.selected =! _btnRemember.selected;
    if (_btnRemember.selected) {
        [_imgRememberme setImage:[UIImage imageNamed:@"check"]];
    }else
    {
        [_imgRememberme setImage:[UIImage imageNamed:@"uncheck"]];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
