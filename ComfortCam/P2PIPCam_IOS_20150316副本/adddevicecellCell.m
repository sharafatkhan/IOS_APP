//
//  adddevicecellCell.m
//  P2PCamera
//
//  Created by Tsang on 13-5-13.
//
//

#import "adddevicecellCell.h"

@implementation adddevicecellCell
@synthesize labelname;
@synthesize imgView;
@synthesize textField;
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


-(void)dealloc{
    labelname=nil;
    textField=nil;
    imgView=nil;
    
    [super dealloc];
}
@end
