//
//  MoreViewController.m
//  P2PCamera
//
//  Created by Tsang on 13-5-2.
//
//

#import "MoreViewController.h"
#import "CameraEditViewController.h"
#import "CameraListCell.h"
#import "IpCameraClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
#import "mytoast.h"
#import "CustomToast.h"
#include "MyAudioSession.h"
#import "SettingViewController.h"
#import "AddCameraCell.h"
#import "CameraEditViewController.h"
#import "APICommon.h"
#import "morelistcell.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize cameraList;
@synthesize navigationBar;

@synthesize btnAddCamera;
@synthesize alertView;

@synthesize cameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize PicNotifyEventDelegate;
@synthesize RecordNotifyEventDelegate;
@synthesize m_pRecPathMgt;
@synthesize pPPPPChannelMgt;

@synthesize picViewController;
@synthesize recViewController;

@synthesize firstImgView;
@synthesize secondImgView;
@synthesize thirdImgView;
@synthesize fourImgView;
@synthesize defaultImg;
@synthesize playDictionary;
@synthesize firstID;
@synthesize secondID;
@synthesize thirdID;
@synthesize fourID;

@synthesize processView1;
@synthesize processView2;
@synthesize processView3;
@synthesize processView4;

@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourLabel;

@synthesize myDialogView;
@synthesize btnPush;

@synthesize moreViewExitDelegate;

#pragma mark -
#pragma mark button presss handle

