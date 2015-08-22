


//
//  SDCardScheduleViewController.m
//  P2PCamera
//
//  Created by Tsang on 13-1-14.
//
//
static const double PageViewControllerTextAnimationDuration = 0.33;
#import "SDCardScheduleViewController.h"
#import "CameraInfoCell.h"
#import "oSwitchCell.h"
#import "oLableCell.h"
#import "obj_common.h"
#import "oTextCell.h"
#import "oLabelTextCell.h"
#import "mytoast.h"
#import "IpCameraClientAppDelegate.h"
#import "oDropController.h"
#import "SDCardTwoLabelCell.h"
@interface SDCardScheduleViewController ()

@end

@implementation SDCardScheduleViewController
@synthesize navigationBar;
@synthesize tableView;
@synthesize strDID;
@synthesize m_pChannelMgt;
@synthesize timeTextField;

@synthesize isP2P;
@synthesize m_strPort;
@synthesize m_strIp;
@synthesize m_strUser;
@synthesize m_strPwd;
@synthesize netUtiles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    if (isP2P) {
        m_pChannelMgt->SetSDcardScheduleDelegate((char *)[strDID UTF8String], nil);
        m_pChannelMgt=nil;
    }else{
        netUtiles.sdcardProtocol=nil;
        netUtiles=nil;
    }
    self.navigationBar=nil;
    self.timeTextField=nil;
    self.tableView=nil;
    self.strDID=nil;
    [super dealloc];
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    isFirstShowing=YES;
    status=0;
    total=0;
    remain=0;
    conver_enable=0;
    time_length=-1;
    record_enable=0;
    m_end_time=24;
    m_start_time=0;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate=self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    NSString *title=NSLocalizedStringFromTable(@"SdcardSetting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:title];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 120, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= title;
    item.titleView=labelTile;
    [labelTile release];
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(setSDCard) forControlEvents:UIControlEventTouchUpInside];
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
        [titlelabel setText:title];
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
    
   
    
    
    tableView.delegate=self;
    tableView.dataSource=self;
    //tableView.allowsSelection=NO;
    if (isP2P) {
        m_pChannelMgt->SetSDcardScheduleDelegate((char *)[strDID UTF8String], self);
        
        m_pChannelMgt->PPPPSetSystemParams((char *)[strDID UTF8String], MSG_TYPE_GET_RECORD, NULL, 0);
    }else{
        //netUtiles.sdcardProtocol=self;
        [netUtiles getSdcardParam:m_strIp Port:m_strPort User:m_strUser Pwd:m_strPwd ParamType:10];
    }
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}

-(void)viewDidAppear:(BOOL)animated{
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
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];

    if (dialog!=nil) {
        [dialog hide];
    }
}
-(void)popToHome:(NSNotification *)notification{//回到首页
    NSString *did=(NSString *)[notification object];
    NSLog(@"did=%@ m_strDID=%@",did,strDID);
    if ([strDID  caseInsensitiveCompare:did]==NSOrderedSame) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil)];
    }
    
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
    if (isFirstShowing) {
        isFirstShowing=NO;
        tableoldFrame=viewFrame;
    }
    // NSLog(@"Keyboardshow    tableoldFrame.size.width=%f",tableoldFrame.size.width);
    
	textFieldAnimatedDistance = 0;
    //	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
    //	{
    textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
    textFieldAnimatedDistance=keyboardRect.origin.y+44;
    viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];
    //	}
    
    //    NSLog(@"currentTextField: %f, %f, %f, %f",currentTextField.bounds.origin.x, currentTextField.bounds.origin.y, currentTextField.bounds.size.height, currentTextField.bounds.size.width);
    
	const CGFloat PageViewControllerTextFieldScrollSpacing = 10;
    
	CGRect textFieldRect =
    [self.tableView convertRect:self.timeTextField.bounds fromView:self.timeTextField];
    
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
    // NSLog(@"keyboardWillHideNotification tableoldFrame.size.width=%f",tableoldFrame.size.width);
    
    if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	// 获取tableview一行的高度
    //    CGRect rectRow=[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    //    float height=rectRow.size.height;
    //    float totalHeight=height*m_nTableviewCount;
    //
    //    NSLog(@"m_nTableviewCount=%d",m_nTableviewCount);
    //
    //	CGRect viewFrame = self.tableView.frame;
    //    viewFrame.size.height=totalHeight+100;
    
	//viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:tableoldFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}
