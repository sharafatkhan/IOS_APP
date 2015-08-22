//
//  UserPwdSetViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPwdSetViewController.h"
#import "obj_common.h"
#import "CameraInfoCell.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"


// Code Begin
#import "RequestClass.h"

#define OperatorRequest 1
#define VisitorRequest  2
// Code Ends

static const double PageViewControllerTextAnimationDuration = 0.33;


//  Code Begins
@interface UserPwdSetViewController ()<RequestClassDelegate>
{
    
    int requestType;
    BOOL isOperatorChanged, isVisitorChanged;
    BOOL isOkToPopHome;
    
}
@property (nonatomic, retain) RequestClass *connection;
@end
//  Code Ends

@implementation UserPwdSetViewController

@synthesize m_pChannelMgt;
@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize textUser;
@synthesize textPassword;
@synthesize textOperPwd;
@synthesize textOperUser;
@synthesize isSetOver;
@synthesize tableView;
@synthesize navigationBar;
@synthesize currentTextField;

@synthesize m_user1;
@synthesize m_pwd1;
@synthesize m_user2;
@synthesize m_pwd2;

@synthesize m_strDID;

@synthesize isP2P;
@synthesize netUtiles;
@synthesize m_strIp;
@synthesize m_strPort;
@synthesize m_User;
@synthesize m_Pwd;

@synthesize m_strName;
@synthesize mModal;
@synthesize cameraListMgt;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_strUser = @"";
        m_strPwd=@"";
        m_user1=@"";
         m_user2=@"";
        m_pwd2=@"";
        m_pwd1=@"";
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnSetUserPwd:(id)sender
{
    
    if (textUser!= nil) {
        [textUser resignFirstResponder];
    }
    if (textPassword != nil) {
        [textPassword resignFirstResponder];
    }    
    if (textOperPwd!=nil) {
        [textOperPwd resignFirstResponder];
    }
    if (textOperUser!=nil) {
        [textOperUser resignFirstResponder];
    }
    if (currentTextField!=nil) {
        [currentTextField resignFirstResponder];
    }
    if ([m_strUser length ]<=0) {
         [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputUserName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    NSString * regex = @"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:m_strUser];
    if (!isMatch) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"setuser_nomatch", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if ([m_strPwd length]!=0) {
        isMatch = [pred evaluateWithObject:m_strPwd];
        if (!isMatch) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"setuser_nomatch", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }
    if ([m_user1 length]!=0) {
        isMatch = [pred evaluateWithObject:m_user1];
        if (!isMatch) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"setuser_nomatch", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }
    if ([m_pwd1 length]!=0) {
        isMatch = [pred evaluateWithObject:m_pwd1];
        if (!isMatch) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"setuser_nomatch", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }
    
    if ([m_strUser caseInsensitiveCompare:@"user"]==NSOrderedSame||[m_strUser caseInsensitiveCompare:@"loginuser"]==NSOrderedSame) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"nouserorloginuser", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    

    
    if ([m_user1 length]!=0) {
        if ([m_user1 caseInsensitiveCompare:@"user"]==NSOrderedSame||[m_user1 caseInsensitiveCompare:@"loginuser"]==NSOrderedSame) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"nouserorloginuser", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }
    
 
    
    
    if (isP2P) {
        m_pChannelMgt->SetUserPwd((char*)[m_strDID UTF8String], (char*)[m_user1 UTF8String], (char*)[m_pwd1 UTF8String], (char*)[m_user2 UTF8String], (char*)[m_pwd2 UTF8String], (char*)[m_strUser UTF8String], (char*)[m_strPwd UTF8String]);
        
        if (mModal!=1) {
             m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
        }
       
        
    }else{
        [netUtiles setUserpwd:m_strIp Port:m_strPort User1:m_user1 Pwd1:m_pwd1 User2:m_user2 Pwd2:m_pwd2 User3:m_strUser Pwd3:m_strPwd User:m_User Pwd:m_Pwd];
        [netUtiles setRoot:m_strIp Port:m_strPort CGI:@"" User:m_User  Pwd:m_Pwd];
    }
    isSetOver=YES;
    
    
    BOOL ret= [cameraListMgt EditCamera:m_strDID Name:m_strName DID:m_strDID User:m_strUser Pwd:m_strPwd];
        if (ret) {
            NSLog(@"User edit  user  successful");
        }else{
            NSLog(@"User edit  user  failed");
        }
    
    
    IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:m_strDID,@"did",[NSNumber numberWithBool:NO],@"flag", nil];
    [delegate deleteDeviceFromBizServer:dic2];
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:m_strDID,@"did",m_strName,@"name",m_strUser,@"user",m_strPwd,@"pwd", nil];
    [delegate addDeviceToBizServer:dic];

    [self.navigationController popToRootViewControllerAnimated:YES];

    //  Code Begins
    [self setOperatorAndVisitor];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //  Code Ends
}