- (void) StartPlayView: (NSInteger)index
{
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    
    NSString *strName = [cameraDic objectForKey:@STR_NAME];
    
    int  modal=[[cameraDic objectForKey:@STR_MODAL] integerValue];
    NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    
    if (firstID!=nil&&secondID!=nil&&thirdID!=nil&&fourID!=nil) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewall", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    
    if ([strDID isEqualToString:firstID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    if ([strDID isEqualToString:secondID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([strDID isEqualToString:thirdID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([strDID isEqualToString:fourID]) {
        [CustomToast showWithText:NSLocalizedStringFromTable(@"moreviewadded", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    if (firstID==nil) {
        firstLabel.text=strName;
        firstLabel.hidden=NO;
        firstID=strDID;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView1.hidden=NO;
        return;
    }
    
    if (secondID==nil) {
        secondID=strDID;
        secondLabel.text=strName;
        secondLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView2.hidden=NO;
        return;
    }
    
    if (thirdID==nil) {
        thirdID=strDID;
        thirdLabel.text=strName;
        thirdLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView3.hidden=NO;
        return;
    }
    
    if (fourID==nil) {
        fourID=strDID;
        fourLabel.text=strName;
        fourLabel.hidden=NO;
        pPPPPChannelMgt->CameraControl([strDID UTF8String], 0, 1);
        pPPPPChannelMgt->StartPPPPLivestream([strDID UTF8String], 10, self);
        processView4.hidden=NO;
        return;
    }
    
    //[mytoast showWithText:@"已经加满"];
    
    return;
   // IpCameraClientAppDelegate *IPCamDelegate =  [[UIApplication sharedApplication] delegate] ;
    PlayViewController *playViewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
        
    }else{
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_Ipad" bundle:nil];
        
    }
    
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.PicNotifyDelegate = picViewController;
    playViewController.RecNotifyDelegate = recViewController;
    playViewController.mModal=modal;
    playViewController.strDID = strDID;
    playViewController.cameraName = strName;
    playViewController.m_nP2PMode = [nPPPPMode intValue];
    [playViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //    [self presentViewController:playViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:playViewController animated:YES];
    
    [self presentModalViewController:playViewController animated:YES];
    //[IPCamDelegate switchPlayView:playViewController];
    
    [playViewController release];
    
}


#define ADD_CAMERA_RED 200
#define ADD_CAMERA_GREED 200
#define ADD_CAMERA_BLUE 200

#define ADD_CAMERA_NORMAL_RED 230
#define ADD_CAMERA_NORMAL_GREEN 230
#define ADD_CAMERA_NORMAL_BLUE 230

- (IBAction)btnAddCameraTouchDown:(id)sender
{
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_RED/255.0f green:ADD_CAMERA_GREED/255.0f blue:ADD_CAMERA_BLUE/255.0f alpha:1.0];
}

- (IBAction)btnAddCameraTouchUp:(id)sender
{
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    //cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES];
    [cameraEditViewController release];
    
    // [cameraListMgt AddCamera:@"aaaaa" DID:@"bbbbb" User:@"dsfsfs" Pwd:@"" Snapshot:nil];
}

- (void) btnEdit:(id)sender


{
    
    
    if (moreViewExitDelegate!=nil) {
        [moreViewExitDelegate moreViewExit];
    }
    isMoreViewOver=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

            if (firstID!=nil) {
                
                pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
                firstID=nil;
            }
                  
            if (secondID!=nil) {
                
                pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
                secondID=nil;
            }
           
            if (thirdID!=nil) {
                
                pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
                thirdID=nil;
            }
            
            if (fourID!=nil) {
               
                pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
                fourID=nil;
            }
    
    
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissModalViewControllerAnimated:YES];
    return;
    //NSLog(@"btnEdit");
    
    //    if (!bEditMode) {
    //        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //    }else {
    //        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //    }
    
    //    if (!bEditMode) {
    //        //将tableview放大
    //        CGRect tableviewFrame = self.cameraList.frame;
    //        tableviewFrame.origin.y -= 45;
    //        tableviewFrame.size.height += 45;
    //
    //        self.cameraList.frame = tableviewFrame;
    //
    //    }
    //    else {
    //        CGRect tableviewFrame = self.cameraList.frame;
    //        tableviewFrame.origin.y += 45;
    //        tableviewFrame.size.height -= 45;
    //
    //        self.cameraList.frame = tableviewFrame;
    //    }
    
    bEditMode = ! bEditMode;
    //[self setNavigationBarItem:bEditMode];
    
    [cameraList reloadData];
}

- (void) setNavigationBarItem: (BOOL) abEditMode
{
    NSString *strText;
    UIBarButtonItem *btnEdit;
    if (!abEditMode) {
        strText = NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        //btnEdit.tintColor = [UIColor colorWithRed:COLOR_BASE_RED/255 green:COLOR_BASE_GREEN/255 blue:COLOR_BASE_BLUE/255 alpha:0.5];
        if (![IpCameraClientAppDelegate is43Version]) {
            btnEdit.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        }
        
    }else {
        strText = NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        
        // btnEdit.tintColor = [UIColor colorWithRed:BTN_DONE_RED/255.0f green:BTN_DONE_GREEN/255.0f blue:BTN_DONE_BLUE/255.0f alpha:1.0];
    }
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)];
    
    naviItem.rightBarButtonItem = btnEdit;
    [btnEdit release];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];
    
}


#pragma mark -
#pragma mark TableViewDelegate

//删除设备的处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:indexPath.row-1];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    if(YES == [cameraListMgt RemoveCameraAtIndex:indexPath.row-1]){
        if ([cameraListMgt GetCount] > 0) {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //停止P2P
        pPPPPChannelMgt->Stop([strDID UTF8String]);
        
        [m_pPicPathMgt RemovePicPathByID:strDID];
        [m_pRecPathMgt RemovePathByID:strDID];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        //        if ([cameraListMgt GetCount] == 0) {
        //            [self btnEdit:nil];
        //        }
        
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return NO;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:indexPath.row-1];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    if ([strDID isEqualToString:firstID]) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([strDID isEqualToString:secondID]) {
        return UITableViewCellEditingStyleNone;
    }
    if ([strDID isEqualToString:thirdID]) {
        return UITableViewCellEditingStyleNone;
    }
    if ([strDID isEqualToString:fourID]) {
        return UITableViewCellEditingStyleNone;
    }
    
    if (bEditMode == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    
    if (indexPath.row==0) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([strDID isEqualToString:firstID]||[strDID isEqualToString:secondID]||[strDID isEqualToString:thirdID]||[strDID isEqualToString:fourID]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
    //
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    int index = anIndexPath.row - 1;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_USER_PWD) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
        //[mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:YES];
        return;
    }
    
    NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];
    BOOL authority=[num boolValue];
    if (!authority) {
        // [mytoast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)];
        [CustomToast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)
                        superView:self.view
                        bLandScap:NO];
        return ;
    }
    SettingViewController *settingView = [[SettingViewController alloc] init];
    settingView.m_pPPPPChannelMgt = pPPPPChannelMgt;
    settingView.m_strDID = [cameraDic objectForKey:@STR_DID];
    //[self.navigationController pushViewController:settingView animated:YES];
    [self presentModalViewController:settingView animated:YES];
    [settingView release];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{

    int count = [cameraListMgt GetCount];

    return count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    
    NSInteger index = anIndexPath.row ;
    

    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    UIImage *img = [cameraDic objectForKey:@STR_IMG];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    
    NSString *cellIdentifier = @"CameraListCell";
    //当状态为显示当前的设备列表信息时
    morelistcell *cell =  (morelistcell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        
        UINib *nib=[UINib nibWithNibName:@"morelistcell" bundle:nil];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell =  (morelistcell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    }
    
    
    
    int PPPPStatus = [nPPPPStatus intValue];
   
    
    if (img != nil) {
        cell.imageCamera.image = img;
        
    }else{
        cell.imageCamera.image= [UIImage imageNamed:@"back.png"];
    }
    
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did;

    
    float cellHeight = cell.frame.size.height;
   
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    
    cell.backgroundView = cellBgView;
    [cellBgView release];
   
    
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_LAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_WLAN:
            strPPPPStatus= NSLocalizedStringFromTable(@"PPPPStatusWLanOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    cell.PPPPStatusLable.text = strPPPPStatus;
    
   	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{

    
    return 63;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];

    int index = anIndexPath.row;

    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
        return;
    }
    
    if ([nPPPPStatus intValue] != PPPP_STATUS_LAN&&[nPPPPStatus intValue] != PPPP_STATUS_WLAN) {
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
       
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        
        return;
    }
   
    [self StartPlayView:index];
    
}

#pragma mark -
#pragma mark system

- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}

- (void) UpdateCameraSnapshot
{
    int count = [cameraListMgt GetCount];
    if (count == 0) {
        [self hideLoadingIndicator];
        return;
    }
    
    //NSLog(@"UpdateCameraSnapshot...count: %d", count);
    int i;
    for (i = 0; i < count; i++)
    {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        if (cameraDic == nil) {
            return ;
        }
        
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            continue;
        }
        
        NSString *did = [cameraDic objectForKey:@STR_DID];
        pPPPPChannelMgt->Snapshot([did UTF8String]);
    }
    
    [self showLoadingIndicator];
    [self performSelector:@selector(hideLoadingIndicator) withObject:nil afterDelay:10.0];
    
}

- (void)showLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
	[self.navigationItem setLeftBarButtonItem:progress animated:YES];
}


- (void)hideLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    (UIActivityIndicatorView *)self.navigationItem.leftBarButtonItem;
	if ([indicator isKindOfClass:[UIActivityIndicatorView class]])
	{
		[indicator stopAnimating];
	}
	UIBarButtonItem *refreshButton =
    [[[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)]
     autorelease];
	[self.navigationItem setLeftBarButtonItem:refreshButton animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
    
}

