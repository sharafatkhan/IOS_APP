
//  CameraViewController.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraEditViewController.h"
#import "CameraListCell.h"
#import "IpCameraClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
#import "mytoast.h"
#include "MyAudioSession.h"
#import "SettingViewController.h"
#import "AddCameraCell.h"
#import "CameraEditViewController.h"
#import "MoreViewController.h"
#import "KGStatusBar.h"
#import "FourViewController.h"

// Code Begin


#import "RequestClass.h"
#import "SubscriptionViewController.h"
#import "InAppAlertView.h"

#define loginRequest 1
#define cameraAccessRequest 2

@interface CameraViewController()<RequestClassDelegate>
{
    NSInteger isUserSubscribed;
    InAppAlertView *objInAppAlertView;
    NSInteger subscriptonStatus;
}
@property (nonatomic, retain) RequestClass *connection;

@end

// Code Ends


@implementation CameraViewController

@synthesize cameraList;
@synthesize navigationBar;

@synthesize btnAddCamera;
@synthesize alertView;

@synthesize cameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize PicNotifyEventDelegate;
@synthesize RecordNotifyEventDelegate;
@synthesize alarmNotifyEventDelegate;
@synthesize m_pRecPathMgt;
@synthesize pPPPPChannelMgt;

@synthesize picViewController;
@synthesize recViewController;

@synthesize setDialog;
@synthesize isP2P;
@synthesize netWorkUtile;

@synthesize appStoreVersion;
#pragma mark -
#pragma mark button presss handle

- (void) StartPlayView: (NSInteger)index
{
    
    NSDictionary *cameraDic =nil;
    NSString *strDID =@"";
    NSString *strName =@"";
    NSNumber *nPPPPMode =nil;
    
    NSString *port =@"";
    NSString *ip =@"";
    NSString *user=@"";
    NSString *pwd=@"";
    int authority=USER_NOTAUTHORITY;
    int modal=0;
    if (isP2P) {
        cameraDic = [cameraListMgt GetCameraAtIndex:index];
        if (cameraDic == nil) {
            return;
        }
        strDID = [cameraDic objectForKey:@STR_DID];
        strName = [cameraDic objectForKey:@STR_NAME];
        nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
        authority=[[cameraDic objectForKey:@STR_AUTHORITY] integerValue];
        modal=[[cameraDic objectForKey:@STR_MODAL] integerValue];
        user=[cameraDic objectForKey:@STR_USER];
        pwd=[cameraDic objectForKey:@STR_PWD];
    }else{
        cameraDic = [cameraListMgt GetIpCameraAtIndex:index];
        port = [cameraDic objectForKey:@STR_PORT];
        ip = [cameraDic objectForKey:@STR_IPADDR];
        user=[cameraDic objectForKey:@STR_USER];
        pwd=[cameraDic objectForKey:@STR_PWD];
        strName = [cameraDic objectForKey:@STR_NAME];
    }
    
    IpCameraClientAppDelegate *IPCamDelegate =  [[UIApplication sharedApplication] delegate] ;
    
    //PlayViewController *playViewController=[[PlayViewController alloc]init];
    KXPlayViewController *playViewController=[[KXPlayViewController alloc]init];
    netWorkUtile.networkProtocol=nil;
    playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    playViewController.m_pPicPathMgt = m_pPicPathMgt;
    playViewController.m_pRecPathMgt = m_pRecPathMgt;
    playViewController.PicNotifyDelegate = picViewController;
    playViewController.RecNotifyDelegate = recViewController;
    playViewController.isP2P=isP2P;
    playViewController.cameraName = strName;
    playViewController.mAuthority=authority;
    playViewController.mModal=modal;
    
    NSLog(@"------ playView mAuthority(%d)",authority);
    //p2p
    playViewController.strDID = strDID;
    playViewController.m_nP2PMode =1;// [nPPPPMode intValue];
    //ddns
    playViewController.m_strUser=user;
    playViewController.m_strPwd=pwd;
    playViewController.m_strIp=ip;
    playViewController.m_strPort=port;
    playViewController.playViewResultDelegate=self;
    playViewController.netUtiles=netWorkUtile;
    
    
    //[playViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //    [self presentViewController:playViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:playViewController animated:YES];
   
    [IPCamDelegate switchPlayView:playViewController];
    
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
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES];
    [cameraEditViewController release];
    
    // [cameraListMgt AddCamera:@"aaaaa" DID:@"bbbbb" User:@"dsfsfs" Pwd:@"" Snapshot:nil];
}

