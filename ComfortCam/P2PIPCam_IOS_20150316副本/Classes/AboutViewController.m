//
//  AboutViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
static const double PageViewControllerTextAnimationDuration = 0.33;
#import "AboutViewController.h"
#import "obj_common.h"
#import "AboutCell.h"
#import "PPPP_API.h"
#import "IpCameraClientAppDelegate.h"
#import "ServerCell.h"
#import <QuartzCore/QuartzCore.h>
#import "mytoast.h"

// Code Begin
#import "SubscriptionViewController.h"
// Code Ends

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize mTf;
@synthesize navigationBar;
@synthesize tableView;
@synthesize cameraListMgt;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"about"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isReceivePush=[[NSUserDefaults standardUserDefaults] boolForKey:@"ispush"];
    NSLog(@"isReceivePush=%d",isReceivePush);
    mainScreen=[[UIScreen mainScreen] bounds];
    isFirstShowing=YES;
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil)];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"About", @STR_LOCALIZED_FILE_NAME, nil);
    naviItem.titleView=labelTile;
    [labelTile release];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
    
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
        CGRect tableFrm=tableView.frame;
        tableFrm.origin.y+=20;
        tableView.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
    }else{
        NSLog(@"less ios7");
        isIOS7=NO;
    }
    
    
}
-(NSString *)dataFilePath{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                               , YES);
    NSString *paths=[path objectAtIndex:0];
    return[paths stringByAppendingPathComponent:@"server"];
    
}
-(void)btnServerFinish{
    NSString *server=mTf.text;
    
    if (server!=nil) {
        NSLog(@"server=%@",server);
        NSNumber *num=[NSNumber numberWithBool:NO];
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [array addObject:server];
        [array addObject:num];
        [array writeToFile:[self dataFilePath] atomically:YES];
        [mytoast showWithText:NSLocalizedStringFromTable(@"about_server_finish", @STR_LOCALIZED_FILE_NAME, nil)];
        [array release];
    }   
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.cameraListMgt=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
#pragma mark -
#pragma mark TableViewDelegate

// Code change begin
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

// Code change end

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return NSLocalizedStringFromTable(@"about_soft_information", @STR_LOCALIZED_FILE_NAME, nil);
//    }else{
//        return NSLocalizedStringFromTable(@"about_server_information", @STR_LOCALIZED_FILE_NAME, nil);
//    }

//}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    
    UITableViewCell *cell1=nil;
    CGRect frame;
    if (anIndexPath.section==0) {
        NSString *cellIdentifier = @"AboutCell";
        
        AboutCell *cell =  (AboutCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        frame=cell.frame;
        switch (anIndexPath.row) {
            case 0:
                cell.labelItem.text = NSLocalizedStringFromTable(@"about_version", @STR_LOCALIZED_FILE_NAME, nil);
                cell.labelVersion.text = @STR_VERSION_NO;
                break;
            case 1:
                cell.labelItem.text =NSLocalizedStringFromTable(@"about_internalversion", @STR_LOCALIZED_FILE_NAME, nil);
                cell.labelVersion.text = [NSString stringWithFormat:@"0.1.%@",@STR_VERSION_NO];
                break;
            case 2:
            {
                cell.labelItem.text = @"P2P";
                int nP2PVersion = PPPP_GetAPIVersion();
                
                NSLog(@"nP2PVersion: %d", nP2PVersion);
                NSString *P2PVersion = [NSString stringWithFormat:@"%x.%x.%x.%x",
                                        nP2PVersion>>24,
                                        (nP2PVersion & 0xffffff) >> 16,
                                        (nP2PVersion & 0xffff) >> 8,
                                        nP2PVersion & 0xff];
                cell.labelVersion.text = P2PVersion;
            }
                break;
            case 3:
                cell.labelItem.text = @"P2PAPI";
                cell.labelVersion.text = @"1.0.0.0";
                break;
                
            default:
                break;
        }
        
        cell1= cell;
    }else if (anIndexPath.section==1){
        
        NSString *identifer=@"cell2";
        UITableViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:identifer];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=NSLocalizedStringFromTable(@"about_receiverpush", @STR_LOCALIZED_FILE_NAME, nil);
        UISwitch *sw=[[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        if (isReceivePush) {
            [sw setOn:YES];
        }else{
            [sw setOn:NO];
        }
        
        [sw addTarget:self action:@selector(alarmNotifyChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=sw;
        [sw release];
        [cell setHighlighted:YES];
        cell1=cell;
    }
    //  Code Begins
    else
    {
        NSString *cellIdentifier = @"AboutCell";
        
        AboutCell *cell =  (AboutCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AboutCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.labelItem.hidden = YES;
        cell.labelVersion.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        frame=cell.frame;
        
        
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"Log out" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"imgButton.png"] forState:UIControlStateNormal];
        
        CGPoint center = self.view.center;
        
        button.frame = CGRectMake(center.x - 145, 3.0, 130.0, 35.0);
        button.tag = 1;
        [cell addSubview:button];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self
                    action:@selector(aMethod:)
         
          forControlEvents:UIControlEventTouchUpInside];
        button2.backgroundColor = [UIColor redColor];
        [button2 setTitle:@"Subscription" forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"imgButton.png"] forState:UIControlStateNormal];
        button2.frame = CGRectMake(center.x + 15, 3.0, 130.0, 35.0);
        button2.tag = 2;
        [cell addSubview:button2];
        
        
        
        cell1=cell;
    }
    //  Code Ends
    
    
    float cellHeight = cell1.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell1.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell1.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    if (isIOS7) {
        cell1.backgroundView=cellBgView;
    }
    
    [label release];
    [cellBgView release];
    
    return  cell1;
}


//  Code Begins


-(IBAction)aMethod:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    if (btn.tag == 1)
    {
        NSLog(@"log out");
        
        self.tabBarController.selectedIndex = 0;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIN"];
        
        [[IpCameraClientAppDelegate sharedAppDelegate] addLoginView];
        
    }
    else
    {
        NSLog(@"subscribe");
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            SubscriptionViewController *rvc = [[SubscriptionViewController alloc] initWithNibName:@"SubscriptionViewController" bundle:nil];
            [self presentViewController:rvc animated:YES completion:nil];
            //        [self.navigationController pushViewController:rvc animated:YES];
            
        }
        else
        {
            SubscriptionViewController *rvc = [[SubscriptionViewController alloc] initWithNibName:@"SubscriptionViewController_iPad" bundle:nil];
            [self presentViewController:rvc animated:YES completion:nil];
            //        [self.navigationController pushViewController:rvc animated:YES];
        }
        
    }
}

//  Code Ends


-(void)alarmNotifyChange:(id)sender{
    NSLog(@"alarmNotifyChange....");
    UISwitch *sw=(UISwitch*)sender;
     NSLog(@"isReceivePush=%d",isReceivePush);
    
    IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    [delegate openOrCloseAlarmPush:sw.isOn];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   
//}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    return;
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    NSString *server=@"EBGAEOBOKHJMHMJMENGKFIEEHBMDHNNEGNEBBCCCBIIHLHLOCIACCJOFHHLLJEKHBFMPLMCHPHMHAGDHJNNHIFBAMC";
    NSNumber *num=[NSNumber numberWithBool:YES];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [array addObject:server];
    [array addObject:num];
    [array writeToFile:[self dataFilePath] atomically:YES];
    [mytoast showWithText:NSLocalizedStringFromTable(@"about_default_prompt", @STR_LOCALIZED_FILE_NAME, nil)];
}
#pragma  mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    mTf=textField;
    return YES;
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
    [self.tableView convertRect:mTf.bounds fromView:mTf];
    
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

@end