- (BOOL)shouldAutorotate
{
	return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    //UIInterfaceOrientationMaskLandscapeRight
	return UIInterfaceOrientationMaskLandscape;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (id) init
{
    self = [super init];
    if (self != nil) {
        ppppChannelMgntCondition = [[NSCondition alloc] init];
        
        self.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ipc30.png"];
        
        cameraListMgt = [[CameraListMgt alloc] init];
        //[cameraListMgt selectP2PAll:YES];
        pPPPPChannelMgt = new CPPPPChannelManagement();
        m_pPicPathMgt = [[PicPathManagement alloc] init];
        m_pRecPathMgt = [[RecPathManagement alloc] init];
    }
    
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear..88");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{

    if (isFirstLoad) {
        [self performSelector:@selector(changeFrame) withObject:nil afterDelay:0];
        isFirstLoad=false;
    }
}
-(void)changeFrame{
    NSLog(@"changeFrame....");
    cameraList.frame=CGRectMake(mainScreen.size.height-200, 0, 200, mainScreen.size.width);
    CGRect firstFrame=firstImgView.frame;
    CGRect progressView1Frame=processView1.frame;
    
    CGRect secondFrame=secondImgView.frame;
    CGRect progressView2Frame=processView2.frame;
    CGRect secondLabelFrame=secondLabel.frame;
    
    CGRect thirdFrame=thirdImgView.frame;
    CGRect progressView3Frame=processView3.frame;
    
    CGRect fourFrame=fourImgView.frame;
    CGRect btnPushFrame=btnPush.frame;
    CGRect fourLabelFrame=fourLabel.frame;
    CGRect progressView4Frame=processView4.frame;
    
    firstImgView.frame=CGRectMake(0, 0, (mainScreen.size.height-200)/2, mainScreen.size.width/2);
    secondImgView.frame=CGRectMake((mainScreen.size.height-200)/2, 0, (mainScreen.size.height-200)/2, mainScreen.size.width/2);
    thirdImgView.frame=CGRectMake(0, mainScreen.size.width/2, (mainScreen.size.height-200)/2, mainScreen.size.width/2);
    fourImgView.frame=CGRectMake((mainScreen.size.height-200)/2, mainScreen.size.width/2, (mainScreen.size.height-200)/2, mainScreen.size.width/2);
    firstFrame= firstImgView.frame;
    secondFrame=secondImgView.frame;
    thirdFrame=thirdImgView.frame;
    fourFrame=fourImgView.frame;
    
    
    processView1.frame=CGRectMake((firstFrame.size.width-progressView1Frame.size.width)/2, progressView1Frame.origin.y, progressView1Frame.size.width, progressView1Frame.size.height);
    processView2.frame=CGRectMake((mainScreen.size.height-200+secondFrame.size.width-progressView2Frame.size.width)/2, progressView2Frame.origin.y, progressView2Frame.size.width, progressView2Frame.size.height);
    
    processView3.frame=CGRectMake((thirdFrame.size.width-progressView3Frame.size.width)/2, (mainScreen.size.width-mainScreen.size.width/4-progressView3Frame.size.height/2), progressView3Frame.size.width, progressView3Frame.size.height);
    processView4.frame=CGRectMake((mainScreen.size.height-200+fourFrame.size.width-progressView4Frame.size.width)/2, (mainScreen.size.width-mainScreen.size.width/4-progressView4Frame.size.height/2), progressView4Frame.size.width, progressView4Frame.size.height);
    
    
    secondLabel.frame=CGRectMake((mainScreen.size.height-200+20)/2, secondLabelFrame.origin.y, secondLabelFrame.size.width, secondLabelFrame.size.height);
    fourLabel.frame=CGRectMake((mainScreen.size.height-200+20)/2, mainScreen.size.width/2+10, fourLabelFrame.size.width, fourLabelFrame.size.height);
    CGRect thirdLabelFrame= thirdLabel.frame;
    thirdLabel.frame=CGRectMake(thirdLabelFrame.origin.x,mainScreen.size.width/2+10, thirdLabelFrame.size.width, thirdLabelFrame.size.height);
    
    btnPush.frame=CGRectMake(mainScreen.size.height-200-40, btnPushFrame.origin.y, btnPushFrame.size.width, btnPushFrame.size.height);
    
    [self moveDown:30];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    isMoreViewOver=NO;
    isShowTableView=YES;
    mainScreen=[[UIScreen  mainScreen]bounds];
    int screenheight=mainScreen.size.height/2;
    moreW=screenheight-firstImgView.frame.size.width;
    tableViewOrigionX=cameraList.frame.origin.x;
    NSLog(@"mainscreen.width=%f  mainscreen.height=%f",mainScreen.size.width,mainScreen.size.height);
    ppppChannelMgntCondition = [[NSCondition alloc] init];
    

    
    self.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
    self.tabBarItem.image = [UIImage imageNamed:@"ipc30.png"];
    
    cameraList.delegate=self;
    cameraList.dataSource=self;
    isFullScreen=NO;
    playNum=0;
    isFirstLoad=true;
    myDialogView=[[MyDialogView alloc]initWithFrame:CGRectMake(thirdImgView.frame.size.width-68, -50, 135, 50)];
    myDialogView.layer.cornerRadius=3;
    myDialogView.dialogDelegate=self;
    isShowingDialog=YES;
    myDialogView.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.view addSubview:myDialogView];
    
    defaultImg=[UIImage imageNamed:@"moreviewback.png"];
    
    [firstImgView setImage:defaultImg];
    [secondImgView setImage:defaultImg];
    [thirdImgView setImage:defaultImg];
    [fourImgView setImage:defaultImg];
    
    firstImgView.tag=1;
    secondImgView.tag=2;
    thirdImgView.tag=3;
    fourImgView.tag=4;
    
    firstLabel.hidden=YES;
    secondLabel.hidden=YES;
    thirdLabel.hidden=YES;
    fourLabel.hidden=YES;
    
    firstImgView.userInteractionEnabled=YES;
    secondImgView.userInteractionEnabled=YES;
    thirdImgView.userInteractionEnabled=YES;
    fourImgView.userInteractionEnabled=YES;
    firstImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    firstImgView.layer.borderWidth=1.0;
    secondImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    secondImgView.layer.borderWidth=1.0;
    thirdImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    thirdImgView.layer.borderWidth=1.0;
    fourImgView.layer.borderColor=[[UIColor blackColor] CGColor];
    fourImgView.layer.borderWidth=1.0;
    UILongPressGestureRecognizer *longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [firstImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [secondImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [thirdImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    longGesture1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewLongPressed:)];
    [fourImgView addGestureRecognizer:longGesture1];
    [longGesture1 release];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    //[singleTap setNumberOfTouchesRequired:2];
    [firstImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
   // [singleTap setNumberOfTouchesRequired:2];
    [secondImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    //[singleTap setNumberOfTouchesRequired:2];
    [thirdImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewDoubleTapped:)];
    [singleTap setNumberOfTapsRequired:2];
    //[singleTap setNumberOfTouchesRequired:2];
    [fourImgView addGestureRecognizer:singleTap];
    [singleTap release];
    
    
    
    bEditMode = NO;
    
    processView4.hidden=YES;
    processView3.hidden=YES;
    processView2.hidden=YES;
    processView1.hidden=YES;
    [processView1 startAnimating];
    [processView2 startAnimating];
    [processView3 startAnimating];
    [processView4 startAnimating];
    processView1.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView1.layer.cornerRadius=3;
    processView2.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView2.layer.cornerRadius=3;
    processView3.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView3.layer.cornerRadius=3;
    processView4.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    processView4.layer.cornerRadius=3;
    
    [btnPush addTarget:self action:@selector(btnPushAndPull) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setNavigationBarItem:bEditMode];
    
    [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.cameraList setSeparatorColor:[UIColor clearColor]];
    
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    
    pPPPPChannelMgt->pCameraViewController = self;
    
    [self initTopBar];
    
    
   //[self StartPPPPThread];
    
//    InitAudioSession();//ios8
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=cameraList.frame;
    imgView.center=cameraList.center;
    cameraList.backgroundView=imgView;
    [imgView release];
    waitMoment=YES;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(waitMoment) userInfo:nil repeats:NO];
}
-(void)waitMoment{
    waitMoment=NO;
}
-(void)initTopBar{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, mainScreen.size.height, 30);
    UIImageView *imgViewBg=[[UIImageView alloc]init];
    imgViewBg.frame=view.frame;
    [imgViewBg setImage:[UIImage imageNamed:@"top_bg_blue.png"]];
    [view addSubview:imgViewBg];
    [imgViewBg release];
    UILabel *labelTitle=[[UILabel alloc]init];
    labelTitle.frame=CGRectMake(30, 0, 150, 30);
    labelTitle.backgroundColor=[UIColor clearColor];
    labelTitle.text=NSLocalizedStringFromTable(@"fourviews", @STR_LOCALIZED_FILE_NAME, nil);
    labelTitle.textAlignment=UITextAlignmentLeft;
    labelTitle.textColor=[UIColor whiteColor];
    labelTitle.font=[UIFont boldSystemFontOfSize:18];
    [view addSubview:labelTitle];
    [labelTitle release];
    UIButton *btnExit=[UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.frame=CGRectMake(mainScreen.size.height-40, 0, 40, 30);
    [btnExit setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5]] forState:UIControlStateHighlighted];
    [btnExit setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    
    [btnExit setImage:[UIImage imageNamed:@"exitbutton.png"] forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(btnEdit:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnExit];
    [self.view addSubview:view];
    [view release];
    
}
-(void)moveDown:(int)height{
    CGRect tableF=cameraList.frame;
    tableF.origin.y+=height;
    tableF.size.height-=height;
    cameraList.frame=tableF;
    
    int ImgViewWidth=(mainScreen.size.height-tableF.size.width)/2;
    int ImgViewHeight=(mainScreen.size.width-height)/2;
    CGRect firstImgFrame=CGRectMake(0, height, ImgViewWidth+1, ImgViewHeight+1);
    firstImgView.frame=firstImgFrame;
    CGRect secondImgFrame=CGRectMake(ImgViewWidth, height, ImgViewWidth, ImgViewHeight+1);
    secondImgView.frame=secondImgFrame;
    CGRect thirdImgFrame=CGRectMake(0, height+ImgViewHeight, ImgViewWidth+1, ImgViewHeight);
    thirdImgView.frame=thirdImgFrame;
    CGRect fourImgFrame=CGRectMake(ImgViewWidth, height+ImgViewHeight, ImgViewWidth, ImgViewHeight);
    fourImgView.frame=fourImgFrame;

    CGRect pushpullFrame=btnPush.frame;
    pushpullFrame.origin.y+=height;
    btnPush.frame=pushpullFrame;
    
    CGRect firstLabelFrame=firstLabel.frame;
    firstLabelFrame.origin.y+=30;
    firstLabel.frame=firstLabelFrame;
    CGRect secondLabelFrame=secondLabel.frame;
    secondLabelFrame.origin.y+=30;
    secondLabel.frame=secondLabelFrame;
    CGRect thirdLabelFrame=thirdLabel.frame;
    thirdLabelFrame.origin.y+=15;
    thirdLabel.frame=thirdLabelFrame;
    CGRect fourLabelFrame=fourLabel.frame;
    fourLabelFrame.origin.y+=15;
    fourLabel.frame=fourLabelFrame;
    
    CGRect progress1Frame=processView1.frame;
    progress1Frame.origin.y+=30;
    processView1.frame=progress1Frame;
    CGRect progress2Frame=processView2.frame;
    progress2Frame.origin.y+=30;
    processView2.frame=progress2Frame;
    CGRect progress3Frame=processView3.frame;
    progress3Frame.origin.y+=15;
    processView3.frame=progress3Frame;
    CGRect progress4Frame=processView4.frame;
    progress4Frame.origin.y+=15;
    processView4.frame=progress4Frame;
}
-(UIImage *)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0, 0, 40, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)btnPushAndPull{
    NSLog(@"MoreViewController.....btnPushAndPull()");
    [self showTableView];
    [self showFourViewFrame];
}

