//
//  Matrix.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"


@class Row;

@interface GAMatrix : NSObject
{
	NSMutableArray *rows;
}


@property (readonly) NSMutableArray *rows;

+(id)tileMatrix;

-(BOOL)isCoordOccupied:(CGPoint)coord;


@end
