//
//  PictureBean.h
//  P2PCamera
//
//  Created by Tsang on 14-5-20.
//
//

#import <Foundation/Foundation.h>

@interface PictureBean : NSObject
{
    NSString *path;
    UIImage *img;
    NSIndexPath *indexpath;
    int number;
    BOOL isLoaded;
}
@property(nonatomic,retain)NSString *path;
@property(nonatomic,retain)UIImage *img;
@property(nonatomic,retain)NSIndexPath *indexpath;
@property BOOL isLoaded;
@property int number;
@end
