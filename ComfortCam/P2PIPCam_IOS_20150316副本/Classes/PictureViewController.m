//
//  PictureViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureViewController.h"
#import "obj_common.h"
#import "PictrueDateViewController.h"
#import "PicDirCell.h"
#import "APICommon.h"
#import "IpCameraClientAppDelegate.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

@synthesize navigationBar;
@synthesize segmentedControl;
@synthesize m_pCameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize m_tableView;
@synthesize imageBkDefault;
@synthesize isP2P;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"picture30.png"];
        self.tabBarItem.title = NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil);
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>7.9) {
        m_tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainScreen=[[UIScreen mainScreen]bounds];
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:0.5];
    
    UINavigationItem *navigationItem1 = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil)];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil);
    navigationItem1.titleView=labelTile;
    [labelTile release];
    NSArray *array = [NSArray arrayWithObjects:navigationItem1, nil];
    [self.navigationBar setItems:array];
    
    [navigationItem1 release];
    
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.imageBkDefault = [UIImage imageNamed:@"picbk.png"];
    
    
    if ([IpCameraClientAppDelegate isIOS7Version]) {
        NSLog(@"is ios7");
        self.wantsFullScreenLayout = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        CGRect navigationBarFrame = self.navigationBar.frame;
        navigationBarFrame.origin.y += 20;
        self.navigationBar.frame = navigationBarFrame;
        [self.view bringSubviewToFront:self.navigationBar];
        
        CGRect tableFrm=m_tableView.frame;
        tableFrm.origin.y+=20;
        m_tableView.frame=tableFrm;
         self.view.backgroundColor=[UIColor blackColor];
        isIOS7=YES;
        m_tableView.contentInset=UIEdgeInsetsMake(-10, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        isIOS7=NO;
    }
    
    
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=m_tableView.frame;
    imgView.center=m_tableView.center;
    m_tableView.backgroundView=imgView;
    [imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    self.navigationBar = nil;
    self.segmentedControl = nil;
    self.m_pCameraListMgt = nil;
    self.m_pPicPathMgt = nil;
    self.m_tableView = nil;
    self.imageBkDefault = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark TableViewDelegate


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection");    
    int count = [m_pCameraListMgt GetCount];
    return count;  
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    NSInteger index = anIndexPath.row ;    
    
    //-----------------------------------------------------------------------------------
    NSDictionary *cameraDic =nil;
    NSString *name =@"";
    NSString *did =@"";
    if (isP2P) {
        cameraDic = [m_pCameraListMgt GetCameraAtIndex:index];
        name = [cameraDic objectForKey:@STR_NAME];
        did = [cameraDic objectForKey:@STR_DID];
    }else{
        cameraDic = [m_pCameraListMgt GetIpCameraAtIndex:index];
        name= [cameraDic objectForKey:@STR_NAME];
        did=[cameraDic objectForKey:@STR_IPADDR];
    }
    NSString *cellIdentifier = @"CameraPictureListCell";
//    NSLog(@"1 %d",index);
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *strPath = [m_pPicPathMgt GetFirstPathByID:did];
   

    cell.opaque=YES;
    NSDictionary *m_picDic=[m_pPicPathMgt GetPicCountAndFirstPicByID:did];
    NSNumber *num=[m_picDic objectForKey:@"sum"];
    int picSum=[num intValue];
    UIImage *image=nil;
    if (strPath!=nil) {
        image=[m_picDic objectForKey:@"img"];
        if (image==nil) {
           
            image=[APICommon GetImageByNameFromImage:did filename:strPath];
            [m_pPicPathMgt updateImgByDID:image DID:did];
        }
        
        
    }

    
    NSString *strShowName = [NSString stringWithFormat:@"%@(%d)", name,picSum];

    
    cell.labelName.text = strShowName;
    cell.labelDID.text=did;
    if (image != nil) {
        cell.imageView.image = image;
        
    }

    cell.playFView.hidden=YES;
    float cellHeight = cell.frame.size.height;
  
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
    
    return cell;
  
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 60;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *cameraDic = [m_pCameraListMgt GetCameraAtIndex:anIndexPath.row];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    NSString *did =@"";
    if (isP2P) {
        did = [cameraDic objectForKey:@STR_DID];
    }else{
        did = [cameraDic objectForKey:@STR_IPADDR];
    }
    NSNumber *num=[cameraDic objectForKey:@STR_AUTHORITY];
    
    
    PictrueDateViewController *pictureDateViewController = [[PictrueDateViewController alloc] init];
    pictureDateViewController.strName = name;
    pictureDateViewController.strDID = did;
    pictureDateViewController.NotifyReloadDataDelegate=self;
    pictureDateViewController.m_pPicPathMgt = m_pPicPathMgt;
    pictureDateViewController.authority = num;
    [self.navigationController pushViewController:pictureDateViewController animated:YES];
    NSLog(@"~~~~~~pitureVC  == authority(%@)\cameraDic=n%@  pictureDateViewController(%@)",(long)num,cameraDic,pictureDateViewController.authority);
    [pictureDateViewController release];
    
    
   
}

#pragma mark -
#pragma mark performInMainThread

- (void) reloadTableView
{
    [m_tableView reloadData];
}

#pragma mark -
#pragma mark NotifyReloadDataDelegate

- (void) NotifyReloadData
{
    NSLog(@"PictureViewController....NotifyReloadData");
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}


@end
