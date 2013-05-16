//
//  PWPeersCell.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/19/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWPeersCell.h"

@implementation PWPeersCell

static NSString* cellReuseIdentifier = @"PWPeersCell";

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
	
    if (self)
	{
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
