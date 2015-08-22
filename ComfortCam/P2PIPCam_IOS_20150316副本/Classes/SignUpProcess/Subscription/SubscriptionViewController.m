//
//  SubscriptionViewController.m
//  P2PCamera
//
//  Created by Gourav Gupta on 07/03/15.
//
//

#import "SubscriptionViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "obj_common.h"
#import "RequestClass.h"

#define loginRequest 1
#define subscriptionRequest 2

@interface SubscriptionViewController ()<RequestClassDelegate>
{
    IAPHelper *objInApp;
    NSString *strSubscriptionType;
    BOOL isIOS7;
    BOOL isSubscriptionDone;

}
@property (retain, nonatomic) IBOutlet UILabel *lblTry;
@property (retain, nonatomic) IBOutlet UILabel *lblComfortCamPlus;
@property (retain, nonatomic) IBOutlet UILabel *lblMonthly;

@property (retain, nonatomic) IBOutlet UILabel *lblRemote;
@property (retain, nonatomic) IBOutlet UILabel *lblBenifit;
@property (retain, nonatomic) IBOutlet UILabel *lblCancel;

@property (retain, nonatomic) IBOutlet UILabel *lblFree;
@property (retain, nonatomic) IBOutlet UILabel *lblChoose;
@property (nonatomic, retain) RequestClass *connection;
@end

@implementation SubscriptionViewController
@synthesize connection;


