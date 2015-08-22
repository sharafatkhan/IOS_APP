//
//  PictrueDateViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictrueDateViewController.h"
#import "obj_common.h"
#import "PictureListViewController.h"
#import "PicDirCell.h"
#import "APICommon.h"
#import "IpCameraClientAppDelegate.h"
@interface PictrueDateViewController ()

@end

@implementation PictrueDateViewController

@synthesize m_pPicPathMgt;
@synthesize strDID;
@synthesize strName;
@synthesize navigationBar;
@synthesize tableView;
@synthesize imageBkDefault;
@synthesize NotifyReloadDataDelegate;
@synthesize isP2P;
@synthesize authority;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainScreen=[[UIScreen mainScreen]bounds];
    picDataArray = nil;
    picDataArray = [m_pPicPathMgt GetTotalPicDataArray:strDID] ;
   // NSLog(@"picDataArray.count=%d",picDataArray.count);
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",strName,NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil)]];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, TITLE_WITH, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= [NSString stringWithFormat:@"%@ %@",strName,NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil)];
    item.titleView=labelTile;
    [labelTile release];
    UIButton *btnLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateHighlighted];
    btnLeft.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnLeft setTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    btnLeft.frame=CGRectMake(0,0,60,30);
    [btnLeft addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    item.leftBarButtonItem=leftButton;
    
    NSArray *array = [NSArray arrayWithObjects: item, nil];
    [self.navigationBar setItems:array];
    
    [item release];
    [leftButton release];
    
    
   // self.wantsFullScreenLayout = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
//    self.navigationBar.translucent = YES;
//
//    CGRect navigationBarFrame = self.navigationBar.frame;
//    navigationBarFrame.origin.y += 20;
//    self.navigationBar.frame = navigationBarFrame;
    
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
        isIOS7=YES;
        tableView.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    }else{
        NSLog(@"less ios7");
        isIOS7=NO;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.imageBkDefault = [UIImage imageNamed:@"picbk.png"];
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    //NSLog(@"viewWillAppear 11111");
   //[m_pPicPathMgt reSelectAll];
    //NSLog(@"viewWillAppear 2222");
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    self.m_pPicPathMgt = nil;
    self.strDID = nil;
    self.navigationBar = nil;
    self.strName = nil;
    self.tableView = nil;
    self.imageBkDefault = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection11111");
    
    if (picDataArray == nil) {
        return 0;
    }
    
    return [picDataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    NSDictionary *datePicDic = [picDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    NSString *cellIdentifier = @"PictureDateListCell";       
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int nPicCount = [m_pPicPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
    if (nPicCount==0) {//若该日期的数目为0，则删除该日期并从新刷新tableview
        [picDataArray removeObjectAtIndex:anIndexPath.row];
        [self.tableView reloadData];
        return cell;
    }
    NSString *strShowName = [NSString stringWithFormat:@"%@(%d)", strDate, nPicCount];
    
    NSString *strPath = [m_pPicPathMgt GetFirstPathByIDAndDate:strDID Date:strDate];
    UIImage *image = [APICommon GetImageByNameFromImage:strDID filename:strPath];
    
    cell.labelName.text = strShowName;
    cell.labelName.text = strShowName;
    if (image != nil) {
        cell.imageView.image = image;
    }else {
        cell.imageView.image = imageBkDefault;
    }
    cell.playFView.hidden=YES;

    float cellHeight = cell.frame.size.height;
   // float cellWidth = cell.frame.size.width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cellHeight - 1, mainScreen.size.width, 1)];
    label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
    [cellBgView addSubview:label];
    [label release];
    if (isIOS7) {
        cell.backgroundView = cellBgView;
    }
    
    [cellBgView release];
    return cell;
    
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return 60;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSLog(@"```````````PictureListViewController====authority(%@)",authority);
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *datePicDic = [picDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    PictureListViewController *picListViewController = [[PictureListViewController alloc] init];
    picListViewController.strDID = strDID;
    picListViewController.strDate = strDate;
    picListViewController.authority = authority;
    picListViewController.m_pPicPathMgt = m_pPicPathMgt;
    picListViewController.NotifyReloadDataDelegate=self;
    [self.navigationController pushViewController:picListViewController animated:YES];
    [picListViewController release];
    
}
#pragma mark-
#pragma mark perfortInMainThread
-(void)reloadTableViewData{
    
    [self.tableView reloadData];
}
#pragma mark-
#pragma mark NotifyReloadData
-(void)NotifyReloadData{
    if(self.NotifyReloadDataDelegate!=nil){
        [self.NotifyReloadDataDelegate NotifyReloadData];
    }
    
    picDataArray = [m_pPicPathMgt GetTotalPicDataArray:strDID] ;
   
    [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark uinavigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];

    return NO;
}

@end
