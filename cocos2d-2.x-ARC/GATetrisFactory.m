//
//  GATetrisFactory.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GATetrisFactory.h"
#import "GameLayer.h"
#import "Foundation/Foundation.h"

@implementation GATetrisFactory

-(id)init
{
	if (self = [super init])
	{
		int capacity = TILE_ROW * TILE_COL;
		
		freeTiles = [NSMutableSet setWithCapacity:capacity];
		
		batchNode = [CCSpriteBatchNode batchNodeWithTexture:[GameLayer sharedGamelayer].texture];
		
		for (int i = 0; i < capacity; i++)
		{
			GATile *tile = [GATile tile];
			
			tile.color = ccBLUE;
			tile.visible = NO;
			
			[freeTiles addObject:tile];
			
			[batchNode addChild:tile];
		}
		
		[self addChild:batchNode];
		
	}
	
	return  self;
}

-(GATetris *)randomTetris
{
	EnumTetrisType type = 1 + abs(rand()) % (kEnumTetrisType_MAX - 1);
	
	return [self tetrisOfType:type];
}

-(GATetris *)tetrisOfType:(EnumTetrisType)tetrisType
{
	NSMutableSet *tetrisTiles = [[NSMutableSet alloc] initWithCapacity:TETRIS_TILES];
	
	for (int i = 0; i < TETRIS_TILES; i++)
	{
		GATile *tile = [freeTiles anyObject];
		
		NSAssert(tile != nil, @"Oddly, no more tiles available!");
		
		[tetrisTiles addObject:tile];
		
		[batchNode removeChild:tile cleanup:YES];
		[freeTiles removeObject:tile];
	}
	
	return [GATetris tetrisOfType:tetrisType withTiles:tetrisTiles];
}

-(GATile *)getFreeTile
{	
	GATile *tile = [freeTiles anyObject];
	
	NSAssert(tile != nil, @"No more free tiles");
	
	tile.visible	= YES;
	
	[freeTiles removeObject:tile];
	
	return tile;
}

-(void)returnBackTile:(GATile *)tile
{	
	tile.visible		= NO;
	
	[freeTiles addObject:tile];

}

-(void)tilesFromKilledTetris:(NSSet *)tiles
{
	for (GATile *tile in tiles)
	{
		NSAssert([tile isKindOfClass:[GATile class]], @"Oddly, not a tile!");
		
		[batchNode addChild:tile];

	}
}

@end
