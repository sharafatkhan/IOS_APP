//
//  PresetDialog.m
//  P2PCamera
//
//  Created by Tsang on 13-5-6.
//
//

#import "PresetDialog.h"
#import "obj_common.h"
#define PATH_PRESET  "preset"
@implementation PresetDialog
@synthesize diaDelegate;
@synthesize btnCall;
@synthesize btnSet;
@synthesize strDid;
- (id)initWithFrame:(CGRect)frame Num:(int)num DID:(NSString *)did
{
    self = [super initWithFrame:frame];
    self.strDid=did;
    int width=frame.size.width;
    int height=frame.size.height;
    dicImgs=[[NSMutableDictionary alloc] initWithCapacity:16];
    btnArr=[[NSMutableArray alloc]initWithCapacity:16];
    [self getPresetImage];
    
    
    btnCall=[[PaomaButton alloc]initWithFrame:CGRectMake(0, 0, width/2, 40)];
    btnCall.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    btnCall.tag=101;
    
    [btnCall addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnCall setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    btnCall.selected=YES;
  
   [btnCall setBtnTitle:NSLocalizedStringFromTable(@"preset_call", @STR_LOCALIZED_FILE_NAME, nil) Color:[UIColor blueColor]];
    [self addSubview:btnCall];
    
   
    
    btnSet=[[PaomaButton alloc]initWithFrame:CGRectMake( width/2, 0, width/2, 40)];
    btnSet.tag=102;
    btnSet.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [btnSet addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
   
    [btnSet setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateSelected];
    
    [btnSet setBtnTitle:NSLocalizedStringFromTable(@"preset_set", @STR_LOCALIZED_FILE_NAME, nil) Color:[UIColor blackColor]];
    [self addSubview:btnSet];
    
    height-=40;
    btnWidth=(width-5*(num+1))/num;
    btnHeight=(height-5*(num+1))/num;
    int n=0;
    if (self) {
        for (int i=0; i<num; i++) {
            for (int j=0; j<num; j++) {
                n++;
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnArr addObject:btn];
                btn.frame=CGRectMake(5*(j+1)+btnWidth*j,40+5*(i+1)+btnHeight*i,btnWidth,btnHeight);
                btn.tag=n;
                [btn setBackgroundImage:[UIImage imageNamed:@"dialogbtnselect.png"] forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
                btn.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
                UIImage *img=[dicImgs objectForKey:[NSString stringWithFormat:@"%d",n-1]];
                if (img!=nil) {
                    [btn setBackgroundImage:img forState:UIControlStateNormal];
                }else{
                    [btn setTitle:[NSString stringWithFormat:@"%d",n] forState:UIControlStateNormal];
                }
                
                [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
    return self;
}
-(void)onClick:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    int tag=btn.tag;
    switch (tag) {
        case 101:
            btnSet.selected=NO;
            btnCall.selected=YES;
            [btnCall setBtnTitleColor:[UIColor blueColor]];
            [btnSet setBtnTitleColor:[UIColor blackColor]];
            break;
        case 102:
            btnSet.selected=YES;
            btnCall.selected=NO;
            [btnSet setBtnTitleColor:[UIColor blueColor]];
            [btnCall setBtnTitleColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
    [diaDelegate presetDialogOnClick:tag];
}

-(void)savePresetImage:(UIImage*)img  Index:(int)index{
    if (img==nil) {
        return;
    }
    index-=1;
    UIButton *btn=(UIButton*)[btnArr objectAtIndex:index];
    [btn setTitle:@"" forState:UIControlStateNormal];
    UIImage *image=[self imageWithImage:img scaledToSize:CGSizeMake(btnWidth, btnHeight)];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self saveImage:image andIndex:index];
}

#pragma mark--获取预置位的图片
-(void)getPresetImage{
    for(int i=0;i<16;i++){
        UIImage *img=[self getImageWithPath:[NSString stringWithFormat:@"%@/p%d.jpg",strDid,i]];
        if (img!=nil) {
            [dicImgs setObject:img forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
}

-(UIImage*)getImageWithPath:(NSString*)path{
    NSArray *arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[arrPath objectAtIndex:0];
    path=[documentPath stringByAppendingPathComponent:path];
    
    UIImage *img=[UIImage imageWithContentsOfFile:path];
    if (img!=nil) {
        NSLog(@"getImageWithPath...path=%@存在",path);
        return img;
    }
    
    return nil;
}
-(void)saveImage:(UIImage*)img andIndex:(int)index{
    
    
    NSFileManager *fileManage=[NSFileManager defaultManager];
   
    NSArray *arrPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[arrPath objectAtIndex:0];
    NSString *path=[document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strDid]];
    [fileManage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"p%d.jpg",index]];
    NSLog(@"path=%@",path);
    NSData *imgData=UIImageJPEGRepresentation(img, 1.0);
    BOOL res=[imgData writeToFile:path atomically:YES];
    if (res) {
        NSLog(@"Preset 图片保存成功");
    }else{
        NSLog(@"Preset 图片保存失败");
    }
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
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}


@end
