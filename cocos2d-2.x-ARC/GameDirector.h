//
//  GameDirector.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
	kGameWidth = 10,
	kGameHeight = 20
	
} gameSize;

@interface GameDirector : CCNode
{
	NSUInteger level;
	NSUInteger deletedRows;
    
}

@property NSUInteger level, deletedRows;

+(GameDirector *)sharedGameDirector;
-(void)tetrisStoppedMoving;

-(void)start;
-(void)bottomReached;


@end