//  Code Begins
-(void) setOperatorAndVisitor
{
    isOkToPopHome = YES;  // Means it is not Ok to pop untill response received
    if (isOperatorChanged)
    {
        NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"CAMERA_ACCESS_ADD" forKey:@"action"];
        [param setValue:strUserName forKey:@"email"];
        
        [param setValue:self.m_user2 forKey:@"access_userid"];
        [param setValue:self.m_pwd2 forKey:@"password"]; //camera_id
        
        [param setValue:self.m_strDID forKey:@"camera_id"];
        [param setValue:@1 forKey:@"access_type"]; // Operator
        
        [self.connection makePostRequestFromDictionary:param];
        requestType = OperatorRequest;
    }
    else if (isVisitorChanged)
    {
        NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"CAMERA_ACCESS_ADD" forKey:@"action"];
        [param setValue:strUserName forKey:@"email"];
        
        [param setValue:self.m_user1 forKey:@"access_userid"];
        [param setValue:self.m_pwd1 forKey:@"password"]; //camera_id
        
        [param setValue:self.m_strDID forKey:@"camera_id"];
        [param setValue:@0 forKey:@"access_type"]; // Operator
        
        [self.connection makePostRequestFromDictionary:param];
        requestType = VisitorRequest;
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

//  Code Ends



- (void)viewDidLoad
{
    [super viewDidLoad];
    oldtableFrame=tableView.frame;
    // Do any additional setup after loading the view from its nib.
    isSetOver=NO;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"UserSetting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
   
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= strTitle;
    item.titleView=labelTile;
    [labelTile release];
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnSetUserPwd:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem=leftButton;
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=tableView.frame;
        tableFrm.origin.y+=20;
        tableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        
        UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [titlelabel setText:strTitle];
        [titlelabel setTextColor:[UIColor whiteColor]];
        titlelabel.font=[UIFont boldSystemFontOfSize:18];
        item.titleView=titlelabel;
        [titlelabel release];
        
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    [rightButton release];
    [leftButton release];
    [item release];

    
    
    
    
    
    
    if (isP2P) {
        m_pChannelMgt->SetUserPwdParamDelegate((char*)[m_strDID UTF8String], self);
        m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
        NSLog(@"user....isp2p");
    }else{
       // netUtiles.userProtocol=self;
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd ParamType:3];
        NSLog(@"user....nop2p");
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}


#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    NSLog(@"keyboardWillShowNotification");
    
    CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		
		//
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid
		// deprecated warnings in the compiler.
		//
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
                        convertRect:keyboardRect
                        fromView:topLevelView];
	}
	
	CGRect viewFrame = self.tableView.frame;
    NSLog(@"viewFrame.origin.y=%f",viewFrame.origin.y);

	textFieldAnimatedDistance = 0;
    //	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
    //	{
    textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
    NSLog(@"textFieldAnimatedDistance=%f",textFieldAnimatedDistance);
    textFieldAnimatedDistance=keyboardRect.origin.y+44;
    NSLog(@"viewFrame.height_old=%f",viewFrame.size.height);
    viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
    

   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];
    //	}
    
    //    NSLog(@"currentTextField: %f, %f, %f, %f",currentTextField.bounds.origin.x, currentTextField.bounds.origin.y, currentTextField.bounds.size.height, currentTextField.bounds.size.width);
    
	const CGFloat PageViewControllerTextFieldScrollSpacing = 10;
    
	CGRect textFieldRect =
    [self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
    
    NSArray *rectarray = [self.tableView indexPathsForRowsInRect:textFieldRect];
    if (rectarray <= 0) {
        NSLog(@"rectarray,=0");
        return;
    }
    
    //    NSIndexPath * indexPath = [rectarray objectAtIndex:0];
    //    NSLog(@"row: %d", indexPath.row);
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	//[self.tableView scrollRectToVisible:textFieldRect animated:NO];
    
    switch (textfield_tg) {
        case 2:
            if (![IpCameraClientAppDelegate is43Version]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                textfield_tg=-1;
            }
             
            break;
        case 3:
            if (![IpCameraClientAppDelegate is43Version]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                textfield_tg=-1;
            }
             
            break;
        default:
            break;
    }
   

}

