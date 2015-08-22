//
//  ServerCell.m
//  P2PCamera
//
//  Created by Tsang on 13-4-3.
//
//

#import "ServerCell.h"

@implementation ServerCell
@synthesize tf;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc{
    tf=nil;
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