- (void) btnEdit:(id)sender
{
    //NSLog(@"btnEdit");
    
    if (!bEditMode) {
        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }else {
        [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    bEditMode = ! bEditMode;
    [self setNavigationBarItem:bEditMode];
    
    [cameraList reloadData];
}

- (void) setNavigationBarItem: (BOOL) abEditMode
{
    
    
    
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_normal.png"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"done_pressed.png"] forState:UIControlStateHighlighted];
    
    btnRight.frame=CGRectMake(0,0,50,30);
    [btnRight addTarget:self action:@selector(btnEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    
    if (!abEditMode) {
        [btnRight setTitle:NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        
        
        if (![IpCameraClientAppDelegate is43Version]) {
            rightButton.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        }
        
    }else {
        [btnRight setTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        
        
    }
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)];
//    UILabel *labelTile=[[UILabel alloc]init];
//    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
//    labelTile.font=[UIFont systemFontOfSize:18];
//    labelTile.textColor=[UIColor whiteColor];
//    labelTile.textAlignment=UITextAlignmentCenter;
//    labelTile.backgroundColor=[UIColor clearColor];
//    labelTile.text= NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
//    naviItem.titleView=labelTile;
//    [labelTile release];
//    
    
    
    UIButton *btnHome=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:@"fourview.png"];
    btnHome.frame=CGRectMake(0, 0, 30, 30);
    [btnHome addTarget:self action:@selector(btnChangeP2PAndDDNS) forControlEvents:UIControlEventTouchUpInside];
    [btnHome setImage:img forState:UIControlStateNormal];
   
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(120, 0, 90, 30);
    label.textColor=[UIColor whiteColor];
    label.text=@"";
    label.backgroundColor=[UIColor clearColor];
    
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, 120, 30);
    view.backgroundColor=[UIColor clearColor];
    [view addSubview:btnHome];
    [view addSubview:label];
    [label release];
    
    UIBarButtonItem *leftImg=[[UIBarButtonItem alloc]initWithCustomView:view];
    
    [view release];
    
    naviItem.rightBarButtonItem = rightButton;
    naviItem.leftBarButtonItem=leftImg;
    [leftImg release];
    [rightButton release];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];
    
}

-(void)btnChangeP2PAndDDNS{
    // NSLog(@"CameraViewController btnChangeP2PAndDDNS()");
    //    [self showSetDialog:isSetDialogShow];
    //    isSetDialogShow=!isSetDialogShow;
  
    IpCameraClientAppDelegate *delegate=[UIApplication sharedApplication].delegate;
    delegate.isOnPlayView=YES;
    
    isMoreViewLoad=YES;
    
    FourViewController *moreView=[[FourViewController alloc]init];
    moreView.cameraListMgt=cameraListMgt;
    moreView.pPPPPChannelMgt=pPPPPChannelMgt;
    moreView.m_pPicPathMgt = m_pPicPathMgt;
    moreView.m_pRecPathMgt = m_pRecPathMgt;
    moreView.picViewController=picViewController;
    moreView.recViewController=recViewController;
    moreView.PicNotifyEventDelegate = picViewController;
    moreView.RecordNotifyEventDelegate = recViewController;
    moreView.moreViewExitDelegate=self;
    [delegate enterMoreView:moreView];
    [moreView release];
}
#pragma mark -
#pragma mark TableViewDelegate

//删除设备的处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"commitEditingStyle");
    if (isP2P) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:indexPath.row];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        
        STRUCT_JPUSH_PARAM jpt;
        strcpy(jpt.appkey, JPUSH_APPKEY);
        IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication]delegate];
        NSString *alias=[delegate getJPushAlias];
        if (alias!=nil) {
            strcpy(jpt.alias, [alias UTF8String]);
            jpt.type=3;
            pPPPPChannelMgt->deleJPushParam((char*)[strDID UTF8String], jpt);
        }
        

        
        if(YES == [cameraListMgt RemoveCameraAtIndex:indexPath.row]){
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
            
            if ([cameraListMgt GetCount] == 0) {
                [self btnEdit:nil];
            }
            
            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:strDID,@"did",[NSNumber numberWithBool:YES],@"flag", nil];
            
            IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            [delegate deleteDeviceFromBizServer:dic2];
            //[self deleteDeviceFromBizServer:dic2];
            
        }
        
        
    }else{
        
        if(YES == [cameraListMgt RemoveIpCameraAtIndex:indexPath.row]){
            if ([cameraListMgt GetCount] > 0) {
                [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            //        [m_pPicPathMgt RemovePicPathByID:strDID];
            //        [m_pRecPathMgt RemovePathByID:strDID];
            
            //        [PicNotifyEventDelegate NotifyReloadData];
            //        [RecordNotifyEventDelegate NotifyReloadData];
            
            if ([cameraListMgt GetCount] == 0) {
                [self btnEdit:nil];
                
            }
            
        }
        
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (bEditMode == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
-(void)accessoryViewTap:(id)sender{
    NSLog(@"accessoryViewTap");
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    int index=[cameraList indexPathForCell:cell].row;
    index=btn.tag;
    if (isP2P) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
        if (cameraDic == nil) {
            return;
        }
        
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_USER_PWD) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        if ([nPPPPStatus intValue] != PPPP_STATUS_LAN&&[nPPPPStatus intValue] !=PPPP_STATUS_WLAN) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
        NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];
        int authority=[num integerValue];
        
        if (authority!=USER_ADMIN) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)];
            return ;
        }
        
        SettingViewController *settingView = [[SettingViewController alloc] init];
        settingView.m_pPPPPChannelMgt = pPPPPChannelMgt;
        settingView.m_strDID = [cameraDic objectForKey:@STR_DID];
        settingView.mName=[cameraDic objectForKey:@STR_NAME];
        settingView.m_strUser=[cameraDic objectForKey:@STR_USER];
        settingView.m_strPwd=[cameraDic objectForKey:@STR_PWD];
        settingView.mModal=[[cameraDic objectForKey:@STR_MODAL] integerValue];
        settingView.cameraListMgt=cameraListMgt;
        settingView.isP2P=isP2P;
        [self.navigationController pushViewController:settingView animated:YES];
        [settingView release];
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    int index = anIndexPath.row ;
    if (isP2P) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
        if (cameraDic == nil) {
            return;
        }
        
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_USER_PWD) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
            return;
        }
        
        NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];
        int authority=[num integerValue];
        
        if (authority!=USER_ADMIN) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"noadmin", @STR_LOCALIZED_FILE_NAME, nil)];
            return ;
        }
        
        SettingViewController *settingView = [[SettingViewController alloc] init];
        settingView.m_pPPPPChannelMgt = pPPPPChannelMgt;
        settingView.m_strDID = [cameraDic objectForKey:@STR_DID];
        settingView.mName=[cameraDic objectForKey:@STR_NAME];
        settingView.m_strUser=[cameraDic objectForKey:@STR_USER];
        settingView.m_strPwd=[cameraDic objectForKey:@STR_PWD];
        settingView.mModal=[[cameraDic objectForKey:@STR_MODAL] integerValue];
        settingView.cameraListMgt=cameraListMgt;
        settingView.isP2P=isP2P;
        [self.navigationController pushViewController:settingView animated:YES];
        [settingView release];
    }else{
        
        NSMutableDictionary *cameraDic=[cameraListMgt GetIpCameraAtIndex:index];
        if (cameraDic == nil) {
            return;
        }
        //请求用户名和密码
        netWorkUtile.userProtocol=self;
        netWorkUtile.networkProtocol=self;
        [netWorkUtile getCameraParam:[cameraDic objectForKey:@STR_IPADDR] Port:[cameraDic objectForKey:@STR_PORT] User:[cameraDic objectForKey:@STR_USER] Pwd:[cameraDic objectForKey:@STR_PWD] ParamType:3];
        NSLog(@"accessoryButton...ParamType:3");
        
        //        SettingViewController *settingView = [[SettingViewController alloc] init];
        //        settingView.m_strIp = [cameraDic objectForKey:@STR_IPADDR];
        //        settingView.m_strPort=[cameraDic objectForKey:@STR_PORT];
        //        settingView.mName=[cameraDic objectForKey:@STR_NAME];
        //        settingView.isP2P=isP2P;
        //        settingView.netUtiles=netWorkUtile;
        //        settingView.m_strUser=[cameraDic objectForKey:@STR_USER];
        //        settingView.m_strPwd=[cameraDic objectForKey:@STR_PWD];
        //        NSLog(@"accessory  m_strPwd=%@",[cameraDic objectForKey:@STR_PWD]);
        //        [self.navigationController pushViewController:settingView animated:YES];
        //        [settingView release];
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (bEditMode) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");
    
    
    int count = [cameraListMgt GetCount];
    
    if (bEditMode) {
        return count;
    }
    
    if (section==0) {
        return 1;
    }else{
        return count ;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    
    NSInteger index = anIndexPath.row ;
    
    //-----------------------------------------------------------------------------------
    
    
    if (bEditMode) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
        NSString *name = [cameraDic objectForKey:@STR_NAME];
        NSString *did = [cameraDic objectForKey:@STR_DID];
        
        NSString *cellIdentifier = @"CameraListEditCell";
        //当状态为显示当前的设备列表信息时
        UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            [cell autorelease];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = name;
        cell.detailTextLabel.text = did;
        
        return cell;
    }
    if (anIndexPath.section==0) {
        
        
        //index = 0显示添加摄像机
        if (index == 0) {
            NSString *cellIdentifier = @"AddCameraCell";
            //当状态为显示当前的设备列表信息时
            AddCameraCell *cell =  (AddCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                
                UINib *nib=[UINib nibWithNibName:@"AddCameraCell" bundle:nil];
                [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
              
                cell =  (AddCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];

            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.labelAddCamera.text = NSLocalizedStringFromTable(@"TouchAddCamera", @STR_LOCALIZED_FILE_NAME, nil);
            
            float cellHeight = cell.frame.size.height;
            //float cellWidth = cell.frame.size.width;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, mainScreen.size.width, cellHeight - 1)];
            label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
            
            UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
            [cellBgView addSubview:label];
            [label release];
            
            [cellBgView release];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(0, 0, 40, 40);
            [btn setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=btn;
            // cell.backgroundView = cellBgView;
            
            return cell;
        }
    }
    //index -= 1;
    NSDictionary *cameraDic =nil;
    NSString *name =@"";
    UIImage *img =nil;
    NSNumber *nPPPPStatus =nil;
    NSString *did =@"";
    if (isP2P) {
        cameraDic = [cameraListMgt GetCameraAtIndex:index];
        name=[cameraDic objectForKey:@STR_NAME];
        img = [cameraDic objectForKey:@STR_IMG];
        nPPPPStatus =[cameraDic objectForKey:@STR_PPPP_STATUS];
        did = [cameraDic objectForKey:@STR_DID];
    }else{
        cameraDic =[cameraListMgt GetIpCameraAtIndex:index];
        name=[cameraDic objectForKey:@STR_NAME];
        img = [cameraDic objectForKey:@STR_IMG];
        did = [cameraDic objectForKey:@STR_IPADDR];
    }
    
    
    //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    
    
    NSString *cellIdentifier = @"CameraListCell";
    //当状态为显示当前的设备列表信息时
    CameraListCell *cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        UINib *nib=[UINib nibWithNibName:@"CameraListCell" bundle:nil];
        [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    }
    
   // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    int PPPPStatus = [nPPPPStatus intValue];
    
    
    if (img != nil) {
        //NSLog(@"img!=nil");
        cell.imageCamera.image = img;
    }else{
       // NSLog(@"img==nil");
        cell.imageCamera.image= [UIImage imageNamed:@"back.png"];
    }
    
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did;
    
    
    
    float cellHeight = cell.frame.size.height;
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, cellHeight,cellHeight);
    [btn setImage:[UIImage imageNamed:@"camera_menu.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(accessoryViewTap:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=index;
    cell.accessoryView=btn;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    cellBgView.backgroundColor=[UIColor clearColor];
    [cellBgView addSubview:label];
    if (isIOS7) {
        cell.backgroundView=cellBgView;
    }
    
    [label release];
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
//        case PPPP_STATUS_ON_LINE:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
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
    if (isP2P) {
        cell.PPPPStatusLable.text = strPPPPStatus;
    }else{
        cell.PPPPStatusLable.text =@"DDNS";
    }
    
    
   	return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (bEditMode) {
        return 50;
    }
    if (indexpath.section==0) {
        return 44;
    }
    
    //    if (indexpath.row == 0) {
    //        return 44;
    //    }
    //
    return 74;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    
    
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    
    
    //NSLog(@"didSelectRowAtIndexPath");
    if (bEditMode == YES) {
        [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
        
        
        CameraEditViewController *cameraEditViewController = [[[CameraEditViewController alloc] init] autorelease];
        
        NSDictionary *cameraDic = nil;
        
        if (isP2P) {
            cameraDic = [cameraListMgt GetCameraAtIndex:anIndexPath.row];
            cameraEditViewController.editCameraDelegate = self;
            cameraEditViewController.bAddCamera = NO;
            cameraEditViewController.isP2P=isP2P;
            cameraEditViewController.cameraListMgt=cameraListMgt;
            cameraEditViewController.strCameraName = [cameraDic objectForKey:@STR_NAME];
            cameraEditViewController.strCameraID = [cameraDic objectForKey:@STR_DID];
            cameraEditViewController.strUser = [cameraDic objectForKey:@STR_USER];
            cameraEditViewController.strPwd = [cameraDic objectForKey:@STR_PWD];
        }else{
            cameraDic = [cameraListMgt GetIpCameraAtIndex:anIndexPath.row];
            cameraEditViewController.editCameraDelegate = self;
            cameraEditViewController.bAddCamera = NO;
            cameraEditViewController.isP2P=isP2P;
            cameraEditViewController.cameraListMgt=cameraListMgt;
            cameraEditViewController.strCameraName = [cameraDic objectForKey:@STR_NAME];
            cameraEditViewController.strCameraIp = [cameraDic objectForKey:@STR_IPADDR];
            cameraEditViewController.strCameraPort=[cameraDic objectForKey:@STR_PORT];
            cameraEditViewController.strUser = [cameraDic objectForKey:@STR_USER];
            cameraEditViewController.strPwd = [cameraDic objectForKey:@STR_PWD];
        }
        if (cameraDic == nil) {
            return;
        }
        
        [self.navigationController pushViewController:cameraEditViewController animated:YES];
        
        return;
    }
    if (anIndexPath.section==0) {
        if (anIndexPath.row == 0) {
            CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
            cameraEditViewController.editCameraDelegate = self;
            cameraEditViewController.bAddCamera = YES;
            cameraEditViewController.isP2P=isP2P;
            cameraEditViewController.cameraListMgt=cameraListMgt;
            [self.navigationController pushViewController:cameraEditViewController animated:YES];
            [cameraEditViewController release];
            return;
        }
    }
    
    
    int index = anIndexPath.row;
    
    //  Code Begins
    cameraIndex = anIndexPath.row;
    //  Code Ends
    
    if (isP2P) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
        if (cameraDic == nil) {
            return;
        }
        
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
            return;
        }
        if ([nPPPPStatus intValue]==PPPP_STATUS_CONNECTING) {
            return;
        }
        
        if ([nPPPPStatus intValue] != PPPP_STATUS_LAN&&[nPPPPStatus intValue] != PPPP_STATUS_WLAN) {
            NSString *strDID = [cameraDic objectForKey:@STR_DID];
            NSString *strUser = [cameraDic objectForKey:@STR_USER];
            NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
            pPPPPChannelMgt->Stop([strDID UTF8String]);
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
            
            return;
        }
        
    }
    
    //  Code Begins
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    
    if (!isUserLoggedIn)
    {
        [self validateUser];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isUserSubscribed"] == 0 && [nPPPPStatus intValue] == PPPP_STATUS_WLAN)
    {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
        
        NSString *strCameraUser = [cameraDic valueForKey:@"user"];
        NSString *strCameraUserPassword = [cameraDic valueForKey:@"pwd"];
        
        NSString *cameraId = [cameraDic valueForKey:@"did"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"GET_CAMERA_ACCESS" forKey:@"action"];
        [param setValue:strCameraUser forKey:@"access_userid"];
        [param setValue:strCameraUserPassword forKey:@"password"];
        [param setValue:cameraId forKey:@"camera_id"];
        
        [self.connection makePostRequestFromDictionary:param];
        requestType = cameraAccessRequest;
    }
    else
    {
        [self StartPlayView:cameraIndex];
    }
    //  Code Ends
    
//    [self StartPlayView:index];
    
}

// Code Begin
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
// Code Ends

#pragma mark -
#pragma mark system

- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}
-(void)reStart{
    if (isSearchDevice) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"refresh_toomuch", @STR_LOCALIZED_FILE_NAME, nil)];
        return;
    }
    isSearchDevice=YES;
    [mytoast showWithText:NSLocalizedStringFromTable(@"ingInitCamera", @STR_LOCALIZED_FILE_NAME, nil)];
    [self reStartThread];
    [NSThread detachNewThreadSelector:@selector(reLoginBiz) toTarget:self withObject:nil];
}

