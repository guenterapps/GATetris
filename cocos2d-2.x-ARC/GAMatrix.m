//
//  Matrix.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GAMatrix.h"
#import "GARow.h"


@implementation GAMatrix

@synthesize rows;

+(id)tileMatrix
{
	return [[self alloc] init];
}

-(id)init
{
	
	if (self = [super init])
	{
		rows = [NSMutableArray arrayWithCapacity:TILE_ROW];
		
		for (int i = 0; i < TILE_ROW; i++)
		{
			[rows addObject:[GARow row]];
		}
	}
	
	return self;
}

-(BOOL)isCoordOccupied:(CGPoint)coord
{
	BOOL isOccupied;
	
	if (coord.y < 0 || coord.y >= TILE_COL || coord.x < 0)
		return YES;
	if (coord.x >= TILE_ROW )
		return NO;
	
	GARow * row = [[self rows] objectAtIndex:coord.x];
	
	isOccupied = ([row.columns objectAtIndex:coord.y] != [NSNull null]);
	
	return isOccupied;
	
}


@end
