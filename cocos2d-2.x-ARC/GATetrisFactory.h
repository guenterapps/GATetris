//
//  GATetrisFactory.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GATetris.h"
#import "GATile.h"

@class GAMatrix;

@interface GATetrisFactory : CCNode
{
    CCSpriteBatchNode *batchNode;
	GAMatrix *matrix;
	NSMutableSet *freeTiles;	
}

-(GATetris *)randomTetris;
-(GATetris *)tetrisOfType:(EnumTetrisType)tetrisType;
-(GATile *)getFreeTile;
-(void)returnBackTile:(GATile *)tile;
-(void)tilesFromKilledTetris:(NSSet *)tiles;


@end
