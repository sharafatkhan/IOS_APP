//
//  RecordBean.h
//  P2PCamera
//
//  Created by Tsang on 14-5-19.
//
//

#import <Foundation/Foundation.h>

@interface RecordBean : NSObject
{
    NSString *path;
    NSString *size;
    UIImage *img;
    NSIndexPath *indexpath;
    int number;
    BOOL isLoaded;
}
@property(nonatomic,retain)NSString *path;
@property(nonatomic,retain)NSString *size;
@property(nonatomic,retain)UIImage *img;
@property(nonatomic,retain)NSIndexPath *indexpath;
@property BOOL isLoaded;
@property int number;
@end
