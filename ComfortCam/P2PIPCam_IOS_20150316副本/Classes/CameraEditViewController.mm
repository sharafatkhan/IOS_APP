

//
//  CameraEditViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraEditViewController.h"
#import "CameraViewController.h"
#import "CameraInfoCell.h"
#import "mytoast.h"
#import "CameraSearchViewController.h"
#import "IpCameraClientAppDelegate.h"
#import "adddevicecellCell.h"


static const double PageViewControllerTextAnimationDuration = 0.33;

@implementation CameraEditViewController

@synthesize bAddCamera;
@synthesize editCameraDelegate;
@synthesize strCameraName;
@synthesize strCameraID;
@synthesize strOldDID;
@synthesize strUser;
@synthesize strPwd;
@synthesize currentTextField;
@synthesize tableView;
@synthesize navigationBar;
@synthesize isP2P;
@synthesize strCameraIp;
@synthesize strOldIp;
@synthesize strCameraPort;
@synthesize cameraListMgt;
#pragma mark -
#pragma mark system

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.strCameraName = @STR_DEFAULT_CAMERA_NAME;
        self.strCameraID = @"";
        self.strOldDID = @"";
        self.strUser = @STR_DEFAULT_USER_NAME;
        self.strPwd = @"";
        self.strCameraIp=@"";
        self.strOldIp=@"";
    }
    
    return self ;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strTitle;
    if (bAddCamera == YES) {
        strTitle = NSLocalizedStringFromTable(@"AddCamera", @STR_LOCALIZED_FILE_NAME, nil);
    }else {
        strTitle = NSLocalizedStringFromTable(@"EditCamera", @STR_LOCALIZED_FILE_NAME, nil);
    }
    
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
    [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnFinished:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    
    
    item.rightBarButtonItem = rightButton;
    item.leftBarButtonItem=leftButton;
    [rightButton release];
    
    NSArray *array = [NSArray arrayWithObjects:item, nil];
    [self.navigationBar setItems:array];
    
    [item release];
    [back release];
    
    
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
    }else{
        NSLog(@"less ios7");
        
    }
    
    
    if (bAddCamera == NO) {
        self.strOldDID = self.strCameraID;
        self.strOldIp=self.strCameraIp;
    }
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.editCameraDelegate = nil;
    self.strCameraName = nil;
    self.strCameraID = nil;
    self.strOldDID = nil;
    self.strUser = nil;
    self.strPwd = nil;
    self.currentTextField = nil;
    self.tableView = nil;
    self.navigationBar = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (isP2P) {
            return 4;
        }
        return 5;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"CameraInfoCell%ld%ld", (long)anIndexPath.section, (long)anIndexPath.row];//= @"CameraInfoCell1";
    
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (anIndexPath.section == 0) {
        
        if (cell1 == nil)
        {
            NSArray *nib=nil;
            if ([IpCameraClientAppDelegate isiPhone]) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"adddevicecellCell" owner:self options:nil];
            }else{
                nib = [[NSBundle mainBundle] loadNibNamed:@"adddevicecellCell_ipad" owner:self options:nil];
            }
           
            
            cell1 = [nib objectAtIndex:0];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        adddevicecellCell *cell = (adddevicecellCell*)cell1;
        
        
        NSInteger row = anIndexPath.row;
        
        
        switch (row) {
            case 0:
                cell.labelname.text = NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraName", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.text = self.strCameraName;
                cell.imageView.image=[UIImage imageNamed:@"addname.png"];
                break;
            case 1:
                if (isP2P) {
                    cell.labelname.text = NSLocalizedStringFromTable(@"CameraID", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"InputCameraID", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.text = self.strCameraID;
                }else{
                    cell.labelname.text = NSLocalizedStringFromTable(@"cameraIp", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"inputCameraIp", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.text = self.strCameraIp;
                }
                
                cell.imageView.image=[UIImage imageNamed:@"adddevice.png"];
                break;
            case 2:
                
                if (isP2P) {
                    cell.labelname.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.text = self.strUser;
                    
                    cell.imageView.image=[UIImage imageNamed:@"adduser.png"];
                }else{
                    cell.labelname.text = NSLocalizedStringFromTable(@"cameraPort", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"inputCameraPort", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.text = self.strCameraPort;
                    cell.imageView.image=[UIImage imageNamed:@"adddevice.png"];
                }
                
                
                break;
            case 3:
                if (isP2P) {
                    cell.labelname.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.secureTextEntry = YES;
                    cell.textField.text = self.strPwd;
                    cell.imageView.image=[UIImage imageNamed:@"addpassword.png"];
                }else{
                    
                    cell.labelname.text = NSLocalizedStringFromTable(@"User", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.textField.text = self.strUser;
                    cell.imageView.image=[UIImage imageNamed:@"adduser.png"];
                }
                
                break;
            case 4:
                cell.labelname.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                cell.textField.secureTextEntry = YES;
                cell.textField.text = self.strPwd;
                NSLog(@"strPwd=%@",strPwd);
                cell.imageView.image=[UIImage imageNamed:@"addpassword.png"];
                break;
            default:
                break;
        }
        
        
        cell.textField.delegate = self;
        cell.textField.tag = row;
    }else if (anIndexPath.section == 1) {// lan search
        if (cell1 == nil) {
            cell1 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            
        }
        
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.textLabel.text = NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        cell1.imageView.image=[UIImage imageNamed:@"add_twobar.png"];
    }
    else {//senction == 2 //scan qr code
        
        
        if (cell1 == nil) {
            cell1 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
        }
        
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell1.textLabel.text = NSLocalizedStringFromTable(@"LANSearch", @STR_LOCALIZED_FILE_NAME, nil);
        cell1.imageView.image=[UIImage imageNamed:@"addsearch.png"];
    }
	
	return cell1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"CameraInfo", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 1){ //lan search
        //return NSLocalizedStringFromTable(@"LAN", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }else { //scan qr code
        ///return NSLocalizedStringFromTable(@"ScanQRCode", @STR_LOCALIZED_FILE_NAME, nil);
        return nil;
    }
}

- (void) tableView:(UITableView *)anTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [anTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    if (anIndexPath.section == 1) { //lan search
        
        
        [currentTextField resignFirstResponder];
        if(![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerSourceTypeCamera]){
            [mytoast showWithText:NSLocalizedStringFromTable(@"editcameraunableuse", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
        [self startZBarCamera];
    }
    
    if (anIndexPath.section == 2) { //scan qrcode
        CameraSearchViewController *cameraSearchView = [[CameraSearchViewController alloc] init];
        cameraSearchView.SearchAddCameraDelegate = self;
        [self.navigationController pushViewController:cameraSearchView animated:YES];
        [cameraSearchView release];
    }
}

#pragma mark--开始二维码扫瞄
-(void)startZBarCamera{
    
    ScanViewController *vc=[[ScanViewController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)scanQRCodeResult:(NSString *)result{
    NSLog(@"scanQRCodeResult...strResult=%@",result);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CameraInfoCell *cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = result;
    self.strCameraID = result;
}
#pragma mark---二维码结束
#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    //NSLog(@"keyboard    Show  Notification");
    
    CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
        NSLog(@"UIKeyboardFrameEndUserInfoKey!=nil 111111");
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
        NSLog(@"UIKeyboardFrameEndUserInfoKey == nil 222222");
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
    NSLog(@"key.origin.y=%f table.origin.y=%f",keyboardRect.origin.y ,viewFrame.origin.y);
    
    //	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)// old
    //	{
    textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
    viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
    
    textFieldAnimatedDistance=keyboardRect.origin.y+44; //kaven
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];
    //	}
    NSLog(@"show    textFieldAnimatedDistance= %f",textFieldAnimatedDistance);
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
    
    
    NSLog(@"hide    textFieldAnimatedDistance= %f",textFieldAnimatedDistance);
    
    
    if (textFieldAnimatedDistance == 0)
	{
        NSLog(@"keyboardWillHideNotification  99999999999");
        
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
    //NSLog(@"textFieldShouldBeginEditing");
    
    self.currentTextField = textField;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    
    switch (textField.tag) {
        case TAG_CAMERA_NAME:
            self.strCameraName = textField.text;
            break;
        case TAG_CAMERA_ID:
            if (isP2P) {
                self.strCameraID = textField.text;
            }else{
                self.strCameraIp=textField.text;
            }
            
            break;
        case TAG_USER_NAME:
            if (isP2P) {
                self.strUser = textField.text;
            }else{
                self.strCameraPort=textField.text;
                
            }
            
            break;
        case TAG_PASSWORD:
            if (isP2P) {
                self.strPwd = textField.text;
            }else{
                self.strUser=textField.text;
            }
            
            break;
        default:
            self.strPwd=textField.text;
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
    if (textField.tag==TAG_CAMERA_NAME) {
        NSString *name=textField.text;
        NSString * regex = @".*[\u4e00-\u9fa5]+.*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:name];
        if (isMatch) {
            if (range.location >= 8) {
                return NO;
            }
        }
    }
    
    if (range.location >= 24) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark other


- (void) btnFinished:(id)sender
{
    //NSLog(@"btnFinished");
    [currentTextField resignFirstResponder];
    
    if ([strCameraName length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCamreraName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if (isP2P) {
        if ([strCameraID length] == 0) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputCameraID", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }else{
        if ([strCameraIp length]==0) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"pleaseInputcameraIp", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        if ([strCameraPort length]==0) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"pleaseInputcameraPort", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
    }
    
    
    if ([strUser length] == 0) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseInputUserName", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    NSString * regex = @".*[\u4e00-\u9fa5]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:strCameraID];
    if (isMatch) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"addcamera_idnotchinese", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if ([strCameraID length]<9) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    if ([strCameraID length]>=8) {
        NSString *didPrefix=[strCameraID substringToIndex:8];
        NSLog(@"didPrefix=%@",didPrefix);
        regex=@".*[0-9]+.*";
        pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isMatch = [pred evaluateWithObject:didPrefix];
        if (!isMatch) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
    }
    
    int count = [cameraListMgt GetCount];
    if (isP2P) {
        if ([strCameraID caseInsensitiveCompare:strOldDID]!=NSOrderedSame) {
            for (int i=0; i<count; i++) {
                NSDictionary *cameraDic =cameraDic = [cameraListMgt GetCameraAtIndex:i];
                NSString *strDID = [cameraDic objectForKey:@STR_DID];
                
                if ([strCameraID caseInsensitiveCompare:strDID]==NSOrderedSame) {
                    [mytoast showWithText:NSLocalizedStringFromTable(@"addcamera_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
                    // NSLog(@"p2p...strCameraID=%@  strDID=%@",strCameraID,strDID);
                    return;
                }
                
            }
        }
        
    }else{
        if ([strCameraIp caseInsensitiveCompare:strOldIp]!=NSOrderedSame) {
            for(int i=0;i<count;i++){
                NSMutableDictionary *cameraDic = [cameraListMgt GetIpCameraAtIndex:i];
                NSString *ip = [cameraDic objectForKey:@STR_IPADDR];
                if ([strCameraIp caseInsensitiveCompare:ip]==NSOrderedSame) {
                    [mytoast showWithText:NSLocalizedStringFromTable(@"addcamera_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
                    //NSLog(@"DDNS...strCameraIp=%@  ip=%@",strCameraIp,ip);
                    return;
                }
            }
        }
        
    }
    
    if (![self checkValidID:strCameraID]) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    NSLog(@"name=%@ did=%@ user=%@ pwd=%@  port=%@",strCameraName,strCameraID,strUser,strPwd,strCameraPort);
    BOOL bRet=[editCameraDelegate EditP2PCameraInfo:bAddCamera Name:strCameraName DID:strCameraID User:strUser Pwd:strPwd OldDID:strOldDID IP:strCameraIp OldIP:strOldIp Port:strCameraPort];
    if (bRet == NO) {
        //      NSLog(@"EditP2PCameraInfo return NO");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkValidID:(NSString*)did{
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    did=[did stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSRange ra1=[did rangeOfCharacterFromSet:set];
    NSRange ra2=[did rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    if ((ra2.location-ra1.location)>5) {
        //数字多于6则是无效ID
        return NO;
    }
    NSString *subfix=[did substringFromIndex:ra2.location+1];
    if (subfix.length>5) {
        //后缀字母数多于5则是无效ID
        return NO;
    }
    
    //    NSLog(@"location1=%d  location2=%d leng=%d subfix=%@",ra1.location,ra2.location,ra2.location-ra1.location,subfix);
    
    return YES;
    
}

#pragma mark -
#pragma mark SearchAddCameraInfoDelegate

- (void) AddCameraInfo:(NSString *)astrCameraName DID:(NSString *)strDID IP:(NSString *)strIP Port:(NSString *)port
{
    NSLog(@"AddCameraInfo...port=%@",port);
    self.strCameraName = astrCameraName;
    self.strCameraID = strDID;
    self.strCameraPort=port;
    self.strCameraIp=strIP;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CameraInfoCell *cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cameraInfo == nil) {
        return;
    }
    if (isP2P) {
        cameraInfo.textField.text = strDID;
    }else{
        cameraInfo.textField.text=strIP;
        indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cameraInfo == nil) {
            return;
        }
        
        cameraInfo.textField.text = port;
    }
    
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    cameraInfo = (CameraInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cameraInfo == nil) {
        return;
    }
    
    cameraInfo.textField.text = astrCameraName;

    
}

#pragma mark -
#pragma mark navigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}


@end


