//
//  ForgotPasswordViewController.m
//  P2PCamera
//
//  Created by MonuRathor on 11/01/15.
//
//

#import "ForgotPasswordViewController.h"
#import "RequestClass.h"
#import "obj_common.h"
#import "IpCameraClientAppDelegate.h"


@interface ForgotPasswordViewController ()<RequestClassDelegate, UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *btnEmail;
@property (nonatomic, retain) RequestClass *connection;
@end

@implementation ForgotPasswordViewController

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
    _txtEmail.placeholder = NSLocalizedStringFromTable(@"email", @STR_LOCALIZED_FILE_NAME, nil);
    [_btnEmail setTitle:NSLocalizedStringFromTable(@"Send", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
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
    
    self.title = NSLocalizedStringFromTable(@"Forget_Password", @STR_LOCALIZED_FILE_NAME, nil);
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtEmail becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtEmail release];
    [_connection release];
    [_btnEmail release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtEmail:nil];
    [self.connection stopConnection];
    [super viewDidUnload];
}

-(void) forgotPassword
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingView];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"FORGOT_PASSWORD" forKey:@"action"];
    [param setValue:self.txtEmail.text forKey:@"email"];
    [self.connection makePostRequestFromDictionary:param];

}

- (IBAction)clickedSendMail:(id)sender
{
    if (self.txtEmail.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"insert_email", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [self.txtEmail becomeFirstResponder];
    }else
    {
       [self forgotPassword];
    }
}

- (IBAction)clickedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -  Response Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];
    if (!error)
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDict = (NSDictionary *) result;
            NSString *strResponse = [resultDict valueForKey:@"response"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strResponse delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
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
            [textField resignFirstResponder];
            [self forgotPassword];
            break;
        
        default:
            break;
    }
    return YES;
}

#pragma mark -  AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if ([alertView.message isEqualToString:@"Password successfully sent to your email"])
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

@end