- (void)keyboardWillHideNotification:(NSNotification* )aNotification
{
    //NSLog(@"keyboardWillHideNotification");
    
    if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.tableView.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}

//test
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    oldtableFrame=tableView.frame;
     
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    //CGRect newFrame=tableView.frame;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    //newFrame.size.height=keyboardTop-newFrame.origin.y;
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    switch (textfield_tg) {
        case 2:
        case 3:
            [tableView setContentOffset:CGPointMake(0,50) animated:YES];
            tableView.frame = newTextViewFrame;
            break;
        case 4:
            [tableView setContentOffset:CGPointMake(0,120) animated:YES];
            tableView.frame = newTextViewFrame;
            break;
        case 5:
            [tableView setContentOffset:CGPointMake(0,170) animated:YES];
            tableView.frame = newTextViewFrame;
            break;
    }
    textfield_tg=-1;
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
//    NSDictionary* userInfo = [notification userInfo];
//    
//    /*
//     Restore the size of the text view (fill self's view).
//     Animate the resize so that it's in sync with the disappearance of the keyboard.
//     */
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
   // tableView.frame = self.view.bounds;
    tableView.frame=oldtableFrame;
    [UIView commitAnimations];
}
//test


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(popToHome:)
     name:@"statuschange"
     object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,m_strDID);
    if ([m_strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    m_pChannelMgt->SetUserPwdParamDelegate((char*)[m_strDID UTF8String], nil);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc{
    if (isP2P) {
         m_pChannelMgt->SetUserPwdParamDelegate((char*)[m_strDID UTF8String], nil);
        m_pChannelMgt=nil;
    }else{
        netUtiles.userProtocol=nil;
        netUtiles=nil;
    }
   
    self.m_strUser=nil;
    self.m_strPwd=nil;
    self.m_user1=nil;
    self.m_pwd1=nil;
    self.m_user2=nil;
    self.m_pwd2=nil;
    
    
//    if (m_strUser!=nil) {
//        [m_strUser release];
//    }
//    if (m_strPwd!=nil) {
//        [m_strPwd release];
//    }
//    
//    if (m_user1!=nil) {
//        [m_user1 release];
//    }
//    if (m_pwd1!=nil) {
//        [m_pwd1 release];
//    }
//    if (m_user2!=nil) {
//        [m_user2 release];
//    }
//    if (m_pwd2!=nil) {
//        [m_pwd2 release];
//    }
    
    
    self.m_pChannelMgt = nil;
    self.m_strUser = nil;
    self.m_strPwd = nil;
    self.textPassword = nil;
    self.textUser = nil;
    self.textOperUser=nil;
    self.textOperPwd=nil;
    self.navigationBar = nil;
    self.m_strDID = nil;
    self.m_user1 = nil;
    self.m_pwd1 = nil;
    self.m_user2 = nil;
    self.m_pwd2 = nil;
    self.tableView = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title=nil;
    switch (section) {
        case 0:
            title= NSLocalizedStringFromTable(@"useradmin", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 1:
            title= NSLocalizedStringFromTable(@"userOperator", @STR_LOCALIZED_FILE_NAME, nil);

            break;
        case 2:
            title= NSLocalizedStringFromTable(@"uservisitor", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            break;
    }
    return title;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    
    NSString *cellIdentifier1 = @"UserPwdCell";
    UITableViewCell *cell =nil;
    NSInteger section=anIndexPath.section;
    NSInteger row = anIndexPath.row;
     CameraInfoCell * cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if ([IpCameraClientAppDelegate isiPhone]) {
        if (cell1==nil) {
            UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
            [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
            cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        }
    }else{
        if (cell1==nil) {
            UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
            [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
            cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        }
    }
    switch (section) {
        case 0:
            
            switch (row) {
                case 0:
                {
                   
                    
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.text = self.m_strUser;
                    //[cell.textField setEnabled: NO];
                    cell1.textField.secureTextEntry=NO;
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 0;
                    cell=cell1;
                }
                    break;
                case 1:
                {
                    
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                  
                     cell1.textField.secureTextEntry = YES;
                   
                    
                    cell1.textField.text = self.m_strPwd;
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 1;
                    cell=cell1;
                }
                    break;
                    
                default:
                    break;
            }

            break;
        case 1:
            
            switch (row) {
                case 0:
                {
                    
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.text = self.m_user2;
                    cell1.textField.secureTextEntry=NO;
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 2;
                    cell=cell1;
                }
                    break;
                case 1:
                {
                    
                    
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
               
                    cell1.textField.secureTextEntry = YES;
                    
                    cell1.textField.text = self.m_pwd2;
                    
                    cell1.textField.delegate = self;
                    
                    cell1.textField.tag = 3;
                    cell=cell1;
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
        {
            switch (row) {
                case 0:
                {
                    
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.text = self.m_user1;
                    cell1.textField.secureTextEntry=NO;
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 4;
                    cell=cell1;
                }
                    break;
                case 1:
                {
                   
                    cell1.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                    cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                    
                        cell1.textField.secureTextEntry = YES;
                
                    cell1.textField.text = self.m_pwd1;
                    
                    cell1.textField.delegate = self;
                    cell1.textField.tag = 5;
                    cell=cell1;
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    
       
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //[currentTextField resignFirstResponder];
}

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    switch (textField.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            textfield_tg=2;
            
            break;
        case 3:
            textfield_tg=3;
           
            break;
        case 4:
            textfield_tg=4;
            
            break;
        case 5:
            textfield_tg=5;
            
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    switch (textField.tag) {
        case 0:
            self.m_strUser = textField.text;
            
            break;
        case 1:
            self.m_strPwd = textField.text;
            break;
        case 2:
            self.m_user2=textField.text;
            break;
        case 3:
            self.m_pwd2=textField.text;
            break;
        case 4:
            self.m_user1=textField.text;
            break;
        case 5:
            self.m_pwd1=textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 16) {
        return NO;
    }
    
    return YES;
}
#pragma mark-
#pragma mark UserPwdProtocol

-(void)UserProtocolResult:(STRU_USER_INFO)t{
    self.m_strUser=[NSString stringWithUTF8String:t.user3];
    self.m_strPwd =[NSString stringWithUTF8String:t.pwd3];
    
     self.m_user1 =[NSString stringWithUTF8String:t.user1];
     self.m_pwd1 =[NSString stringWithUTF8String:t.pwd1];
    
     self.m_user2 =[NSString stringWithUTF8String:t.user2];
     self.m_pwd2 =[NSString stringWithUTF8String:t.pwd2];
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    if (tableView!=nil) {
        [tableView reloadData];
    } 
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

//  Code Begins

#pragma mark -  Request Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    isOkToPopHome = NO; // Yes it is ok to pop to home
    if (!error)
    {
        switch (requestType)
        {
            case OperatorRequest:
            {
                isOperatorChanged = NO;
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *responseDict = (NSDictionary *) result;
                    if ([[responseDict valueForKey:@"code"] integerValue] == 200 && [[responseDict valueForKey:@"status"] isEqualToString:@"OK"])
                    {
                        
                        if (isVisitorChanged)
                        {
                            NSString *strUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
                            
                            NSMutableDictionary *param = [NSMutableDictionary dictionary];
                            [param setValue:@"CAMERA_ACCESS_ADD" forKey:@"action"];
                            [param setValue:strUserName forKey:@"email"];
                            
                            [param setValue:self.m_user1 forKey:@"access_userid"];
                            [param setValue:self.m_pwd1 forKey:@"password"]; //camera_id
                            
                            [param setValue:self.m_strDID forKey:@"camera_id"];
                            [param setValue:@0 forKey:@"access_type"]; // Operator
                            
                            isOkToPopHome = YES;
                            [self.connection makePostRequestFromDictionary:param];
                            requestType = VisitorRequest;
                        }
                        else
                        {
                            NSLog(@"Visitor Changed successfully");
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        
                        
                    }
                }
            }
                break;
            case VisitorRequest:
                isVisitorChanged = NO;
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *responseDict = (NSDictionary *) result;
                    if ([[responseDict valueForKey:@"code"] integerValue] == 200 && [[responseDict valueForKey:@"status"] isEqualToString:@"OK"])
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
                break;
                
            default:
                break;
        }
    }
    else
    {
        isOperatorChanged = NO;
        isVisitorChanged = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Error1", @STR_LOCALIZED_FILE_NAME, nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
//  Code Ends


@end
