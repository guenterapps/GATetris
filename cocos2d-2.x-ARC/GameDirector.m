//
//  GameDirector.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GameDirector.h"
#import "GameLayer.h"



@implementation GameDirector

@synthesize level, deletedRows;

+(GameDirector *)sharedGameDirector
{
	static GameDirector *sharedDirector;
	
	static dispatch_once_t once;
	
	dispatch_once(&once, ^{sharedDirector = [[self alloc] init];});
	
	return sharedDirector;
	
}

-(id)init
{
	if (self = [super init])
	{
		self.level = 0;
		self.deletedRows = 0;
	
	}
	
	return  self;
}

-(void)startGame
{
	[[GameLayer sharedGamelayer] dropTetris];
}

@end