-(void)reStartThread{
    [NSThread detachNewThreadSelector:@selector(reStartProcess) toTarget:self withObject:nil];
}



-(void)reStartProcess{
   
    [self ppppSearchLocalDevices];
    sleep(1);
    int count = [cameraListMgt GetCount];
    
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic =nil;
        cameraDic = [cameraListMgt GetCameraAtIndex:i];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        NSNumber *statusNum=[cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([statusNum intValue]!=PPPP_STATUS_CONNECTING&&[statusNum intValue]!=PPPP_STATUS_LAN&&[statusNum intValue]!=PPPP_STATUS_WLAN&&[statusNum intValue]!=PPPP_STATUS_INVALID_ID) {
            pPPPPChannelMgt->Stop([strDID UTF8String]);
            usleep(100000);
            pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        }
        
        
    }
    
    isSearchDevice=NO;
}

-(void)networkChangeReStartDevice{
    [NSThread detachNewThreadSelector:@selector(networkChange) toTarget:self withObject:nil];
}
-(void)networkChange{
    [self ppppSearchLocalDevices];
    
    sleep(1);
    int count = [cameraListMgt GetCount];
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic =nil;
        cameraDic = [cameraListMgt GetCameraAtIndex:i];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        
        pPPPPChannelMgt->Stop([strDID UTF8String]);
        usleep(100000);
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
    }
    isSearchDevice=NO;
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

