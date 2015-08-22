//
//  MailSettingViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

static const double PageViewControllerTextAnimationDuration = 0.33;

#import "MailSettingViewController.h"
#import "defineutility.h"
#import "obj_common.h"
#import "CameraInfoCell.h"
#import "oLableCell.h"
#import "oSwitchCell.h"
#import "oDropController.h"
#import "IpCameraClientAppDelegate.h"
#import "mytoast.h"
@interface MailSettingViewController ()

@end

@implementation MailSettingViewController

@synthesize tableView;
@synthesize navigationBar;
@synthesize m_pChannelMgt;
@synthesize m_strDID;
@synthesize currentTextField;
@synthesize m_strPwd;
@synthesize m_strRecv1;
@synthesize m_strRecv2;
@synthesize m_strRecv4;
@synthesize m_strRecv3;
@synthesize m_strSender;
@synthesize m_strSMTPSvr;
@synthesize m_strUser;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    if (isP2P) {
      m_pChannelMgt->SetMailDelegate((char*)[m_strDID UTF8String], nil);
        m_pChannelMgt=nil;
    }else{
        netUtiles.mailProtocol=nil;
        netUtiles=nil;
    }

    
    self.navigationBar = nil;
    self.tableView = nil;
    self.m_strDID = nil;
    self.currentTextField = nil;
    self.m_strSender = nil;
    self.m_strSMTPSvr = nil;
    self.m_strUser = nil;
    self.m_strPwd = nil;
    self.m_strRecv1 = nil;
    self.m_strRecv2 = nil;
    self.m_strRecv3 = nil;
    self.m_strRecv4 = nil;
    [super dealloc];
}


- (void)switchChanged: (id) sender
{
    
    NSLog(@"switchChanged....");
    UISwitch *mySwitch = (UISwitch*)sender;
    isFirstShowing=YES;
    if (mySwitch.isOn) {
        m_nTableviewCount = 11;
        m_nAuth = 1;
    }else{
        m_nAuth = 0;
        m_strUser=@"";
        m_strPwd=@"";
        m_nTableviewCount = 9;
    }
    
    [self.tableView reloadData];
} 

- (void) btnSetMail:(id) sender
{
    if (currentTextField!=nil) {
        [currentTextField resignFirstResponder];
    }
    
    
   // NSLog(@"sender: %@, smtpsvr: %@, port: %d, ssl:%d, auth: %d, user: %@, pwd: %@, recv1: %@, recv2: %@, recv3: %@, recv4: %@", m_strSender,m_strSMTPSvr, m_nSMTPPort, m_nSSL, m_nAuth, m_strUser, m_strPwd, m_strRecv1, m_strRecv2, m_strRecv3, m_strRecv4);
    NSString * regex = @".*[\u4e00-\u9fa5]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:m_strSender];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailSender", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strSMTPSvr];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailSmtpSvr", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strUser];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailUser", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strPwd];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailPwd", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strRecv1];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailRecv1", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strRecv2];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailRecv2", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strRecv3];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailRecv3", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    isMatch = [pred evaluateWithObject:m_strRecv4];
    if (isMatch) {
        [mytoast showWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"MailRecv4", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"nochinese", @STR_LOCALIZED_FILE_NAME, nil)]];
        
        return;
    }
    if (isP2P) {
         m_pChannelMgt->SetMail((char*)[m_strDID UTF8String],
                                           (char*)[m_strSender UTF8String],
                                           (char*)[m_strSMTPSvr UTF8String],
                                           m_nSMTPPort,
                                           m_nSSL,
                                           m_nAuth,
                                           (char*)[m_strUser UTF8String],
                                           (char*)[m_strPwd UTF8String],
                                           (char*)[m_strRecv1 UTF8String],
                                           (char*)[m_strRecv2 UTF8String],
                                           (char*)[m_strRecv3 UTF8String],
                                           (char*)[m_strRecv4 UTF8String]);
        
    }else{
        [netUtiles setMail:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd Sender:m_strSender Smtp_svr:m_strSMTPSvr Smtp_port:m_nSMTPPort SSL:m_nSSL Auth:m_nAuth StrUser:m_strUser StrPwd:m_strPwd Recv1:m_strRecv1 Recv2:m_strRecv2 Recv3:m_strRecv3 Recv4:m_strRecv4];
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
    isFirstShowing=YES;
    
    self.m_strSender = @"";
    self.m_strSMTPSvr = @"";
    self.m_strUser = @"";
    self.m_strPwd = @"";
    self.m_strRecv1 = @"";
    self.m_strRecv2 = @"";
    self.m_strRecv2 = @"";
    self.m_strRecv3 = @"";
    self.m_strRecv4 = @"";
    m_nSMTPPort = 0;
    m_nSSL = 0;
    m_nAuth = 0;
    m_nTableviewCount = 9;
    
    UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    if (![IpCameraClientAppDelegate is43Version]) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    //self.navigationBar.delegate = self;//ios8
    self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"MailSetting", @STR_LOCALIZED_FILE_NAME, nil);
    
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
    [btnRight addTarget:self action:@selector(btnSetMail:) forControlEvents:UIControlEventTouchUpInside];
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
        m_pChannelMgt->SetMailDelegate((char*)[m_strDID UTF8String], self);
        
        m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }else{
        
        //netUtiles.mailProtocol=self;
        [netUtiles getCameraParam:m_strIp Port:m_strPort User:m_User Pwd:m_Pwd ParamType:7];
    }
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    imgView.frame=tableView.frame;
    imgView.center=tableView.center;
    tableView.backgroundView=imgView;
    [imgView release];
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


