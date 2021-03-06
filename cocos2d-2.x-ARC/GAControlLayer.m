//
//  GAControlLayer.m
//  GATetris
//
//  Created by Christian Lao on 30/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GAControlLayer.h"
#import "GameLayer.h"

@implementation GAControlLayer


-(id)init
{
	
	if (self = [super init])
	{
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		self.isTouchEnabled = YES;
		
		winsize = [CCDirector sharedDirector].winSize;
		
		isSwipe = NO;
		ignoreSwipe = NO;
		
		/*
		 * Tetris Save button!
		 *******************************************************************************************/
		GameLayer *sharedGameLayer = [GameLayer sharedGamelayer];
		
		CCMenuItem *saveTetris = [CCMenuItemImage itemWithNormalImage:@"Icon.png" selectedImage:@"Icon.png" target:sharedGameLayer selector:@selector(saveTetris:)];
		
		CCMenu *menu = [CCMenu menuWithItems:saveTetris, nil];
		
		[menu setPosition:CGPointMake(screenSize.width - 2 * TILE_SIZE, screenSize.height / 1.7)];
		
		[self addChild:menu z:1];
		
		/*******************************************************************************************/
		
	}
	
	return  self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	isSwipe = NO;
	ignoreSwipe = NO;

	UITouch *touch = [touches anyObject];

	firstTouch = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];

}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	float treshold = 2 * TILE_SIZE;
	
	if (!isSwipe && !ignoreSwipe)
	{
		UITouch *touch = [touches anyObject];
		CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
	
		CGPoint movingTouch = ccpSub(touchPos, firstTouch);
	
		if (movingTouch.y < -treshold && abs(movingTouch.x) < TILE_SIZE)
		{
			isSwipe = YES;
			ignoreSwipe = YES;
			[[GameLayer sharedGamelayer] moveTetrisAllDown];
		}
		else if (movingTouch.x < - treshold && abs(movingTouch.y) < TILE_SIZE)
		{
			isSwipe = YES;
			ignoreSwipe = YES;
			[[GameLayer sharedGamelayer] rotateTetris:kRotateDirectionLeft];
		}
		else if (movingTouch.x > treshold && abs(movingTouch.y) < TILE_SIZE)
		{
			isSwipe = YES;
			ignoreSwipe = YES;
			[[GameLayer sharedGamelayer] rotateTetris:kRotateDirectionRight];
		}
	
	}
	
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!isSwipe)
	{
		CGPoint	tetrisPosition = [[GameLayer sharedGamelayer] tetrisPositionInWorld];
		

		float treshold = TILE_SIZE;
		
		if (firstTouch.x > tetrisPosition.x + treshold)
		{
			[[GameLayer sharedGamelayer] moveTetris:kMoveDirectionRight];
		}
		else if (firstTouch.x < tetrisPosition.x - treshold)
		{
			[[GameLayer sharedGamelayer] moveTetris:kMoveDirectionLeft];
		}
		else if (firstTouch.y < tetrisPosition.y - treshold)
		{
			[[GameLayer sharedGamelayer] moveTetris:kMoveDirectionDown];
		}
	}
	
}

@end