- (void) StartPPPP:(id) param
{
    [self ppppSearchLocalDevices];
    
    sleep(1);
    int count = [cameraListMgt GetCount];
    
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic =nil;
        
        
        cameraDic = [cameraListMgt GetCameraAtIndex:i];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        pPPPPChannelMgt->Stop([strDID UTF8String]);
        usleep(100000);
        pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        
    }
    
}

-(void)ppppSearchLocalDevices{
    [locakDeviceArr removeAllObjects];
    lanSearchExtRet *sea=new lanSearchExtRet[32];
    INT32 ret=PPPP_SearchExt(sea, 32, 900);
    if (ret>0) {
        for(int i=0;i<ret;i++){
            NSLog(@"ip:%s id:%s  name=%s",sea[i].mIP,sea[i].mDID,sea[i].mName);
            
            NSString *name=[NSString stringWithUTF8String:sea[i].mName];
            NSString *did=[NSString stringWithUTF8String:sea[i].mDID];
            if (name==nil||[name hasPrefix:@"old_node"]) {
                name=@"IP Camera";
            }
            [locakDeviceArr addObject:did];
        }
    }
    delete sea;
}

- (void) StopPPPP
{
    int count = [cameraListMgt GetCount];
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic =nil;
        cameraDic = [cameraListMgt GetCameraAtIndex:i];
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        usleep(100000);
        pPPPPChannelMgt->Stop([strDID UTF8String]);
    }
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        ppppChannelMgntCondition = [[NSCondition alloc] init];
        self.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ipc30.png"];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    mainScreen=[[UIScreen mainScreen]bounds];
    locakDeviceArr=[[NSMutableArray alloc] init];
    NSLog(@"mainScreen.w=%f",mainScreen.size.width);
    isFirstLoad=YES;
    isSetDialogShow=NO;
    isMoreViewLoad=NO;
    isStartPPPPOver=NO;
    if (isP2P) {
        setDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(0, -120, 120, 60) Btn:1];
        // [self.view addSubview:setDialog];
        setDialog.diaDelegate=self;
        setDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        
        //[setDialog setBtnTitle:@"DDNS" Index:0];
        [setDialog setBtnTitle: NSLocalizedStringFromTable(@"fourviews", @STR_LOCALIZED_FILE_NAME, nil) Index:0];
        
        setDialog.backgroundColor=[UIColor colorWithRed:17/255.0 green:86/255.0 blue:148/255.0 alpha:1.0];
        
    }else{
        setDialog=[[MySetDialog alloc]initWithFrame:CGRectMake(0, -120, 120, 60) Btn:1];
        [self.view addSubview:setDialog];
        setDialog.diaDelegate=self;
        setDialog.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        
        [setDialog setBtnTitle:@"P2P" Index:0];
        [setDialog setBtnBackgroundColor:[UIColor colorWithRed:0 green:71/255.0f blue:135/255.05 alpha:1] Index:0];
    }
    
    
    
    //cameraListMgt = [[CameraListMgt alloc] init];
    bEditMode = NO;
    
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
    netWorkUtile.networkProtocol=self;
    
    if (isP2P) {
        [self StartPPPPThread];
    }else{
        
        [self StartCamera];
        
        
    }
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=cameraList.frame;
        tableFrm.origin.y+=20;
        cameraList.frame=tableFrm;
        self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
        cameraList.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
        
    }else{
        isIOS7=NO;
    }
    
    InitAudioSession();
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=cameraList.frame;
    imgView.center=cameraList.center;
    cameraList.backgroundView=imgView;
    [imgView release];
    
    // code begins
    self.connection = [[RequestClass alloc] init];
    self.connection.delegate = self;
    // code end

    
}



