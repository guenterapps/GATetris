//
//  GATile.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GATile.h"
#import "GameLayer.h"

@interface GATile (Private)

-(void)setPositionFromCoord:(CGPoint)coord;

@end


@implementation GATile

@synthesize isPivot, shadowTile;


+(id)tile
{
	return [[self alloc] initWithTile];
}

-(id)initWithTile
{
	if (self = [super initWithSpriteFrameName:@"PNG/tile.png"])
	{
		shadowTile = [CCNode node];
		
		shadowTile.anchorPoint	= (self.anchorPoint = OFFSET);
	}
	
	return self;
	
}

-(void)setPosition:(CGPoint)position
{	
	[super setPosition:position];
	
	shadowTile.position = position;
}

-(void)moveTo:(CGPoint)position
{
	self.position = ccpAdd(position, ccpMult(OFFSET, TILE_SIZE));
}

-(CCNode *)askedToMoveDown
{
	shadowTile.position = ccpSub(shadowTile.position, ccpMult(CGPointMake(0, -1), TILE_SIZE));
	
	return shadowTile;
}

@end
