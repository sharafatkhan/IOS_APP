//
//  KavenEditToolBar.m
//  P2PCamera
//
//  Created by Tsang on 14-4-29.
//
//

#import "KavenEditToolBar.h"

@implementation KavenEditToolBar
@synthesize btnAlbum;
@synthesize btnBack;
@synthesize btnDelete;
@synthesize btnEdit;
@synthesize btnReserve;
@synthesize btnSelectAll;
@synthesize btnShare;
@synthesize imgVbg;
@synthesize delegate;
@synthesize isEdit;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        imgVbg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgVbg.backgroundColor=[UIColor blackColor];
        [self addSubview:imgVbg];
        BOOL isPad=NO;
        int btnspace=2;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            isPad=YES;
            btnspace=10;
        }
        
        btnShare=[UIButton buttonWithType:UIButtonTypeCustom];
        btnShare.frame=CGRectMake(5, (frame.size.height-40)/2, 40, 40);
        [btnShare setBackgroundImage:[UIImage imageNamed:@"btnshared.png"] forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(btnOnShare) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnShare];
        
        btnAlbum=[UIButton buttonWithType:UIButtonTypeCustom];
        btnAlbum.frame=CGRectMake(btnShare.frame.origin.x+btnShare.frame.size.width+btnspace, (frame.size.height-40)/2, 40, 40);
        [btnAlbum setBackgroundImage:[UIImage imageNamed:@"btnalbum.png"] forState:UIControlStateNormal];
        [btnAlbum setBackgroundImage:[UIImage imageNamed:@"btnalbumdown.png"] forState:UIControlStateSelected];
         [btnAlbum addTarget:self action:@selector(btnOnAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAlbum];
        
        btnSelectAll=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSelectAll.frame=CGRectMake(frame.size.width/2-40-btnspace/2, (frame.size.height-40)/2, 40, 40);
        [btnSelectAll setBackgroundImage:[UIImage imageNamed:@"btnselectall.png"] forState:UIControlStateNormal];
        [btnSelectAll addTarget:self action:@selector(btnOnSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSelectAll];
        
        btnReserve=[UIButton buttonWithType:UIButtonTypeCustom];
        btnReserve.frame=CGRectMake(frame.size.width/2+btnspace/2, (frame.size.height-40)/2, 40, 40);
        [btnReserve setBackgroundImage:[UIImage imageNamed:@"btnselectreserve.png"] forState:UIControlStateNormal];
        [btnReserve addTarget:self action:@selector(btnOnReserve) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnReserve];
        
        btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame=CGRectMake(frame.size.width-40-5, (frame.size.height-40)/2, 40, 40);
        [btnDelete setBackgroundImage:[UIImage imageNamed:@"btndelete.png"] forState:UIControlStateNormal];
         [btnDelete addTarget:self action:@selector(btnOnDelete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];
        
//        btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
//        btnDelete.frame=CGRectMake(btnBack.frame.origin.x-40-btnspace, (frame.size.height-40)/2, 40, 40);
//        [btnDelete setBackgroundImage:[UIImage imageNamed:@"btndelete.png"] forState:UIControlStateNormal];
//        [btnDelete addTarget:self action:@selector(btnOnDelete) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnDelete];
        
        btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
        btnEdit.frame=CGRectMake((frame.size.width-40)/2, (frame.size.height-40)/2, 40, 40);
        [btnEdit setBackgroundImage:[UIImage imageNamed:@"btnedit.png"] forState:UIControlStateNormal];
        [btnEdit addTarget:self action:@selector(btnOnEdit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnEdit];
        [self showBtn:NO];
    }
    return self;
}
-(void)showBtn:(BOOL)flag{
    if (flag) {
        btnShare.hidden=NO;
        btnAlbum.hidden=NO;
        btnSelectAll.hidden=NO;
        btnReserve.hidden=NO;
        btnBack.hidden=NO;
        btnDelete.hidden=NO;
        btnEdit.hidden=YES;
    }else{
        btnShare.hidden=YES;
        btnAlbum.hidden=YES;
        btnSelectAll.hidden=YES;
        btnReserve.hidden=YES;
        btnBack.hidden=YES;
        btnDelete.hidden=YES;
        btnEdit.hidden=NO;
    }
}

-(void)btnOnShare{
    if (delegate!=nil) {
        [delegate toolBarPressed:0];
    }
}
-(void)btnOnAlbum{
    
    if (delegate!=nil) {
        [delegate toolBarPressed:1];
    }
}
-(void)btnOnSelectAll{
    if (delegate!=nil) {
        [delegate toolBarPressed:2];
    }
}
-(void)btnOnReserve{
    if (delegate!=nil) {
        [delegate toolBarPressed:3];
    }
}

-(void)btnOnDelete{
    if (delegate!=nil) {
        [delegate toolBarPressed:4];
    }
}
-(void)btnOnEdit{
    isEdit=!isEdit;
    [self showBtn:isEdit];
    if (isEdit) {
        if (delegate!=nil) {
            [delegate toolBarPressed:5];
        }
    }
    
}
-(void)btnOnBack{
    if (delegate!=nil) {
        [delegate toolBarPressed:6];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