-(void)viewDidDisappear:(BOOL)animated{
    if (isMoreViewLoad) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(statusChanged:)
         name:@"statuschange"
         object:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    //NSLog(@"Camera viewWillAppear");
    if (isFirstLoad) {
        
        //[NSThread detachNewThreadSelector:@selector(GetUpdate) toTarget:self withObject:nil];
        
        isFirstLoad=NO;
    }
    pPPPPChannelMgt->pCameraViewController = self;
    
    if (isMoreViewLoad) {
        // NSLog(@"isMoreViewLoad");
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"statuschange" object:nil];
        isMoreViewLoad=NO;
         IpCameraClientAppDelegate *delegate=[UIApplication sharedApplication].delegate;
        delegate.isOnPlayView=NO;
        int count = [cameraListMgt GetCount];
        int i;
        for (i = 0; i < count; i++) {
            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
            NSString *strDID = [cameraDic objectForKey:@STR_DID];
            pPPPPChannelMgt->SetStatusDelegate((char*)[strDID UTF8String], self);
        }
    }
}

/**
 摄像机状态改变
 **/
-(void)statusChanged:(NSNotification *)notification{
    //    NSDictionary *_dic=(NSDictionary*)notification.object;
    //    NSString *_did=[_dic objectForKey:@STR_DID];
    //    NSNumber *_status=[_dic objectForKey:@STR_PPPP_STATUS];
    NSLog(@"CameraViewController...statusChanged..");
    //    [self PPPPStatus:_did statusType:MSG_NOTIFY_TYPE_PPPP_STATUS status:[_status integerValue]];
    [self ReloadCameraTableView];
    
}

//摄像机连接时的提示框
-(void)InitCameraProcess{
    [mytoast showWithText:NSLocalizedStringFromTable(@"ingInitCamera", @STR_LOCALIZED_FILE_NAME, nil)];
    return;
    
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
    timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(AlertDismiss) userInfo:nil repeats:NO];
    
}

-(void)AlertDismiss{
    // NSLog(@"AlertDismiss  000000");
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    //[self GetUpdate];
}
-(void)StartCamera{
    int count = [cameraListMgt GetCount];
    //NSLog(@"DDNSCameraController  StartCamera()  count=%d",count);
    for (int i=0; i<count; i++) {
        
        NSMutableDictionary *cameraDic = [cameraListMgt GetIpCameraAtIndex:i];
        NSString *port = [cameraDic objectForKey:@STR_PORT];
        NSString *ip = [cameraDic objectForKey:@STR_IPADDR];
        NSString *user=[cameraDic objectForKey:@STR_USER];
        NSString *pwd=[cameraDic objectForKey:@STR_PWD];
        NSLog(@"ip=%@ port=%@ user=%@ pwd=%@",ip,port,user,pwd);
        netWorkUtile.networkProtocol=self;
        [netWorkUtile downloadSnapshot:ip Port:port User:user Pwd:pwd ParamType:1];
        
        //[netWorkUtile checkUserNameAndPwd:ip Port:port User:user Pwd:pwd ParamType:0];
    }
}
- (void) StartPPPPThread
{
    if (isP2P) {
        NSLog(@"StartPPPPThread");
        [ppppChannelMgntCondition lock];
        if (pPPPPChannelMgt == NULL) {
            [ppppChannelMgntCondition unlock];
            return;
        }
        [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];
        [ppppChannelMgntCondition unlock];
    }else{
        [self StartCamera];
    }
    
    
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    //[cameraListMgt release];
    //cameraListMgt = nil;
    // SAFE_DELETE(pPPPPChannelMgt);
}

- (void)dealloc {
    
    self.cameraList = nil;
    //[cameraListMgt release];
    //cameraListMgt = nil;
    //[self StopPPPP];
    if (netWorkUtile!=nil) {
        netWorkUtile.networkProtocol=nil;
        netWorkUtile=nil;
    }
    if (pPPPPChannelMgt!=nil) {
        pPPPPChannelMgt->pCameraViewController = nil;
    }
    SAFE_DELETE(pPPPPChannelMgt);
    [ppppChannelMgntCondition release];
    self.navigationBar = nil;
    self.cameraListMgt = nil;
    self.PicNotifyEventDelegate = nil;
    self.RecordNotifyEventDelegate = nil;
    self.m_pPicPathMgt = nil;
    self.alertView=nil;
    [super dealloc];
}

-(void)reloadMyTableView{
    [cameraList reloadData];
}

