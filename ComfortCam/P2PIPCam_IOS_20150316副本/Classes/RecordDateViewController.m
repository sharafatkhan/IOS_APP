//
//  RecordDateViewController.m
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordDateViewController.h"
#import "obj_common.h"
#import "RecordListViewController.h"
#import "PicDirCell.h"
#import "defineutility.h"
#import "APICommon.h"
#import "IpCameraClientAppDelegate.h"
@interface RecordDateViewController ()

@end

@implementation RecordDateViewController

@synthesize m_pRecPathMgt;
@synthesize strDID;
@synthesize strName;
@synthesize navigationBar;
@synthesize imagePlay;
@synthesize imageDefault;
@synthesize tableView;
@synthesize RecReloadDelegate;
@synthesize m_ImgDic;
@synthesize authority;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mainScreen=[[UIScreen mainScreen]bounds];
    //NSLog(@"RecordDateViewController viewDidLoad....");
    recDataArray = nil;
    recDataArray = [m_pRecPathMgt GetTotalDataArray:strDID] ;
    m_ImgDic=[[NSMutableDictionary alloc]init];
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationBar.delegate = self;
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strName];
    UILabel *labelTile=[[UILabel alloc]init];
    labelTile.frame=CGRectMake(0, 0, 80, 20);
    labelTile.font=[UIFont systemFontOfSize:18];
    labelTile.textColor=[UIColor whiteColor];
    labelTile.textAlignment=UITextAlignmentCenter;
    labelTile.backgroundColor=[UIColor clearColor];
    labelTile.text= strName;
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
    
    self.imagePlay = [UIImage imageNamed:@"play_video.png"];
    self.imageDefault = [UIImage imageNamed:@"videobk.png"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    self.m_pRecPathMgt = nil;
    self.strDID = nil;
    self.navigationBar = nil;
    self.strName = nil;
    self.imagePlay = nil;
    self.imageDefault = nil;
    self.tableView = nil;
    [m_ImgDic release];
    m_ImgDic=nil;
    recDataArray=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)addOneImage:(NSString *)strFileName{
   UIImage *img=[APICommon GetImageByName:strDID filename:strFileName];
     //NSLog(@"RecordDateViewController strFileName=%@",strFileName);
    if (m_ImgDic!=nil) {
        if (img!=nil) {
            [m_ImgDic setObject:img forKey:[NSString stringWithFormat:@"img%@",strFileName]];
        }else{
           /// NSLog(@"img==nil");
        }
        
        [self performSelectorOnMainThread:@selector(ReloadTableViewData) withObject:nil waitUntilDone:NO];
    }
    
    
}
#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection11111");
    
    if (recDataArray == nil) {
        return 0;
    }
    
    return [recDataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath11111");  
    
    NSDictionary *datePicDic = [recDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    NSString *cellIdentifier = @"RecordDateListCell";       
    //当状态为显示当前的设备列表信息时
    PicDirCell *cell =  (PicDirCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicDirCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    int sum=[m_pRecPathMgt GetTotalNumByIDAndDate:strDID Date:strDate];
    if (sum<=0) {//若该日期的数目为0，则删除该日期并从新刷新tableview
        [recDataArray removeObjectAtIndex:anIndexPath.row];
        [self.tableView reloadData];
        return cell;
    }
    cell.labelName.text = [NSString stringWithFormat:@"%@(%d)", strDate, sum];
    
    NSString *strFileName = [m_pRecPathMgt GetFirstPathByIDAndDate:strDID Date:strDate];
    
    UIImage *image = [m_ImgDic objectForKey:[NSString stringWithFormat:@"img%@",strFileName]];
    NSString *flag=[m_ImgDic objectForKey:strFileName];
    
    if (image==nil&&flag==nil) {
        [m_ImgDic setObject:strFileName forKey:strFileName];
        [NSThread detachNewThreadSelector:@selector(addOneImage:) toTarget:self withObject:strFileName];
        
    }
    if (image != nil) {
        cell.imageView.image = image;
        cell.playFView.hidden=NO;
        
    }else {
        cell.imageView.image = self.imageDefault;
    }
    
    float cellHeight = cell.frame.size.height;
 
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
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    NSDictionary *datePicDic = [recDataArray objectAtIndex:anIndexPath.row];
    NSString *strDate = [[datePicDic allKeys] objectAtIndex:0];
    
    RecordListViewController *recListViewController = [[RecordListViewController alloc] init];
    recListViewController.strDID = strDID;
    recListViewController.strDate = strDate;
    recListViewController.authority = authority;
    recListViewController.m_pRecPathMgt = m_pRecPathMgt;
    recListViewController.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    recListViewController.RecReloadDelegate = self;
    [self.navigationController pushViewController:recListViewController animated:YES];
    [recListViewController release];
    
}

#pragma mark -
#pragma mark uinavigationbardelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) ReloadTableViewData
{
    [self.tableView reloadData];
    [RecReloadDelegate NotifyReloadData];
}


#pragma mark -
#pragma mark NotifyReloadDelegate

- (void) NotifyReloadData
{
    [self performSelectorOnMainThread:@selector(ReloadTableViewData) withObject:nil waitUntilDone:NO];
}

@end