- (void)setLanguageData
{
    _lblTry.text = NSLocalizedStringFromTable(@"Try_ComfortCam", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblComfortCamPlus.text = NSLocalizedStringFromTable(@"ComfortCam_Plus", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblMonthly.text = NSLocalizedStringFromTable(@"Monthly_service", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblRemote.text = NSLocalizedStringFromTable(@"remote_viewing", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblBenifit.text = NSLocalizedStringFromTable(@"Benefits", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblCancel.text = NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblFree.text = NSLocalizedStringFromTable(@"Free", @STR_LOCALIZED_FILE_NAME, nil);
    
    _lblChoose.text = NSLocalizedStringFromTable(@"Choose", @STR_LOCALIZED_FILE_NAME, nil);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CGSize scrlContentSize = CGSize
    self.scrlView.contentSize = CGSizeMake(self.scrlView.frame.size.width, 400.0);
    
    self.connection = [[RequestClass alloc] init];
    self.connection.delegate = self;
    
    [self setLanguageData];
    
    NSString *strTitle;
        strTitle = NSLocalizedStringFromTable(@"Service", @STR_LOCALIZED_FILE_NAME, nil);

    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:0.5];
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= strTitle;
    item.titleView=labelTile;
    [labelTile release];
    //创建一个右边按钮
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [btnRight setTitle:NSLocalizedStringFromTable(@"Not_now", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.frame=CGRectMake(0,0,70,30);
    [btnRight addTarget:self action:@selector(btnFinished) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    
//    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
//    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
//    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
//    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
//    btnLeft.frame=CGRectMake(0,0,60,30);
//    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
////    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    
    item.rightBarButtonItem = rightButton;
//    item.leftBarButtonItem=leftButton;
    [rightButton release];
    
    NSArray *array = [NSArray arrayWithObjects:item, nil];
    [self.navigationBar setItems:array];
    
    [item release];
    [back release];
    
    
//    if ([IpCameraClientAppDelegate isIOS7Version]) {
//        NSLog(@"is ios7");
//        self.wantsFullScreenLayout = YES;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        
//        CGRect navigationBarFrame = self.navigationBar.frame;
//        navigationBarFrame.origin.y += 20;
//        self.navigationBar.frame = navigationBarFrame;
//        [self.view bringSubviewToFront:self.navigationBar];
//        
//        CGRect tableFrm=tableView.frame;
//        tableFrm.origin.y+=20;
//        tableView.frame=tableFrm;
//        self.view.backgroundColor=[UIColor blackColor];
//        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
//    }else{
//        NSLog(@"less ios7");
//        
//    }
//    
//    
//    if (bAddCamera == NO) {
//        self.strOldDID = self.strCameraID;
//        self.strOldIp=self.strCameraIp;
//    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=self.view.frame;
    imgView.center=self.view.center;
    self.view.backgroundColor= [UIColor colorWithPatternImage:imgView.image];
    [imgView release];
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
//        CGRect tableFrm=cameraList.frame;
//        tableFrm.origin.y+=20;
//        cameraList.frame=tableFrm;
//        self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
//        cameraList.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        
    }else{
        self.bgViewStatusBar.hidden = YES;
        isIOS7=NO;
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)btnFinished{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_navigationBar release];
    [_scrlView release];
    [_bgViewStatusBar release];
    [_lblTry release];
    [_lblRemote release];
    [_lblFree release];
    [_lblChoose release];
    [_lblBenifit release];
    [_lblCancel release];
    [_lblComfortCamPlus release];
    [_lblMonthly release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setScrlView:nil];
    [self setBgViewStatusBar:nil];
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction) tapOnMonthSubscription:(id) sender
{
    
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingView];
    
    NSLog(@"Purchase 1 month subscription");
    objInApp = [[IAPHelper alloc]init];
    objInApp.delegate = self;
    [objInApp purchaseLessionWithLessonProduct:kPRODUCT_TYPE_MONTH];
    
    strSubscriptionType = kPRODUCT_TYPE_MONTH;
}

-(IBAction) tapOnYearSubscription:(id) sender

{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingView];
    NSLog(@"Purchase 1 year subscription");
    objInApp = [[IAPHelper alloc]init];
    objInApp.delegate = self;
    [objInApp purchaseLessionWithLessonProduct:kPRODUCT_TYPE_YEAR];
        strSubscriptionType = kPRODUCT_TYPE_YEAR;
}

#pragma mark- In App Purchase Delegate -

- (void)completePayment:(SKPaymentTransaction *)transaction
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ProductPurchase"];
    //    [ProgressHUD dismiss];
    
    if (!isSubscriptionDone) {
        
        isSubscriptionDone = YES;
        int subscriptionTypeNo = 0;
        if ([strSubscriptionType isEqualToString:kPRODUCT_TYPE_MONTH])
        {
            subscriptionTypeNo = 1;
        }
        else
        {
            subscriptionTypeNo = 2;
        }
        
        NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"SUBSCRIBED" forKey:@"action"];
        [param setValue:strUserName forKey:@"email"];
        [param setValue:[NSNumber numberWithInt:subscriptionTypeNo] forKey:@"subscription_type"];
        requestType = subscriptionRequest;
        [self.connection makePostRequestFromDictionary:param];
        
    }
}
- (void)restoredPayment:(SKPaymentTransaction *)transactions
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ProductPurchase"];
//    [ProgressHUD dismiss];
}
- (void)failedPayment:(SKPaymentTransaction *)transaction
{
    IpCameraClientAppDelegate *appDelegate = (IpCameraClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoadingView];
//    [ProgressHUD dismiss];
}

#pragma mark -  Request Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    if (!error)
    {
        switch (requestType)
        {
            case loginRequest:
            {
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = [result valueForKey:@"response"];
                    NSInteger isSubscribed = [[dictResponse valueForKey:@"isSubscribed"] intValue];
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:isSubscribed forKey:@"isUserSubscribed"];
                    
                    if (![[dictResponse valueForKey:@"subscriptionEndDate"] isKindOfClass:[NSNull class]]) {
                        NSString *str = [dictResponse valueForKey:@"subscriptionEndDate"];
                        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"subscriptionEndDate"];
                    }
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
                break;
            case subscriptionRequest:
            {
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = (NSDictionary *) result;
                    if ([[dictResponse valueForKey:@"code"] intValue] == 200 &&  [[dictResponse valueForKey:@"status"] isEqualToString:@"OK"])
                    {
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isUserSubscribed"];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedStringFromTable(@"subscribed_successfully", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
                        alert.tag = 999;
                        [alert show];
                        [alert release];
                    }
                }
            }
                break;
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Error1", @STR_LOCALIZED_FILE_NAME, nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void) validateUser
{
    NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    NSString *strUserPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPassword"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"LOGIN" forKey:@"action"];
    [param setValue:strUserName forKey:@"email"];
    [param setValue:strUserPassword forKey:@"password"];
    [param setValue:@"2" forKey:@"platform"];
    requestType = loginRequest;
    [self.connection makePostRequestFromDictionary:param];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(alertView.tag == 999 )
    {
        [self validateUser];
    }
}

@end