#pragma mark -DDNS
#pragma mark- NetworkUtilesProtocol
-(void)snapShotResult:(NSString *)ip Img:(UIImage *)img{
    // NSLog(@"DDNSCameraController  snapShotResult()  ip=%@",ip);
    if (img!=nil) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        UIImage *scaleImg=[self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
        NSInteger index=[cameraListMgt UpdateIpCameraImage:ip Image:scaleImg];
        if (index>=0) {
            [self saveSnapshot:scaleImg Ip:ip];
        }
        
        [self performSelectorOnMainThread:@selector(reloadMyTableView) withObject:nil waitUntilDone:NO];
        
        [pool release];
        
    }
    [img release];
}

-(void)connectFailed:(NSString *)ip{
    //NSLog(@"CameraViewController...connectFailed..ip=%@",ip);
    [mytoast showWithText:NSLocalizedStringFromTable(@"ddnscameraisofflineornolan", @STR_LOCALIZED_FILE_NAME, nil)];
    
}
-(void)checkUserResult:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd Result:(int)result Type:(int)type{
    //NSLog(@"CameraViewController....checkUserResult..result=%d",result);
    if (result==1) {
        [netWorkUtile downloadSnapshot:ip Port:port User:user Pwd:pwd ParamType:1];
    }else{
        [mytoast showWithText:NSLocalizedStringFromTable(@"PPPPStatusInvalidUserPwd", @STR_LOCALIZED_FILE_NAME, nil)];
    }
}
- (void) saveSnapshot: (UIImage*) image Ip: (NSString*) strIP
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strIP];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    //NSLog(@"strPath: %@", strPath);
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    [pool release];
}
#pragma mark -P2P和DDNS切换的dialog
-(void)showSetDialog:(BOOL)bShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    CGRect frame=setDialog.frame;
    if (isIOS7) {
        if (bShow) {
            frame.origin.y-=190;
        }else{
            frame.origin.y+=190;
        }
    }else{
        if (bShow) {
            frame.origin.y-=170;
        }else{
            frame.origin.y+=170;
        }
    }
    
    setDialog.frame=frame;
    
    //动画结束
    [UIView commitAnimations];
}
-(void)mySetDialogOnClick:(int)tag Type:(int)type{
    IpCameraClientAppDelegate *IPCamDelegate =  [[UIApplication sharedApplication] delegate] ;
    [self showSetDialog:isSetDialogShow];
    isSetDialogShow=!isSetDialogShow;
    switch (tag) {
        case 1:
            if (isP2P) {
                [self StopPPPP];
                [IPCamDelegate changeP2PAndDDNS:NO];
            }else{
                [IPCamDelegate changeP2PAndDDNS:YES];
            }
            
            break;
        case 0:
            if (isP2P) {
                
                isMoreViewLoad=YES;
                
                MoreViewController *moreView=nil;
                if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
                    moreView=[[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
                    
                }else{
                    
                    moreView=[[MoreViewController alloc]initWithNibName:@"Moreview_Ipad" bundle:nil];
                }
                
                moreView.cameraListMgt=cameraListMgt;
                moreView.pPPPPChannelMgt=pPPPPChannelMgt;
                moreView.m_pPicPathMgt = m_pPicPathMgt;
                moreView.m_pRecPathMgt = m_pRecPathMgt;
                moreView.picViewController=picViewController;
                moreView.recViewController=recViewController;
                moreView.PicNotifyEventDelegate = picViewController;
                moreView.RecordNotifyEventDelegate = recViewController;
                moreView.moreViewExitDelegate=self;
                [self presentModalViewController:moreView animated:YES];
                [moreView release];
                return;
            }
            
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
    NSLog(@"isP2P=%d",isP2P);
}
#pragma  mark- 升级提示
-(void)GetUpdate
{
    
    //检测app store上是否有更新的版本的方法
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"nowVersion=%@",nowVersion);
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=943335699"];
    //536830821是在itunes上创建应用是分配的，不是Bundle ID，而是App ID
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error2;
    if (data==nil) {
        NSLog(@"GetUpdate。。。data==nil");
        return;
    }
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
    //NSLog(@"GetUpdate。。。jsonDic=%@",jsonDic);
    if (jsonDic == nil) {
        NSLog(@"json parse failed \r\n");
        return;
    }
    NSArray *arrd=[jsonDic objectForKey:@"results"];
    if (arrd==nil) {
        return;
    }
    if (arrd.count<=0) {
        NSLog(@"arrd.count<=0");
        return;
    }
    
    NSDictionary *dicd=[arrd objectAtIndex:0];
    if (dicd==nil) {
        return;
    }
    self.appStoreVersion=[dicd objectForKey:@"version"];
    if (self.appStoreVersion==nil) {
        return;
    }
    
    NSLog(@"newVersion=%@",appStoreVersion);
    if ([appStoreVersion caseInsensitiveCompare:nowVersion]==NSOrderedDescending) {
        // NSLog(@"newVersion>nowVersion");
        NSString *versionPath=[self getVersionPath];
        NSString *_rversion=nil;
        if ([[NSFileManager defaultManager]fileExistsAtPath:versionPath]) {
            NSArray *array=[[NSArray alloc]initWithContentsOfFile:versionPath];
            _rversion=[[NSString alloc]initWithFormat:@"%@",[array objectAtIndex:0]];
        }
        NSLog(@"_rversion=%@",_rversion);
        if ([appStoreVersion caseInsensitiveCompare:_rversion]==NSOrderedSame) {
            NSLog(@"该版本被忽略...");
            return;
        }
        [self performSelectorOnMainThread:@selector(showVersionAlertView) withObject:nil waitUntilDone:NO];
        
    }
}
-(void)showVersionAlertView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"versionInfo", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"versionNew", @STR_LOCALIZED_FILE_NAME, nil),appStoreVersion] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"versionIgnore", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"versionUpdate", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"versionlaterUpdate", @STR_LOCALIZED_FILE_NAME, nil), nil];
    [alert show];
}
-(NSString *)getVersionPath{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                      , YES);
    NSString *paths=[path objectAtIndex:0];
    return[paths stringByAppendingPathComponent:@"version"];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:{//忽略
            NSMutableArray *array=[[NSMutableArray alloc]init];
            [array addObject:appStoreVersion];
            
            [array writeToFile:[self getVersionPath] atomically:YES];
            [array release];
        }
            break;
        case 1:{//马上更新
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/shu-bin/id943335699?ls=1&mt=8"];
            
            [[UIApplication sharedApplication]openURL:url];
        }
            break;
        case 2://稍后更新
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UserPwdProtocol

