//
//  RegisterViewController.m
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import "RegisterViewController.h"
#import "RequestClass.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"

@interface RegisterViewController ()<RequestClassDelegate, UIAlertViewDelegate>
{
    UITextField *activeTextField;
    CGSize keyboardSize;
}

@property (nonatomic, retain) RequestClass *connection;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setLanguageData
{
    _txtEmailAddress.placeholder = NSLocalizedStringFromTable(@"emailaddress", @STR_LOCALIZED_FILE_NAME, nil);
    _txtConfirmEmail.placeholder = NSLocalizedStringFromTable(@"confirmemailaddress", @STR_LOCALIZED_FILE_NAME, nil);
    _txtConfirmPassword.placeholder = NSLocalizedStringFromTable(@"confirmpassword", @STR_LOCALIZED_FILE_NAME, nil);
    _txtFirstName.placeholder = NSLocalizedStringFromTable(@"firstname", @STR_LOCALIZED_FILE_NAME, nil);
    _txtLastName.placeholder = NSLocalizedStringFromTable(@"lastname", @STR_LOCALIZED_FILE_NAME, nil);
    _txtPassword.placeholder = NSLocalizedStringFromTable(@"hintPassword", @STR_LOCALIZED_FILE_NAME, nil);
    _txtPhoneNumber.placeholder = NSLocalizedStringFromTable(@"phonenumber", @STR_LOCALIZED_FILE_NAME, nil);

    [_btnRegister setTitle: NSLocalizedStringFromTable(@"register", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLanguageData];
    
    self.connection = [[RequestClass alloc] init];
    self.connection.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.title = NSLocalizedStringFromTable(@"Sign_Up", @STR_LOCALIZED_FILE_NAME, nil);
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self.txtFirstName becomeFirstResponder];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtFirstName release];
    [_txtLastName release];
    [_txtEmailAddress release];
    [_txtPhoneNumber release];
    [_txtPassword release];
    [_txtConfirmPassword release];
    [_connection release];
    [_scrlViewRegister release];
    [_txtConfirmEmail release];
    [_btnRegister release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtFirstName:nil];
    [self setTxtLastName:nil];
    [self setTxtEmailAddress:nil];
    [self setTxtPhoneNumber:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
    [self.connection stopConnection];
    [self setScrlViewRegister:nil];
    [super viewDidUnload];
}
- (IBAction)clickedRegister:(id)sender
{
    [self registerMe];
}

- (IBAction)clickedBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) registerMe
{
    
    
    if ((self.txtFirstName.text.length == 0 && self.txtLastName.text.length == 0 && self.txtEmailAddress.text.length == 0 && self.txtConfirmEmail.text.length == 0)  && self.txtPassword.text.length == 0 && self.txtConfirmPassword.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"mandatory", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (self.txtFirstName.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your first name", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if (self.txtLastName.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your last name", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if (self.txtEmailAddress.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your email address", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if (self.txtConfirmEmail.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your confirm email address", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
//    else if (self.txtPhoneNumber.text.length == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:@"Please fill in your phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    else if (self.txtPassword.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your password", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if (self.txtConfirmPassword.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Please fill in your confirm password", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
//    else if (!isEmailValid(self.txtEmailAddress.text))
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:@"Please fill valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        [self.txtEmailAddress becomeFirstResponder];
//    }
    else if (![self.txtEmailAddress.text isEqualToString:self.txtConfirmEmail.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Email & confirm email fields do not match", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"Password & confirm password fields do not match", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        
               
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"SIGN_UP" forKey:@"action"];
        [param setValue:self.txtFirstName.text forKey:@"first_name"];
        [param setValue:self.txtLastName.text forKey:@"last_name"];
        [param setValue:self.txtEmailAddress.text forKey:@"email"];
        [param setValue:(self.txtPhoneNumber.text.length>0)?self.txtPhoneNumber.text:@"" forKey:@"contact"];
        [param setValue:self.txtPassword.text forKey:@"password"];
        [param setValue:self.txtConfirmPassword.text forKey:@"confirm_password"];
        [self.connection makePostRequestFromDictionary:param];
    }
    
    
}

- (void)connectionSuccess:(id)result andError:(NSError *)error
{    
    if (!error)
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
//            NSDictionary *resultDict = (NSDictionary *) result;
            NSString *strResponse;// = [resultDict valueForKey:@"response"];
            strResponse = NSLocalizedStringFromTable(@"successfully_registered", @STR_LOCALIZED_FILE_NAME, nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strResponse delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -  Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag)
    {
        case FirstName:
            [self.txtLastName becomeFirstResponder];
            break;
        case LastName:
            [self.txtEmailAddress becomeFirstResponder];
            break;
        case Email:
            [self.txtConfirmEmail becomeFirstResponder];
            break;
//        case ConfirmEmail:
//            [self.txtPhoneNumber becomeFirstResponder];
//            break;
        case Phone:
            [self.txtPassword becomeFirstResponder];
            break;
        case Password:
            [self.txtConfirmPassword becomeFirstResponder];
            break;
        case ConfirmPass:
            [textField resignFirstResponder];
            NSLog(@"Save data");
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    if (!CGSizeEqualToSize(CGSizeZero, keyboardSize))
    {
        // do something
        [self adjustScrollView];
    }
    
    
    
    NSLog(@"%d",textField.tag);
    return YES;
}



//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    NSLog(@"%d",textField.tag);
//    return YES;
//}

#pragma mark -  AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if ([alertView.message isEqualToString:@"User registered successfully"])
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - Keyboard method

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldDidBeginEditing::)
//                                                 name:UITextFieldTextDidBeginEditingNotification
//                                               object:nil];
    
//    UITextFieldTextDidBeginEditingNotification
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(void) adjustScrollView
{
    UIView *textFieldView = activeTextField.superview;
    CGPoint viewOrigin = CGPointMake(CGRectGetMaxX(textFieldView.frame), CGRectGetMaxY(textFieldView.frame));
    CGFloat viewHeight = textFieldView.frame.size.height;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height ;
    
    if (!CGRectContainsPoint(visibleRect, viewOrigin))
    {
        
        CGPoint scrollPoint = CGPointMake(0.0, viewOrigin.y - visibleRect.size.height + viewHeight);
        
        if (scrollPoint.y >= 0)
        {
            [self.scrlViewRegister setContentOffset:scrollPoint animated:YES];
        }
        
        
    }
    
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    NSDictionary* info = [notification userInfo];
    
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    [self adjustScrollView];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [self.scrlViewRegister setContentOffset:CGPointZero animated:YES];
    
}


@end