#pragma mark -
#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"accessoryButtonTappedForRowWithIndexPath.. row: %d", anIndexPath.row);
    
    
    if (anIndexPath.row != 1) {
        return ;
    }
    if (currentTextField!=nil) {
        [currentTextField resignFirstResponder];
    }
    
    
    oDropController *dropView = [[oDropController alloc] init];
    dropView.m_nIndexDrop = 104;
    dropView.m_DropListProtocolDelegate = self;
    [self.navigationController pushViewController:dropView animated:YES];
    [dropView release];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return m_nTableviewCount;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier1 = @"MailSettingCell1"; //CameraInfoCell
    NSString *cellIdentifier2 = @"MailSettingCell2"; //oSwitchCell
    NSString *cellIdentifier3 = @"MailSettingCell3"; //oLabelCell
    
    UITableViewCell *cell = nil;
    
    switch (anIndexPath.row) {
        case 0: //sender
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
                
            }
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSender", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strSender;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailSender", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell = cell1;
            
            
        }
            break;
        case 1: //SMTP server
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSmtpSvr", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strSMTPSvr;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailServer", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 2: //smtp port
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSmtpPort", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nSMTPPort];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 3: //ssl
        {
            oLableCell *cell1 =  (oLableCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (cell1 == nil)
            {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell_ipad" owner:self options:nil];
                }
                
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSSL", @STR_LOCALIZED_FILE_NAME, nil);
            
            NSString *strSSL = NSLocalizedStringFromTable(@"MailNone", @STR_LOCALIZED_FILE_NAME, nil);
            switch (m_nSSL) {
                case 0: //NONE
                    strSSL = NSLocalizedStringFromTable(@"MailNone", @STR_LOCALIZED_FILE_NAME, nil);
                    break;
                case 1: //SSL
                    strSSL = NSLocalizedStringFromTable(@"MailSSL", @STR_LOCALIZED_FILE_NAME, nil);
                    break;
                case 2: //TLS
                    strSSL = NSLocalizedStringFromTable(@"MailTLS", @STR_LOCALIZED_FILE_NAME, nil);
                    break;
                    
                default:
                    m_nSSL = 0;
                    break;
            }
            cell1.DescriptionLable.text = strSSL;
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell = cell1;
            
        }
            break;
        case 4: //authentication
        {
            oSwitchCell *cell1 =  (oSwitchCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (cell1 == nil)
            {
                NSArray *nib;
                if ([IpCameraClientAppDelegate isiPhone]) {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                }else{
                    nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell_ipad" owner:self options:nil];
                }
                
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailAuth", @STR_LOCALIZED_FILE_NAME, nil);
            [cell1.keySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            if (m_nAuth) {
                [cell1.keySwitch setOn:YES];
            }else{
                [cell1.keySwitch setOn:NO];
            }
           // [cell1.keySwitch setOnTintColor:[UIColor colorWithRed:0.5 green:0.9 blue:0.2 alpha:1]];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 5: //user || receiver1
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailUser", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strUser;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailUser", @STR_LOCALIZED_FILE_NAME, nil);
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv1", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv1;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            }
            
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 6: //pwd || receiver2
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strPwd;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputPassword", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.secureTextEntry = YES;
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv2", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv2;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.secureTextEntry = NO;
            }
            
            
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 7: //recv1 || recv3
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv1", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv1;
                
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv3", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv3;
            }
            
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 8: //recv2 || recv4
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv2", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv2;
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv4", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv4;
            }
            
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 9: //recv3
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv3", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strRecv3;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 10: //recv4
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                if ([IpCameraClientAppDelegate isiPhone]) {
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }else{
                    UINib *nib=[UINib nibWithNibName:@"CameraInfoCell_ipad" bundle:nil];
                    [aTableView registerNib:nib forCellReuseIdentifier:cellIdentifier1];
                    cell1 = (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                }
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv4", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strRecv4;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.textField.keyboardType=UIKeyboardTypeEmailAddress;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
            
        default:
            break;
    }
    
    
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    if (currentTextField!=nil) {
        [currentTextField resignFirstResponder];
    }
    
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    if (anIndexPath.row != 3) {
        return ;
    }
    
    oDropController *dropView = [[oDropController alloc] init];
    dropView.m_nIndexDrop = 103;
    dropView.m_DropListProtocolDelegate = self;
    [self.navigationController pushViewController:dropView animated:YES];
    [dropView release];
    
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


#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
        return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
    switch (textField.tag) {
        case 0: // sender
            self.m_strSender = textField.text;
            break;
        case 1: //smtp server
            self.m_strSMTPSvr = textField.text;

            break;
        case 2: //smtp port
            m_nSMTPPort = atoi([textField.text UTF8String]);
            if (m_nSMTPPort <= 0) {
                m_nSMTPPort = 25;
            }
            break;
        case 3://ssl
            m_nSSL = atoi([textField.text UTF8String]);
            if (m_nSMTPPort < 0) {
                m_nSMTPPort = 0;
            }
            break;
        case 4: //auth
           
            break;
        case 5: //user || recv1
        {
            if (m_nAuth) {
                self.m_strUser = textField.text;
            }else{
                self.m_strRecv1 = textField.text;
            }
        }
            break;
        case 6: //pwd || recv2;
        {
            if (m_nAuth) {
                self.m_strPwd = textField.text;
            }else{
                self.m_strRecv2 = textField.text;
            }
        }
            break;
        case 7: //recv1 || recv3
        {
            if (m_nAuth) {
                self.m_strRecv1 = textField.text;
            }else{
                self.m_strRecv3 = textField.text;
            }
            
        }
            break;
        case 8: //recv2 || recv4
        {
            if (m_nAuth) {
                self.m_strRecv2 = textField.text;
            }else{
                self.m_strRecv4 = textField.text;
            }
        }
            break;
        case 9: //recv3
        {
            self.m_strRecv3 = textField.text;
        }
            break;
        case 10: //recv4
        {
            self.m_strRecv4 = textField.text;
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
        case 2:
            if (range.location>5) {
                return NO;
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
        [self.tableView reloadData];
    }
    
}

#pragma mark -
#pragma mark droplistdelegate
- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 103) { //SSL
        m_nSSL = nID;
        NSLog(@"m_nSSL=%d",m_nSSL);
    }
    
    if (nType == 104) { //smtp server
        self.m_strSMTPSvr = strDescription;
        m_nSMTPPort = param1;
        m_nSSL = param2;
    }

    
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark maildelegate



-(void)MailProtocolResult:(STRU_MAIL_PARAMS)t{
    if (isSetOver) {
        return;
    }
    self.m_strSender = [NSString stringWithUTF8String:t.sender];
    self.m_strSMTPSvr = [NSString stringWithUTF8String:t.svr];
    m_nSMTPPort = t.port;
    m_nSSL = t.ssl;
    m_nAuth = strlen(t.user)>0?1:0;
    self.m_strUser = [NSString stringWithUTF8String:t.user];
    self.m_strPwd = [NSString stringWithUTF8String:t.pwd];
    self.m_strRecv1 = [NSString stringWithUTF8String:t.receiver1];
    self.m_strRecv2 = [NSString stringWithUTF8String:t.receiver2];
    self.m_strRecv3 = [NSString stringWithUTF8String:t.receiver3];
    self.m_strRecv4 = [NSString stringWithUTF8String:t.receiver4];
    
    if (m_nAuth) {
        m_nTableviewCount = 11;
    }
    
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}

@end