-(void)UserProtocolResult:(STRU_USER_INFO)t{
    if (isP2P) {
      
        [cameraListMgt UpdateCameraAuthority:[NSString stringWithUTF8String:t.did] andStrut:t];
    }
}
#pragma mark -
#pragma mark EditCameraProtocol


- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid IP:(NSString *)ip OldIP:(NSString *)oldIp Port:(NSString *)port
{
    //NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@  ip:%@ oldIp:%@ port:%@", bAdd, name, did, user, pwd, olddid,ip,oldIp,port);
    
    BOOL bRet;
    
    if (bAdd == YES) {
        int sum=[cameraListMgt GetCount];
        NSLog(@"camera sum=%d",sum);
        
        if (sum>=20) {
            [mytoast showWithText:NSLocalizedStringFromTable(@"cameraNumOut", @STR_LOCALIZED_FILE_NAME, nil)];
            return NO;
        }
        if (isP2P) {
            bRet = [cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
        }else{
            
            bRet=[cameraListMgt AddIpCamera:name Ip:ip Port:port User:user Pwd:pwd];
        }
        
    }else {
        if (isP2P) {
            bRet = [cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
        }else{
            bRet= [cameraListMgt EditIpCamera:oldIp Name:name Ip:ip Port:port User:user Pwd:pwd];
        }
        
    }
    
    if (bRet == YES) {
        
        if (bAdd) {//添加成功，增加P2P连接
            if (isP2P) {
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
            }else{
                netWorkUtile.networkProtocol=self;
                [netWorkUtile downloadSnapshot:ip Port:port User:user Pwd:pwd ParamType:1];
            }
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:did,@"did",name,@"name",user,@"user",pwd,@"pwd", nil];

            IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            [delegate addDeviceToBizServer:dic];
            
        }else {//修改成功，重新启动P2P连接
            if (isP2P) {
                pPPPPChannelMgt->Stop([olddid UTF8String]);
                
                pPPPPChannelMgt->Stop([did UTF8String]);
                pPPPPChannelMgt->Start([did UTF8String], [user UTF8String], [pwd UTF8String]);
            }else{
                netWorkUtile.networkProtocol=self;
                [netWorkUtile downloadSnapshot:ip Port:port User:user Pwd:pwd ParamType:1];
            }
            
            if ([cameraListMgt GetCount]<2) {
                [self btnEdit:nil];
            }
            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:olddid,@"did",[NSNumber numberWithBool:NO],@"flag", nil];
            
            IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            [delegate deleteDeviceFromBizServer:dic2];
           
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:did,@"did",name,@"name",user,@"user",pwd,@"pwd", nil];
            [delegate addDeviceToBizServer:dic];

        }
        
        if (bEditMode && [olddid caseInsensitiveCompare:did] != NSOrderedSame) {
            [m_pPicPathMgt RemovePicPathByID:olddid];
        }
        
        
        
        
        //添加或修改设备成功，重新加载设备列表
        [cameraList reloadData];
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        [alarmNotifyEventDelegate NotifyReloadData];
        
    }
    
    NSLog(@"bRet: %d", bRet);
    
    return bRet;
}
#pragma mark---若登陆Biz不成功，则在刷新时重新登陆
-(void)reLoginBiz{
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL isLogin=[defaults boolForKey:@"bizlogin"];
    if (isLogin==NO) {
        IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        [delegate loginInBizSever];
    }
}
#pragma mark -
#pragma mark  PPPPStatusProtocol
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    // NSLog(@"PPPPStatus ..... strDID: %@, statusType: %d, status: %d", strDID, statusType, status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {
        NSInteger index = [cameraListMgt UpdatePPPPMode:strDID mode:status];
        if ( index >= 0){
            
        }
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        
        if (status==PPPP_STATUS_ON_LINE) {//判断是外网还是局域网
            if ([locakDeviceArr containsObject:strDID]) {
                status=PPPP_STATUS_LAN;
            }else{
                status=PPPP_STATUS_WLAN;
            }
        }
        
        NSInteger index = [cameraListMgt UpdatePPPPStatus:strDID status:status];
        if ( index >= 0){
            
            if (status==PPPP_STATUS_LAN||status==PPPP_STATUS_WLAN) {//
                
                [NSThread detachNewThreadSelector:@selector(updateAuthority:) toTarget:self withObject:strDID];
            }else{
                //NSLog(@"状态改变");
                [self performSelectorOnMainThread:@selector(notifyCameraStatusChange:) withObject:strDID waitUntilDone:NO];
            }
            [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
            
            if (status==PPPP_STATUS_INVALID_ID||status==PPPP_STATUS_INVALID_USER_PWD) {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:strDID,@"did",[NSNumber numberWithBool:NO],@"flag", nil];
                IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
                [delegate deleteDeviceFromBizServer:dic];
            }
        }
        
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED||statusType==PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
        }
        
       
        
        [RecordNotifyEventDelegate NotifyReloadData];
        [alarmNotifyEventDelegate NotifyReloadData];
        return;
    }
}
-(void)notifyCameraStatusChange:(NSString *)did{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statuschange" object:did];
    
}
-(void)updateAuthority:(NSString *)did{
    //NSLog(@"updateAuthority  00000  did=%@",did);
    
    sleep(1);
    pPPPPChannelMgt->SetUserPwdParamDelegate((char*)[did UTF8String], self);
    pPPPPChannelMgt->PPPPSetSystemParams((char*)[did UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    
    STRUCT_JPUSH_PARAM jpt;
    strcpy(jpt.appkey, JPUSH_APPKEY);
    strcpy(jpt.master, JPUSH_MASTER);
    IpCameraClientAppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    NSString *alias=[delegate getJPushAlias];
    if (alias!=nil) {
        strcpy(jpt.alias, [alias UTF8String]);
        jpt.type=3;
        pPPPPChannelMgt->setJPushParam((char*)[did UTF8String], jpt);
    }else{
        [delegate setJPushAlias];
    }
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
        NSLog(@"SnapshotNotify image == nil");
        [image release];
        return;
    }
    
    UIImage *img = [[UIImage alloc] initWithData:image];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
    
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        
        [self saveSnapshot:imgScale DID:strDID];
        
        // NSLog(@"UpdateCamereaImage success!");
        [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        
    }
    
    [pool release];
    
    [img release];
    [image release];
    
}
#pragma mark--PlayViewExitResultProtocol
-(void)playViewExitResultImg:(UIImage *)img DID:(NSString *)did{
    
    NSLog(@"playViewExitResultImg...did=%@",did);
    if (img!=nil) {
        NSLog(@"playViewExitResultImg...img..");
        
        
        
        UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
        NSInteger index =-1;
        if (isP2P) {
            index = [cameraListMgt UpdateCamereaImage:did  Image:imgScale] ;
            
        }else{
            index=[cameraListMgt UpdateIpCameraImage:did Image:imgScale];
        }
        
        if (index>=0) {
            [self saveSnapshot:imgScale DID:did];
            
            [self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        
        
    }else{
        NSLog(@"playViewExitResultImg...img＝＝nil..");
    }
    
}
#pragma mark-MoreViewExitProtocol
-(void)moreViewExit{
    pPPPPChannelMgt->pCameraViewController = self;
    int count = [cameraListMgt GetCount];
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        pPPPPChannelMgt->SetStatusDelegate((char*)[strDID UTF8String], self);
    }
}

//  Code Begins
#pragma mark -  Request Delegate

- (void)connectionSuccess:(id)result andError:(NSError *)error
{
    if (!error)
    {
        switch (requestType)
        {
            case loginRequest:
            {
                isUserLoggedIn = YES;
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = [result valueForKey:@"response"];
                    NSInteger isSubscribed = [[dictResponse valueForKey:@"isSubscribed"] intValue];
                    
                    subscriptonStatus = [[dictResponse valueForKey:@"subscription_status"] intValue];
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:isSubscribed forKey:@"isUserSubscribed"];
                    
                    isUserSubscribed = [[NSUserDefaults standardUserDefaults] integerForKey:@"isUserSubscribed"];;
                    
                    if (![[dictResponse valueForKey:@"subscriptionEndDate"] isKindOfClass:[NSNull class]]) {
                        NSString *str = [dictResponse valueForKey:@"subscriptionEndDate"];
                        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"subscriptionEndDate"];
                    }
                    
                    if (isSubscribed == 1)
                    {
                        [self StartPlayView:cameraIndex];
                    }
                    else
                    {
                        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
                        
                        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
                        if (subscriptonStatus == 1001 && [nPPPPStatus intValue] == PPPP_STATUS_WLAN)
                        {
                            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
                            
                            NSString *strCameraUser = [cameraDic valueForKey:@"user"];
                            NSString *strCameraUserPassword = [cameraDic valueForKey:@"pwd"];
                            
                            NSString *cameraId = [cameraDic valueForKey:@"did"];
                            
                            NSMutableDictionary *param = [NSMutableDictionary dictionary];
                            [param setValue:@"GET_CAMERA_ACCESS" forKey:@"action"];
                            [param setValue:strCameraUser forKey:@"access_userid"];
                            [param setValue:strCameraUserPassword forKey:@"password"];
                            [param setValue:cameraId forKey:@"camera_id"];
                            
                            [self.connection makePostRequestFromDictionary:param];
                            requestType = cameraAccessRequest;
                        }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isUserSubscribed"] == 0 && [nPPPPStatus intValue] == PPPP_STATUS_WLAN)
                        {
                            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:cameraIndex];
                            
                            NSString *strCameraUser = [cameraDic valueForKey:@"user"];
                            NSString *strCameraUserPassword = [cameraDic valueForKey:@"pwd"];
                            
                            NSString *cameraId = [cameraDic valueForKey:@"did"];
                            
                            NSMutableDictionary *param = [NSMutableDictionary dictionary];
                            [param setValue:@"GET_CAMERA_ACCESS" forKey:@"action"];
                            [param setValue:strCameraUser forKey:@"access_userid"];
                            [param setValue:strCameraUserPassword forKey:@"password"];
                            [param setValue:cameraId forKey:@"camera_id"];
                            
                            [self.connection makePostRequestFromDictionary:param];
                            requestType = cameraAccessRequest;
                        }
                        else
                        {
                            [self StartPlayView:cameraIndex];
                        }
                    }
                }
            }
                break;
                
            case cameraAccessRequest:
            {
                if ([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictResponse = (NSDictionary *)result;
                    if ([[dictResponse valueForKey:@"code"] intValue] == 200)
                    {
                        if ([[dictResponse valueForKey:@"response"] intValue] == 1)
                        {
                            [self StartPlayView:cameraIndex];
                        }
                        else if ([[dictResponse valueForKey:@"response"] intValue] == 0)
                        {
                            // Show pop up
                            // Goto subscription page
                            NSLog(@"Goto subscription page");
                            objInAppAlertView = (InAppAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"InAppAlertView" owner:self options:nil] objectAtIndex:0];
                            [self.view addSubview:objInAppAlertView];
                            if (subscriptonStatus == 1003)
                            {
                                objInAppAlertView.lblSubscriptionMessage.text = NSLocalizedStringFromTable(@"renew", @STR_LOCALIZED_FILE_NAME, nil);
                            }
                            objInAppAlertView.center = self.view.center;
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
        
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        objInAppAlertView = (InAppAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"InAppAlertView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:objInAppAlertView];
        
        objInAppAlertView.center = self.view.center;
        if (subscriptonStatus == 1003)
        {
            objInAppAlertView.lblSubscriptionMessage.text = NSLocalizedStringFromTable(@"renew", @STR_LOCALIZED_FILE_NAME, nil);
        }
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}


- (IBAction)tapOnInAppAlert:(id)sender
{
    if ([objInAppAlertView isDescendantOfView:self.view])
    {
        [objInAppAlertView removeFromSuperview];
        objInAppAlertView = nil;
    }
    
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

#pragma mark- In App Purchase Delegate -

- (void)completePayment:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPRODUCT_PURCHASE];
    //    [ProgressHUD dismiss];
}
- (void)restoredPayment:(SKPaymentTransaction *)transactions
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPRODUCT_PURCHASE];
    //    [ProgressHUD dismiss];
}
- (void)failedPayment:(SKPaymentTransaction *)transaction
{
    //    [ProgressHUD dismiss];
}



- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//  Code Ends

@end