-(void)setSDCard{
    
    [self.timeTextField resignFirstResponder];
    
    if (time_length<5||time_length>120) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"sdcard_range", @STR_LOCALIZED_FILE_NAME, nil)];
        //timeTextField.text=@"";
        return;
    }
    if (m_start_time>=m_end_time) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"sdcard_startendtime_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    
    int time7;
    int time15;
    int time23;
    switch (m_end_time) {
        case 1:
            time7=0x0000000f;
            time15=0x00000000;
            time23=0x00000000;
            break;
        case 2:
            switch (m_start_time) {
                case 0:
                    time7=0x000000ff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x000000f0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            switch (m_start_time) {
                case 0:
                    time7=0x00000fff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x00000ff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0x00000f00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (m_start_time) {
                case 0:
                    time7=0x0000ffff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x0000fff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0x0000ff00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0x0000f000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 5:
            switch (m_start_time) {
                case 0:
                    time7=0x000fffff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x000ffff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0x000fff00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0x000ff000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0x000f0000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            
            break;
        case 6:
            switch (m_start_time) {
                case 0:
                    time7=0x00ffffff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x00fffff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0x00ffff00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0x00fff000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0x00ff0000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0x00f00000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 7:
            switch (m_start_time) {
                case 0:
                    time7=0x0fffffff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0x0ffffff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0x0fffff00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0x0ffff000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0x0fff0000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0x0ff00000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0x0f000000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 8:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x00000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 9:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x0000000f;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 10:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x000000ff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x000000f0;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 11:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x00000fff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x00000ff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0x00000f00;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 12:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x0000ffff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x0000fff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0x0000ff00;
                    time23=0x00000000;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0x0000f000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 13:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x000fffff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x000ffff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0x000fff00;
                    time23=0x00000000;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0x000ff000;
                    time23=0x00000000;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0x000f0000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 14:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x00ffffff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x00fffff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0x00ffff00;
                    time23=0x00000000;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0x00fff000;
                    time23=0x00000000;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0x00ff0000;
                    time23=0x00000000;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0x00f00000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 15:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0x0fffffff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0x0ffffff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0x0fffff00;
                    time23=0x00000000;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0x0ffff000;
                    time23=0x00000000;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0x0fff0000;
                    time23=0x00000000;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0x0ff00000;
                    time23=0x00000000;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0x0f000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 16:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x00000000;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x00000000;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x00000000;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x00000000;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x00000000;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x00000000;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x00000000;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x00000000;
                    break;
                default:
                    break;
            }
            break;
        case 17:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x0000000f;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x0000000f;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x0000000f;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x0000000f;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x0000000f;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x0000000f;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x0000000f;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x0000000f;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0000000f;
                    break;
                default:
                    break;
            }
            break;
        case 18:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x000000ff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x000000ff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x000000ff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x000000ff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x000000ff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x000000ff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x000000ff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x000000ff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000000ff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000000f0;
                    break;
                default:
                    break;
            }
            break;
        case 19:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x00000fff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x00000fff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x00000fff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x00000fff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x00000fff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x00000fff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x00000fff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x00000fff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00000fff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00000ff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00000f00;
                    break;
                default:
                    break;
            }
            break;
        case 20:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x0000ffff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x0000ffff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x0000ffff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x0000ffff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x0000ffff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x0000ffff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x0000ffff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x0000ffff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0000ffff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0000fff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0000ff00;
                    break;
                case 19:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0000f000;
                    break;
                default:
                    break;
            }
            break;
        case 21:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x000fffff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x000fffff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x000fffff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x000fffff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x000fffff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x000fffff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x000fffff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x000fffff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000fffff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000ffff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000fff00;
                    break;
                case 19:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000ff000;
                    break;
                case 20:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x000f0000;
                    break;
                default:
                    break;
            }
            break;
        case 22:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x00ffffff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x00ffffff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x00ffffff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x00ffffff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x00ffffff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x00ffffff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x00ffffff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x00ffffff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00ffffff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00fffff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00ffff00;
                    break;
                case 19:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00fff000;
                    break;
                case 20:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00ff0000;
                    break;
                case 21:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x00f00000;
                    break;
                default:
                    break;
            }
            break;
        case 23:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0x0fffffff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0x0fffffff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0x0fffffff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0x0fffffff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0x0fffffff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0x0fffffff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0x0fffffff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0x0fffffff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0fffffff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0ffffff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0fffff00;
                    break;
                case 19:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0ffff000;
                    break;
                case 20:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0fff0000;
                    break;
                case 21:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0ff00000;
                    break;
                case 22:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0x0f000000;
                    break;
                default:
                    break;
            }
            break;
        case 24:
            switch (m_start_time) {
                case 0:
                    time7=0xffffffff;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 1:
                    time7=0xfffffff0;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 2:
                    time7=0xffffff00;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 3:
                    time7=0xfffff000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 4:
                    time7=0xffff0000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 5:
                    time7=0xfff00000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 6:
                    time7=0xff000000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 7:
                    time7=0xf0000000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 8:
                    time7=0x00000000;
                    time15=0xffffffff;
                    time23=0xffffffff;
                    break;
                case 9:
                    time7=0x00000000;
                    time15=0xfffffff0;
                    time23=0xffffffff;
                    break;
                case 10:
                    time7=0x00000000;
                    time15=0xffffff00;
                    time23=0xffffffff;
                    break;
                case 11:
                    time7=0x00000000;
                    time15=0xfffff000;
                    time23=0xffffffff;
                    break;
                case 12:
                    time7=0x00000000;
                    time15=0xffff0000;
                    time23=0xffffffff;
                    break;
                case 13:
                    time7=0x00000000;
                    time15=0xfff00000;
                    time23=0xffffffff;
                    break;
                case 14:
                    time7=0x00000000;
                    time15=0xff000000;
                    time23=0xffffffff;
                    break;
                case 15:
                    time7=0x00000000;
                    time15=0xf0000000;
                    time23=0xffffffff;
                    break;
                case 16:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xffffffff;
                    break;
                case 17:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xfffffff0;
                    break;
                case 18:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xffffff00;
                    break;
                case 19:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xfffff000;
                    break;
                case 20:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xffff0000;
                    break;
                case 21:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xfff00000;
                    break;
                case 22:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xff000000;
                    break;
                case 23:
                    time7=0x00000000;
                    time15=0x00000000;
                    time23=0xf0000000;
                default:
                    break;
            }
            break;
            
    }
    NSLog(@"conver_enable=%d record_enable=%d",conver_enable,record_enable);
    m_pChannelMgt->SetSDcardScheduleParams(
                                                      (char *)[strDID UTF8String],
                                                      conver_enable,
                                                      time_length,
                                                      record_enable,
                                                      record_audio,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23,
                                                      time7,
                                                      time15,
                                                      time23);
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark-
#pragma mark- TableViewDelegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (record_enable==1) {
        return 9;
    }
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentify3=@"CameraInfoCell";
    NSString *CellIdentity2=@"oSwitchCell";
    NSString *cIdentity1=@"SDCardTwoLabelCell";
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            
            SDCardTwoLabelCell *cell1=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
            if (cell1==nil) {
                UINib *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[UINib nibWithNibName:@"SDCardTwoLabelCell" bundle:nil];
                }else{
                    nib=[UINib nibWithNibName:@"SDCardTwoLabelCell_ipad" bundle:nil];
                }
                
                [atableView registerNib:nib forCellReuseIdentifier:cIdentity1];
                cell1=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
            }
            
            cell1.labelname.text=NSLocalizedStringFromTable(@"sdcard_total", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell1.labelvalue.text=[NSString stringWithFormat:@"%d M",total];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell1;
            
        }
            break;
        case 1:
        {
            
            SDCardTwoLabelCell *cell2=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
            if (cell2==nil) {
                UINib *nib=[UINib nibWithNibName:@"SDCardTwoLabelCell" bundle:nil];
                [atableView registerNib:nib forCellReuseIdentifier:cIdentity1];
                cell2=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
            }
            cell2.labelname.text=NSLocalizedStringFromTable(@"sdcard_remain", @STR_LOCALIZED_FILE_NAME, nil);
            cell2.labelvalue.text=[NSString stringWithFormat:@"%d M",remain];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell2;
        }
            break;
        case 99:{
            oLableCell *cell3=(oLableCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
            if (cell3==nil) {
                NSArray *nib = nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                cell3 = [nib objectAtIndex:0];
            }
            cell3.keyLable.text=NSLocalizedStringFromTable(@"sdcard_status", @STR_LOCALIZED_FILE_NAME, nil);
            if (status==1) {
                cell3.DescriptionLable.text=[NSString stringWithFormat:NSLocalizedStringFromTable(@"sdcard_input", @STR_LOCALIZED_FILE_NAME, nil)];
            }else if (status==0){
                cell3.DescriptionLable.text=[NSString stringWithFormat:NSLocalizedStringFromTable(@"sdcard_output", @STR_LOCALIZED_FILE_NAME, nil)];
            }
            
            cell=cell3;
            
        }
            break;
        case 2:{
            oSwitchCell *cell4=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2];
            if (cell4==nil) {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                
                cell4=[nib objectAtIndex:0];
            }
            cell4.keyLable.text=NSLocalizedStringFromTable(@"sdcard_cover_record", @STR_LOCALIZED_FILE_NAME, nil);
            [cell4.keySwitch setOn:conver_enable>0?YES:NO];
            [cell4.keySwitch addTarget:self action:@selector(switchCoverChange:) forControlEvents:UIControlEventValueChanged];
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell4;
        }
            break;
        case 3:
        {
            CameraInfoCell *cell5=(CameraInfoCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentify3];
            if (cell5==nil) {
                NSArray *nib=nil;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[[NSBundle mainBundle]loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                }else{
                    nib=[[NSBundle mainBundle]loadNibNamed:@"CameraInfoCell_ipad" owner:self options:nil];
                }
                cell5=[nib objectAtIndex:0];
            }
            cell5.keyLable.text=NSLocalizedStringFromTable(@"sdcard_recordtime", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell5.textField.delegate=self;
            cell5.textField.tag=1;
            cell5.textField.placeholder=NSLocalizedStringFromTable(@"sdcard_range", @STR_LOCALIZED_FILE_NAME, nil);
            if (time_length>=0) {
                cell5.textField.text=[NSString stringWithFormat:@"%d",time_length];
            }
            
            cell5.textField.keyboardType=UIKeyboardTypeNumberPad;
            cell5.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell5;
        }
            break;
        case 4:{
            oSwitchCell *cell6=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2]
            ;
            if (cell6==nil) {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell6=[nib objectAtIndex:0];
            }
            cell6.keyLable.text=NSLocalizedStringFromTable(@"sdcard_fixedtime_record", @STR_LOCALIZED_FILE_NAME, nil);
            [cell6.keySwitch setOn:record_enable>0?YES:NO];
            [cell6.keySwitch addTarget:self action:@selector(switchFixedTimeChange:) forControlEvents:UIControlEventValueChanged];
            cell6.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell6;
        }
            break;
            
        case 5://starttime or format sdcard
        {
            if (record_enable>0) {
                SDCardTwoLabelCell *cell5=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
                if (cell5==nil) {
                    UINib *nib;
                    if ([IpCameraClientAppDelegate isiPhone]) {
                        nib=[UINib nibWithNibName:@"SDCardTwoLabelCell" bundle:nil];
                    }else{
                        nib=[UINib nibWithNibName:@"SDCardTwoLabelCell_ipad" bundle:nil];
                    }
                    
                    [atableView registerNib:nib forCellReuseIdentifier:cIdentity1];
                    cell5=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
                }
                cell5.labelname.text = NSLocalizedStringFromTable(@"sdcard_record_starttime", @STR_LOCALIZED_FILE_NAME, nil);
                if (m_start_time<10) {
                    cell5.labelvalue.text =[NSString stringWithFormat:@"0%d:00",m_start_time];
                }else{
                    cell5.labelvalue.text =[NSString stringWithFormat:@"%d:00",m_start_time];
                }
                
                cell5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell5.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell=cell5;
            }else{
                
                oSwitchCell *cell4=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2];
                if (cell4==nil) {
                    NSArray *nib;
                    if ([IpCameraClientAppDelegate isiPhone]) {
                        nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                    }else{
                        nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                    }
                    cell4=[nib objectAtIndex:0];
                }
                cell4.keyLable.text=NSLocalizedStringFromTable(@"sdcard_format", @STR_LOCALIZED_FILE_NAME, nil);
                [cell4.keySwitch setOn:NO];
                [cell4.keySwitch addTarget:self action:@selector(sdcardFormat:) forControlEvents:UIControlEventValueChanged];
                cell4.selectionStyle = UITableViewCellSelectionStyleNone;
                cell=cell4;
            }
            
            
            
        }
            break;
        case 6:
        {
            
            if (record_enable>0) {
                SDCardTwoLabelCell *cell6=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
                if (cell6==nil) {
                    UINib *nib;
                    if ([IpCameraClientAppDelegate isiPhone]) {
                        nib=[UINib nibWithNibName:@"SDCardTwoLabelCell" bundle:nil];
                    }else{
                        nib=[UINib nibWithNibName:@"SDCardTwoLabelCell_ipad" bundle:nil];
                    }
                    
                    [atableView registerNib:nib forCellReuseIdentifier:cIdentity1];
                    cell6=(SDCardTwoLabelCell *)[atableView dequeueReusableCellWithIdentifier:cIdentity1];
                }
                
                
                cell6.labelname.text = NSLocalizedStringFromTable(@"sdcard_record_endtime", @STR_LOCALIZED_FILE_NAME, nil);
                if (m_end_time<10) {
                    cell6.labelvalue.text =[NSString stringWithFormat:@"0%d:00",m_end_time];
                }else{
                    cell6.labelvalue.text =[NSString stringWithFormat:@"%d:00",m_end_time];
                }
                
                cell6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell6.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell=cell6;
            }else{
                
                oSwitchCell *cell8=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2];
                if (cell8==nil) {
                    NSArray *nib;
                    if ([IpCameraClientAppDelegate isiPhone]) {
                        nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                    }else{
                        nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                    }
                    cell8=[nib objectAtIndex:0];
                }
                cell8.keyLable.text=NSLocalizedStringFromTable(@"sd_record_audio", @STR_LOCALIZED_FILE_NAME, nil);
                if (record_audio==1) {
                    [cell8.keySwitch setOn:YES];
                }else{
                    [cell8.keySwitch setOn:NO];
                }
                
                [cell8.keySwitch addTarget:self action:@selector(recordAudioEnable:) forControlEvents:UIControlEventValueChanged];
                cell8.selectionStyle = UITableViewCellSelectionStyleNone;
                cell=cell8;
            }
        }
            break;
        case 7:
        {
            oSwitchCell *cell4=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2];
            if (cell4==nil) {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell4=[nib objectAtIndex:0];
            }
            cell4.keyLable.text=NSLocalizedStringFromTable(@"sdcard_format", @STR_LOCALIZED_FILE_NAME, nil);
            [cell4.keySwitch setOn:NO];
            [cell4.keySwitch addTarget:self action:@selector(sdcardFormat:) forControlEvents:UIControlEventValueChanged];
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell4;
        }
            break;
        case 8:
        {
            oSwitchCell *cell8=(oSwitchCell *)[atableView dequeueReusableCellWithIdentifier:CellIdentity2];
            if (cell8==nil) {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib=[[NSBundle mainBundle]loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                cell8=[nib objectAtIndex:0];
            }
            cell8.keyLable.text=NSLocalizedStringFromTable(@"sd_record_audio", @STR_LOCALIZED_FILE_NAME, nil);
            if (record_audio==1) {
                [cell8.keySwitch setOn:YES];
            }else{
                [cell8.keySwitch setOn:NO];
            }
            
            [cell8.keySwitch addTarget:self action:@selector(recordAudioEnable:) forControlEvents:UIControlEventValueChanged];
            cell8.selectionStyle = UITableViewCellSelectionStyleNone;
            cell=cell8;
        }
            break;
    }
    
    return cell;
}

