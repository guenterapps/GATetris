//
//  GATile.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface GATile : CCSprite

@property (readwrite, nonatomic) BOOL isPivot;
@property (readonly, nonatomic) CCNode *shadowTile;

+(id)tile;


//use moveTo instead of directly set the tile position
-(void)moveTo:(CGPoint)position;
-(CCNode *)askedToMoveDown;

@end
