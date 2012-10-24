//
//  ProgramCell.m
//  Orb
//
//  Created by everbird on 10/24/12.
//  Copyright (c) 2012 everbird. All rights reserved.
//

#import "ProgramCell.h"

@implementation ProgramCell

@synthesize program = _program;

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
