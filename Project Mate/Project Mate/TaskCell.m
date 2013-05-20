//
//  TaskCell.m
//  Project Mate
//
//  Created by 钱 紫霞 on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell
@synthesize title  = _title;
@synthesize time = _time;
@synthesize desc = _desc;


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