-(void)sdcardFormat:(id)sender{
    //UISwitch *sw=(UISwitch *)sender;
    
    m_pChannelMgt->PPPPSetSystemParams((char *)[strDID UTF8String], MSG_TYPE_FORMAT_SDCARD, NULL, 0);
    CGRect mainS=[[UIScreen mainScreen] bounds];
    dialog=[[KXDialog alloc]initWithFrame:CGRectMake(0, 0, mainS.size.width, mainS.size.height) Msg:NSLocalizedStringFromTable(@"sdformat_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
    dialog.delegate=self;
    [dialog show];
    [self.view addSubview:dialog];
    [dialog release];
    
}

-(void)dialogHide{
    dialog.delegate=nil;
    dialog=nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (record_enable>0) {
        if (timeTextField!=nil) {
            [timeTextField resignFirstResponder];
        }
        switch (indexPath.row) {
            case 5:
            {
                oDropController *dpView = [[oDropController alloc] init];
                dpView.m_nIndexDrop = 10;
                dpView.m_DropListProtocolDelegate = self;
                [self.navigationController pushViewController:dpView animated:YES];
                [dpView release];
            }
                break;
            case 6:
            {
                oDropController *dpView = [[oDropController alloc] init];
                dpView.m_nIndexDrop = 11;
                dpView.m_DropListProtocolDelegate = self;
                [self.navigationController pushViewController:dpView animated:YES];
                [dpView release];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark--DropListResult
- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2{
    
    if (nType==10) {
        m_start_time=nID;
    }
    if (nType==11) {
        m_end_time=nID;
    }
    [self ReloadTableView];
}

#pragma mark-
#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.timeTextField=textField;
    return  YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    time_length=[textField.text integerValue];
    NSLog(@"time_length=%d",time_length);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>3) {
        return  NO;
    }
    return YES;
}


-(void)switchCoverChange:(id)sender{
    UISwitch *sw=(UISwitch *)sender;
    if (sw.isOn) {
        //NSLog(@"switchCoverChange  =1");
        conver_enable=1;
    }else{
        conver_enable=0;
    }
}

-(void)switchFixedTimeChange:(id)sender{
    UISwitch *sw=(UISwitch *)sender;
    if (sw.isOn) {
        //NSLog(@"switchFixedTimeChange  =1");
        record_enable=1;
    }else{
        record_enable=0;
    }
    [self ReloadTableView];
}

-(void)recordAudioEnable:(id)sender{
    UISwitch *sw=(UISwitch *)sender;
    if (sw.isOn) {
        record_audio=1;
    }else{
        record_audio=0;
    }
}
#pragma mark-
#pragma mark- SdcardSchedule


-(void)SDCardProtocolResult:(STRU_SD_RECORD_PARAM)t{
    total=t.sdtotal;
    remain=t.sdfree;
    status=t.record_sd_status;
    conver_enable=t.record_cover_enable;
    time_length=t.record_timer;
    record_enable=t.record_time_enable;
    record_audio=t.enable_record_audio;
    [self performSelectorOnMainThread:@selector(ReloadTableView) withObject:nil waitUntilDone:NO];
}
#pragma mark-
#pragma mark Reload TableView
-(void)ReloadTableView{
    [self.tableView reloadData];
}

#pragma mark-
#pragma mark UINavigationBarDelegate
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
