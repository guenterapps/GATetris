//
//  GARow.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GARow.h"


@implementation GARow

@synthesize isEmpty, columns;

+(GARow *)row
{
	return [[self alloc] init];
}


-(id)init
{
	
	if (self = [super init])
	{
		self.isEmpty = YES;
		
		columns = [NSMutableArray arrayWithCapacity:TILE_COL];
		
		for (int i = 0; i < TILE_COL; i++)
		{
			[columns addObject:[NSNull null]];
		}

	}
	
	return  self;
}
@end
