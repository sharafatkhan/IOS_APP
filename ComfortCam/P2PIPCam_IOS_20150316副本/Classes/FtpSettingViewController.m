//
//  FtpSettingViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

static const double PageViewControllerTextAnimationDuration = 0.33;

#import "FtpSettingViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "CameraInfoCell.h"
#import "mytoast.h"
#import "IpCameraClientAppDelegate.h"

@interface FtpSettingViewController ()

@end

@implementation FtpSettingViewController

@synthesize navigationBar;
@synthesize tableView;
@synthesize currentTextField;
@synthesize m_strFTPSvr;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize m_pChannelMgt;
@synthesize m_strDID;
@synthesize isSetOver;

@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_User;
@synthesize m_Pwd;
@synthesize netUtiles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnSetFTP:(id) sender
{
    [currentTextField resignFirstResponder];
    
    //NSLog(@"ftpSvr: %@, ftpport: %d, ftpUser: %@, ftpPwd: %@", m_strFTPSvr, m_nFTPPort, m_strUser, m_strPwd);
    if (m_nUploadInterval>3600) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"ftp_uploadtime_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    NSString * regex = @".*[\u4e00-\u9fa5]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:m_strUser];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strPwd];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
       
        return;
    }
    isMatch = [pred evaluateWithObject:m_strFTPSvr];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"FTPServer", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    
    
    
    
    if (isP2P) {
        m_pChannelMgt->SetFTP((char*)[m_strDID UTF8String],
                              (char*)[m_strFTPSvr UTF8String],
                              (char*)[m_strUser UTF8String],
                              (char*)[m_strPwd UTF8String],
                              (char*)"/", m_nFTPPort, m_nUploadInterval, 0);
    }else{
        [netUtiles setFtp:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd FTPSvr:m_strFTPSvr StrUser:m_strUser StrPwd:m_strPwd SPort:m_nFTPPort UploadInterval:m_nUploadInterval];
        
    }
    isSetOver=YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSetOver=NO;
    self.m_strFTPSvr = @"";
    self.m_strPwd = @"";
    self.m_strUser = @"";
    m_nFTPPort = 21;
    m_nUploadInterval = 0;
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);
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
    [btnRight addTarget:self action:@selector(btnSetFTP:) forControlEvents:UIControlEventTouchUpInside];
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
        UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [titlelabel setText:strTitle];
        [titlelabel setTextColor:[UIColor whiteColor]];
        titlelabel.font=[UIFont boldSystemFontOfSize:18];
        item.titleView=titlelabel;
        [titlelabel release];
        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    [rightButton release];
    [leftButton release];
    [item release];
    
    
    if (isP2P) {
        m_pChannelMgt->SetFTPDelegate((char*)[m_strDID UTF8String], self);
        m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }else{
        //netUtiles.ftpProtocol=self;
        
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd ParamType:6];
    }
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
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
- (void) dealloc
{
    if (isP2P) {
       m_pChannelMgt->SetFTPDelegate((char*)[m_strDID UTF8String], nil);
        m_pChannelMgt=nil;
    }else{
        netUtiles.ftpProtocol=nil;
        netUtiles=nil;
    }
   
    self.navigationBar = nil;
    self.tableView = nil;
    self.currentTextField = nil;
    self.m_strPwd = nil;
    self.m_strFTPSvr = nil;
    self.m_strUser = nil;
    self.m_strDID = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"FTPSettingCell1";
    
    CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell1 == nil)
    {
        UINib *nib;
        if ([IpCameraClientAppDelegate isiPhone]) {
            nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
            [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell1=(CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }else{
            nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
            [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell1=(CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        
    }
    
    switch (anIndexPath.row) {
        case 0: //ftp server
        {            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPServer", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strFTPSvr;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpServer", @STR_LOCALIZED_FILE_NAME, nil);
        }
            break;
        case 1: //ftp port
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"Port", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nFTPPort];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
        case 2: //ftp user
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strUser;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 3: //ftp pwd
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strPwd;
            cell1.textField.secureTextEntry = YES;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 4: //upload interval
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPUploadInterval", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nUploadInterval];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
            
        default:
            break;
    }    
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.delegate = self;
    cell1.textField.tag = anIndexPath.row;
    
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //[currentTextField resignFirstResponder];
}

#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    //NSLog(@"keyboardWillShowNotification");
    
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
    
	textFieldAnimatedDistance = 0;
//	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
//	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
        textFieldAnimatedDistance = keyboardRect.origin.y+44;
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
        return;
    }
    
    //    NSIndexPath * indexPath = [rectarray objectAtIndex:0];
    //    NSLog(@"row: %d", indexPath.row);
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];
    
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


#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    switch (textField.tag) {
        case 0: // ftp server
            self.m_strFTPSvr = textField.text;
            break;
        case 1: //ftp port
            m_nFTPPort = atoi([textField.text UTF8String]);
            if (m_nFTPPort <= 0) {
                m_nFTPPort = 21;
            }
            break;
        case 2: //ftp user
            self.m_strUser = textField.text;
            break;
        case 3://ftp pwd
            self.m_strPwd = textField.text;
            break;
        case 4: //upload interval
            m_nUploadInterval = atoi([textField.text UTF8String]);
            if (m_nUploadInterval < 0) {
                m_nUploadInterval = 0;
            }
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
    int tag=textField.tag;
    switch (tag) {
        case 1:{
            if (range.location>5) {
                return NO;
            }
        }
            break;
        case 4:{
            if (range.location>3) {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) reloadTableView
{
    if (tableView!=nil) {
        [tableView reloadData];
    }
    
}

#pragma mark -
#pragma mark ftpParamDelegate


-(void)FtpProtocolResult:(STRU_FTP_PARAMS)t{
    self.m_strFTPSvr = [NSString stringWithUTF8String:t.svr_ftp];
    self.m_strUser = [NSString stringWithUTF8String:t.user];;
    self.m_strPwd =[NSString stringWithUTF8String:t.pwd];;
    
    m_nFTPPort = t.port;
    m_nUploadInterval = t.upload_interval;
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}


@end
