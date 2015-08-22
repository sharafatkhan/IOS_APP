//
//  VideoTableViewCell.m
//  P2PCamera
//
//  Created by Tsang on 13-8-21.
//
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell
@synthesize labelID;
@synthesize labelName;
@synthesize labelStatus;
-(void)dealloc{
    labelStatus=nil;
    labelID=nil;
    labelName=nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