-(void)showTableView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect frame=cameraList.frame;
    NSLog(@"frame.origin.x1=%f",frame.origin.x);
    
    
    if (isShowTableView) {
        isShowTableView=NO;
        frame.origin.x+=200;
    }else{
        isShowTableView=YES;
        frame.origin.x-=200;
    }
    NSLog(@"frame.origin.x2=%f",frame.origin.x);
    cameraList.frame=frame;
    
    [UIView commitAnimations];
}
-(void)showFourViewFrame{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    
    //NSLog(@"moreW=%d",moreW);
    CGRect firstFrame=firstImgView.frame;
    CGRect secondFrame=secondImgView.frame;
    CGRect thirdFrame=thirdImgView.frame;
    CGRect fourFrame=fourImgView.frame;
    CGRect btnPushFrame=btnPush.frame;
    CGRect secondLabelFrame=secondLabel.frame;
    CGRect fourLabelFrame=fourLabel.frame;
    
    
    CGRect progressView1Frame=processView1.frame;
    CGRect progressView2Frame=processView2.frame;
    CGRect progressView3Frame=processView3.frame;
    CGRect progressView4Frame=processView4.frame;
    
//    CGRect imgHome1Frame=imgHome1.frame;
//    CGRect imgHome2Frame=imgHome2.frame;
//    CGRect imgHome3Frame=imgHome3.frame;
//    CGRect imgHome4Frame=imgHome4.frame;
    
    if (isShowTableView) {
        NSLog(@"push....moreW=%d",moreW);
        [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
        btnPushFrame.origin.x-=200;
        
        firstFrame.size.width-=100;
        thirdFrame.size.width-=100;
        
        secondFrame.origin.x-=100;
        secondFrame.size.width-=100;
        
        fourFrame.origin.x-=100;
        fourFrame.size.width-=100;
        
        secondLabelFrame.origin.x-=100;
        fourLabelFrame.origin.x-=100;
        
        progressView1Frame.origin.x-=50;
        progressView2Frame.origin.x-=150;
        progressView3Frame.origin.x-=50;
        progressView4Frame.origin.x-=150;
        
//        imgHome1Frame.origin.x-=moreW/2;
//        imgHome2Frame.origin.x-=moreW*3/2;
//        imgHome3Frame.origin.x-=moreW/2;
//        imgHome4Frame.origin.x-=moreW*3/2;
        
    }else{
        NSLog(@"pull....moreW=%d",moreW);
        [btnPush setBackgroundImage:[UIImage imageNamed:@"pull.png"] forState:UIControlStateNormal];
        btnPushFrame.origin.x+=200;
        
        firstFrame.size.width+=100;
        thirdFrame.size.width+=100;
        
        secondFrame.origin.x+=100;
        secondFrame.size.width+=100;
        
        fourFrame.origin.x+=100;
        fourFrame.size.width+=100;
        
        secondLabelFrame.origin.x+=100;
        fourLabelFrame.origin.x+=100;
        
        progressView1Frame.origin.x+=50;
        progressView2Frame.origin.x+=150;
        progressView3Frame.origin.x+=50;
        progressView4Frame.origin.x+=150;
        
//        imgHome1Frame.origin.x+=moreW/2;
//        imgHome2Frame.origin.x+=moreW*3/2;
//        imgHome3Frame.origin.x+=moreW/2;
//        imgHome4Frame.origin.x+=moreW*3/2;
//        
    }
    btnPush.frame=btnPushFrame;
    firstImgView.frame=firstFrame;
    secondImgView.frame=secondFrame;
    thirdImgView.frame=thirdFrame;
    fourImgView.frame=fourFrame;
    secondLabel.frame=secondLabelFrame;
    fourLabel.frame=fourLabelFrame;
    
    processView1.frame=progressView1Frame;
    processView2.frame=progressView2Frame;
    processView3.frame=progressView3Frame;
    processView4.frame=progressView4Frame;
    
//    imgHome1.frame=imgHome1Frame;
//    imgHome2.frame=imgHome2Frame;
//    imgHome3.frame=imgHome3Frame;
//    imgHome4.frame=imgHome4Frame;
    
    [UIView commitAnimations];
}
-(void)ShowMyDialog{
    isShowingDialog=!isShowingDialog;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    CGRect frame=myDialogView.frame;
    if (isShowingDialog) {
        frame.origin.y-=(thirdImgView.frame.origin.y-25)+50;
        //NSLog(@"minus  l=%f",thirdImgView.frame.origin.y-25);
    }else{
        frame.origin.y+=(thirdImgView.frame.origin.y-25)+50;
        // NSLog(@"add  l=%f",thirdImgView.frame.origin.y-25);
    }
    
    myDialogView.frame=frame;
    [UIView commitAnimations];
}
- (void) ImageViewPressed:(UIGestureRecognizer *)recognizer
{
    UIView *view = [recognizer view];
    NSInteger index = view.tag;
    
    [myDialogView setTagClick:index];
    
    switch (index) {
        case 1:
            if (firstID!=nil) {
                [self ShowMyDialog];
            }
            break;
        case 2:
            if (secondID!=nil) {
                [self ShowMyDialog];
            }
            break;
        case 3:
            if (thirdID!=nil) {
                [self ShowMyDialog];
            }
            break;
        case 4:
            if (fourID!=nil) {
                [self ShowMyDialog];
            }
            break;
        default:
            break;
    }
    
}
-(void)ImageViewDoubleTapped:(UITapGestureRecognizer *)recognizer{
    NSLog(@"ImageViewDoubleTapped");
    
    if (isFullScreen) {
        NSLog(@"fullscreen");
        return;
    }
    
    UIView *view = [recognizer view];
    NSInteger index = view.tag;
    NSString *did=nil;
    isFullScreen=YES;
    
    switch (index) {
        case 1:
            if (firstID!=nil) {
                did=firstID;
                processView1.hidden=NO;
                [processView1 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 2:
            if (secondID!=nil) {
                did=secondID;
                processView2.hidden=NO;
                [processView2 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 3:
            if (thirdID!=nil) {
                did=thirdID;
                processView3.hidden=NO;
                [processView3 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
        case 4:
            if (fourID!=nil) {
                did=fourID;
                processView4.hidden=NO;
                [processView4 startAnimating];
            }else{
                isFullScreen=NO;
                return;
            }
            
            break;
            
        default:
            break;
    }
    
    
    if (firstID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
    }
    if (secondID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
        
    }
    if (thirdID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
        
    }
    if (fourID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
        
    }
    
    if (did==nil) {
        isFullScreen=NO;
        return;
    }
 
    [self performSelector:@selector(fullView:) withObject:did afterDelay:3];
    
    return;
    
}
-(void)fullView:(NSString *)did{
    
    if (!isShowTableView) {
        NSLog(@"在全屏下的全屏。。。");
        [self btnPushAndPull];
    }else{
      NSLog(@"不在全屏下的全屏。。。");
    }
    
    int count=[cameraListMgt GetCount];
    NSString *name=@"";
    for (int i=0; i<count; i++) {
        NSDictionary *dic=[cameraListMgt GetCameraAtIndex:i];
        NSString *_did=[dic objectForKey:@STR_DID];
        if ([_did caseInsensitiveCompare:did]==NSOrderedSame) {
            name=[dic objectForKey:@STR_NAME];
            break;
        }
        
    }
    
    processView1.hidden=YES;
    processView2.hidden=YES;
    processView3.hidden=YES;
    processView4.hidden=YES;
    [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
    
    
    PlayViewController *playViewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
        
    }else{
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_Ipad" bundle:nil];
        
    }
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.PicNotifyDelegate = picViewController;
    playViewController.RecNotifyDelegate = recViewController;
    
    playViewController.strDID =did;
    playViewController.cameraName=name;
    playViewController.m_nP2PMode=1;
    playViewController.isMoreView=YES;
    playViewController.isP2P=YES;
    playViewController.playViewResultDelegate=self;
    //    playViewController.cameraName = strName;
    //    playViewController.m_nP2PMode = [nPPPPMode intValue];
    //[playViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //    [self presentViewController:playViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:playViewController animated:YES];
    
    //[IPCamDelegate switchPlayView:playViewController];
    [self presentModalViewController:playViewController animated:YES];
    [playViewController release];
}

-(void)ImageViewLongPressed:(UILongPressGestureRecognizer *)recognizer{
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        UIView *view = [recognizer view];
        
        
        NSString *did=nil;
        switch (view.tag) {
            case 1:
                if (firstID!=nil) {
                    did=firstID;
                    firstID=nil;
                }
                firstImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                firstLabel.hidden=YES;
                processView1.hidden=YES;
                break;
            case 2:
                if (secondID!=nil) {
                    did=secondID;
                    secondID=nil;
                }
                secondImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                secondLabel.hidden=YES;
                processView2.hidden=YES;
                break;
            case 3:
                if (thirdID!=nil) {
                    did=thirdID;
                    thirdID=nil;
                }
                thirdImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                thirdLabel.hidden=YES;
                processView3.hidden=YES;
                break;
            case 4:
                if (fourID!=nil) {
                    did=fourID;
                    fourID=nil;
                }
                fourImgView.image=[UIImage imageNamed:@"moreviewback.png"];
                fourLabel.hidden=YES;
                processView4.hidden=YES;
                break;
            default:
                break;
        }
        if (did!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
        }
        
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    //NSLog(@"init viewWillAppear");
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    if (isFullScreen) {
        isFullScreen=NO;
        isViewDisappear=NO;
        if (firstID!=nil) {
            pPPPPChannelMgt->CameraControl([firstID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([firstID UTF8String], 10, self);
        }
        if (secondID!=nil) {
            pPPPPChannelMgt->CameraControl([secondID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([secondID UTF8String], 10, self);
        }
        
        if (thirdID!=nil) {
            pPPPPChannelMgt->CameraControl([thirdID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([thirdID UTF8String], 10, self);
        }
        
        if (fourID!=nil) {
            pPPPPChannelMgt->CameraControl([fourID UTF8String], 0, 1);
            pPPPPChannelMgt->StartPPPPLivestream([fourID UTF8String], 10, self);
        }
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(EnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}
-(void)EnterBackground{
    isViewDisappear=YES;
    NSLog(@"MoreViewController....EnterBackground");
}

//摄像机连接时的提示宽
-(void)InitCameraProcess:(NSString *)tag{
    int count = [cameraListMgt GetCount];
    //NSLog(@"count=%d",count);
    if (count<=0) {
        //[self GetUpdate];
        return;
    }
    alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"ingInitCamera", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    //alertView.frame=CGRectMake(10.0f, 100.0f, 240.0f, 200.0f);
    
    UIActivityIndicatorView *activeView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeView.center=CGPointMake(alertView.bounds.size.width/2, alertView.bounds.size.height-40);
    [activeView startAnimating];
    [alertView addSubview:activeView];
    [activeView release];
//    timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(AlertDismiss) userInfo:nil repeats:NO];
//    timer=nil;
    
    [self performSelector:@selector(AlertDismiss) withObject:tag afterDelay:3];
}

-(void)AlertDismiss:(NSString *)tag{
    // NSLog(@"AlertDismiss  000000");
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    
    
    
    NSString *did=nil;
    isFullScreen=YES;
    int index=[tag intValue];
    switch (index) {
        case 1:
            did=firstID;
            break;
        case 2:
            did=secondID;
            break;
        case 3:
            did=thirdID;
            break;
        case 4:
            did=fourID;
            break;
            
        default:
            break;
    }
    
    if (firstID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
    }
    if (secondID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
        
    }
    if (thirdID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
        
    }
    if (fourID!=nil) {
        pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
        
    }
    
    if (did==nil) {
        return;
    }
    
    [btnPush setBackgroundImage:[UIImage imageNamed:@"push.png"] forState:UIControlStateNormal];
    PlayViewController *playViewController=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
        
    }else{
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_Ipad" bundle:nil];
        
    }
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.PicNotifyDelegate = picViewController;
    playViewController.RecNotifyDelegate = recViewController;
    
    playViewController.strDID =did;
    playViewController.cameraName=@"p2pip";
    playViewController.m_nP2PMode=1;
    playViewController.isMoreView=YES;
    playViewController.isP2P=YES;
   
    [self presentModalViewController:playViewController animated:YES];
    [playViewController release];
}
- (void) StartPPPPThread
{
    //NSLog(@"StartPPPPThread");
    [ppppChannelMgntCondition lock];
    if (pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];
    [ppppChannelMgntCondition unlock];
}

- (void)viewDidUnload {
    [super viewDidUnload];
   
    //[cameraListMgt release];
    //cameraListMgt = nil;
   
   
}

- (void)dealloc {
    NSLog(@"moreview   dealloc");
    isMoreViewOver=YES;
    
    self.cameraList = nil;
    
    cameraListMgt=nil;
    pPPPPChannelMgt=nil;
    m_pPicPathMgt=nil;
    m_pRecPathMgt=nil;
    [ppppChannelMgntCondition release];
    self.navigationBar = nil;
    self.cameraListMgt = nil;
    self.PicNotifyEventDelegate = nil;
    self.RecordNotifyEventDelegate = nil;
    self.m_pPicPathMgt = nil;
    self.alertView=nil;
   
    firstID=nil;
    secondID=nil;
    thirdID=nil;
    fourID=nil;
    [myDialogView release];
    myDialogView=nil;
    btnPush=nil;
    [super dealloc];
}



#pragma mark -
#pragma mark UserPwdProtocol

-(void)UserProtocolResult:(STRU_USER_INFO)t{
  
        [cameraListMgt UpdateCameraAuthority:[NSString stringWithUTF8String:t.did] User:[NSString stringWithUTF8String:t.user3] Pwd:[NSString stringWithUTF8String:t.pwd3]];
    
}

#pragma mark -
#pragma mark EditCameraProtocol

- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
{
    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
    
    BOOL bRet;
    
    if (bAdd == YES) {
        int sum=[cameraListMgt GetCount];
        NSLog(@"camera sum=%d",sum);
        
        if (sum>=20) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"cameraNumOut", @STR_LOCALIZED_FILE_NAME, nil)];
            return NO;
        }
        
        bRet = [cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
    }else {
        bRet = [cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
    }
    
    if (bRet == YES) {
        
        if (bAdd) {//添加成功，增加P2P连接
            pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
        }else {//修改成功，重新启动P2P连接
            pPPPPChannelMgt->Stop([did UTF8String]);
            pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
            [self btnEdit:nil];
        }
        
        if (bEditMode && [olddid caseInsensitiveCompare:did] != NSOrderedSame) {
            [m_pPicPathMgt RemovePicPathByID:olddid];
        }
        
        //添加或修改设备成功，重新加载设备列表
        [cameraList reloadData];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        
    }
    
    NSLog(@"bRet: %d", bRet);
    
    return bRet;
}

#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    if (isMoreViewOver) {
        return;
    }
  
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {
        NSInteger index = [cameraListMgt UpdatePPPPMode:strDID mode:status];
        if ( index >= 0){
            
        }
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        NSInteger index = [cameraListMgt UpdatePPPPStatus:strDID status:status];
        if ( index >= 0){
           
            if (status==PPPP_STATUS_ON_LINE) {//
                
            }else{
                
               
               [self performSelectorOnMainThread:@selector(notifyCameraStatusChange) withObject:nil waitUntilDone:NO];
                
            }
            [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED||statusType==PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
        }
        
        NSArray *arr=[NSArray arrayWithObjects:strDID,[NSString stringWithFormat:@"%d",status], nil];
        [self performSelectorOnMainThread:@selector(statusDisconnect:) withObject:arr waitUntilDone:NO];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        return;
    }
}
-(void)notifyCameraStatusChange{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statuschange" object:nil];
    
}
-(void)statusDisconnect:(NSArray *)arr{
    NSString *did=[arr objectAtIndex:0];
    int status=[[arr objectAtIndex:1] integerValue];
    if (status!=PPPP_STATUS_ON_LINE) {
        if ([did caseInsensitiveCompare:firstID]==NSOrderedSame) {
            firstImgView.image=[UIImage imageNamed:@"moreviewback.png"];
            firstLabel.hidden=YES;
            processView1.hidden=YES;
            firstID=nil;
           
        }
        if ([did caseInsensitiveCompare:secondID]==NSOrderedSame) {
            secondImgView.image=[UIImage imageNamed:@"moreviewback.png"];
            secondLabel.hidden=YES;
            processView2.hidden=YES;
            secondID=nil;
            
        }
        if ([did caseInsensitiveCompare:thirdID]==NSOrderedSame) {
            thirdImgView.image=[UIImage imageNamed:@"moreviewback.png"];
            thirdLabel.hidden=YES;
            processView3.hidden=YES;
            thirdID=nil;
            
        }
        if ([did caseInsensitiveCompare:fourID]==NSOrderedSame) {
            fourImgView.image=[UIImage imageNamed:@"moreviewback.png"];
            fourLabel.hidden=YES;
            processView4.hidden=YES;
            fourID=nil;
            
        }        
    }
}

-(void)updateAuthority:(NSString *)did{
    //NSLog(@"updateAuthority  00000  did=%@",did);
    
    sleep(1);
    pPPPPChannelMgt->SetUserPwdParamDelegate((char*)[did UTF8String], self);
    pPPPPChannelMgt->PPPPSetSystemParams((char*)[did UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

#pragma mark -
#pragma mark PerformInMainThread

- (void) ReloadCameraTableView
{
    [cameraList reloadData];
}

- (void) ReloadRowDataAtIndex: (NSNumber*) indexNumber
{
    //NSLog(@"ReloadRowDataAtIndex %d", [indexNumber intValue]);
    
    NSInteger index = [indexNumber intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [cameraList cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        //        int row;
        //        index += 1;
        //        row = (index % 2 > 0) ? index / 2 + 1 : index / 2;
        //
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [cameraList reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void) StopPPPPByDID:(NSString*)did
{
    pPPPPChannelMgt->Stop([did UTF8String]);
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    
    [pool release];
    
    
}

#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length
{
    //NSLog(@"CameraViewController SnapshotNotify... strDID: %@, length: %d", strDID, length);
    if (length < 20) {
        return;
    }
    
    //显示图片
    NSData *image = [[NSData alloc] initWithBytes:data length:length];
    if (image == nil) {
        //NSLog(@"SnapshotNotify image == nil");
        [image release];
        return;
    }
    
    UIImage *img = [[UIImage alloc] initWithData:image];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
    
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        
        [self saveSnapshot:imgScale DID:strDID];
        
        //NSLog(@"UpdateCamereaImage success!");
        [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        //[self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
    }
    
    [pool release];
    
    [img release];
    [image release];
    
}
-(void)updateImg:(NSMutableArray *)arr{
    if (isViewDisappear) {
        return;
    }
    NSString *did=[arr objectAtIndex:0];
    //NSLog(@"updateImg...did=%@",did);
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            if (firstImg==nil) {
                return;
            }
            firstImgView.image=firstImg;
            processView1.hidden=YES;
            [firstImg release];
            firstImg=nil;
            
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            if (secondImg==nil) {
                return;
            }
            secondImgView.image=secondImg;
            processView2.hidden=YES;
            [secondImg release];
            secondImg=nil;
           
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            if (thirdImg==nil) {
                return;
            }
            thirdImgView.image=thirdImg;
            processView3.hidden=YES;
            [thirdImg release];
            thirdImg=nil;
            
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            if (fourImg==nil) {
                return;
            }
            fourImgView.image=fourImg;
            processView4.hidden=YES;
            [fourImg release];
            fourImg=nil;
            
        }
    }
    
    [arr removeAllObjects];
    [arr release];
}
#pragma mark PPPPStatusDelegate

#pragma mark ParamNotify

- (void) ParamNotify:(int)paramType params:(void *)params
{
    NSLog(@"paramType=%d",paramType);
}
#pragma mark- ImageNotify
-(void)ImageData:(Byte *)buf Length:(int)len timestamp:(NSInteger)timestamp{}
- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    if (isMoreViewOver) {
        return;
    }
   // NSLog(@"Img....did=%@  width=%f",did,image.size.width);
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [image retain];
    
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            firstImg=image;
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            secondImg=image;
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            thirdImg=image;
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            fourImg=image;
        }
    }
    [arr addObject:did];
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:arr waitUntilDone:NO];
}
- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    if (isMoreViewOver) {
        return;
    }
   // NSLog(@"YUV.....width=%d  did=%@",width,did);
    UIImage *image=[APICommon YUV420ToImage:yuv width:width height:height];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [image retain];
    
    if (firstID!=nil) {
        if ([did isEqualToString:firstID]) {
            firstImg=image;
        }
    }
    if (secondID!=nil) {
        if ([did isEqualToString:secondID]) {
            secondImg=image;
        }
    }
    
    if (thirdID!=nil) {
        if ([did isEqualToString:thirdID]) {
            thirdImg=image;
        }
    }
    
    if (fourID!=nil) {
        if ([did isEqualToString:fourID]) {
            fourImg=image;
        }
    }
    [arr addObject:did];
    [self performSelectorOnMainThread:@selector(updateImg:) withObject:arr waitUntilDone:NO];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did{
    
}

#pragma MyDialogDelegate
-(void)dialogBtnClick:(int)index Tag:(int)tag{
    [self ShowMyDialog];
    
    NSLog(@"index=%d tag=%d",index,tag);
    NSString *did=nil;
    
    switch (tag) {
        case 1:
            
            processView1.hidden=YES;
            if (index==1) {
                
                firstLabel.hidden=YES;
                if (firstID!=nil) {
                    did=firstID;
                    firstID=nil;
                }
                firstImgView.image=defaultImg;
                
                if (did!=nil) {
                    pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
                    
                }
            }else{
                isFullScreen=YES;
                did=firstID;
            }
            break;
        case 2:
            
            processView2.hidden=YES;
            if (index==1) {
                secondLabel.hidden=YES;
                if (secondID!=nil) {
                    did=secondID;
                    secondID=nil;
                }
                secondImgView.image=defaultImg;
                
                if (did!=nil) {
                    pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
                    
                }
            }else{
                isFullScreen=YES;
                did=secondID;
            }
            
            break;
        case 3:
            
            processView3.hidden=YES;
            if (index==1) {
                thirdLabel.hidden=YES;
                if (thirdID!=nil) {
                    did=thirdID;
                    thirdID=nil;
                }
                thirdImgView.image=defaultImg;
                
                if (did!=nil) {
                    pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
                    
                }
            }else{
                did=thirdID;
                isFullScreen=YES;
            }
            break;
        case 4:
            
            processView4.hidden=YES;
            if (index==1) {
                fourLabel.hidden=YES;
                if (fourID!=nil) {
                    did=fourID;
                    fourID=nil;
                }
                fourImgView.image=defaultImg;
                
                if (did!=nil) {
                    pPPPPChannelMgt->StopPPPPLivestream([did UTF8String]);
                    
                }
            }else{
                isFullScreen=YES;
                did=fourID;
            }
            
            break;
            
        default:
            break;
    }
    
    if (isFullScreen) {
        if (firstID!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([firstID UTF8String]);
        }
        if (secondID!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([secondID UTF8String]);
        }
        if (thirdID!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([thirdID UTF8String]);
        }
        if (fourID!=nil) {
            pPPPPChannelMgt->StopPPPPLivestream([fourID UTF8String]);
        }
        
        
       // IpCameraClientAppDelegate *IPCamDelegate =  [[UIApplication sharedApplication] delegate] ;
        PlayViewController *playViewController=nil;
//        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
//            playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
//            
//        }else{
//            playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_ipad" bundle:nil];
//            
//        }
        
        playViewController = [[PlayViewController alloc]init];
        playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
        playViewController.m_pPicPathMgt = m_pPicPathMgt;
        playViewController.m_pRecPathMgt = m_pRecPathMgt;
        playViewController.PicNotifyDelegate = picViewController;
        playViewController.RecNotifyDelegate = recViewController;
        
        playViewController.strDID =did;
        playViewController.cameraName=@"p2pip";
        playViewController.m_nP2PMode=1;
        playViewController.isMoreView=YES;
        //    playViewController.cameraName = strName;
        //    playViewController.m_nP2PMode = [nPPPPMode intValue];
        //[playViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        //    [self presentViewController:playViewController animated:YES completion:nil];
        //[self.navigationController pushViewController:playViewController animated:YES];
        
        //[IPCamDelegate switchPlayView:playViewController];
        [self presentModalViewController:playViewController animated:YES];
        [playViewController release];
    }
}

#pragma mark--PlayViewExitResultProtocol
-(void)playViewExitResultImg:(UIImage *)img DID:(NSString *)did{
    
    NSLog(@"playViewExitResultImg...did=%@",did);
    if (img!=nil) {
        NSLog(@"playViewExitResultImg...img..");
        
        
        
        UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
        NSInteger index = [cameraListMgt UpdateCamereaImage:did  Image:imgScale] ;
        if (index>=0) {
            [self saveSnapshot:imgScale DID:did];
            
            [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        
        
    }else{
        NSLog(@"playViewExitResultImg...img＝＝nil..");
    }
    
}
@end
