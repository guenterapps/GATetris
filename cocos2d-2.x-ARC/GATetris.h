//
//  GATetris.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define TETRIS_TILES 4

typedef enum
{
	kEnumTetrisTypeInvalid = 0,
	
	kEnumTetrisTypeI,
	kEnumTetrisTypeJ,
	kEnumTetrisTypeL,
	kEnumTetrisTypeO,
	kEnumTetrisTypeS,
	kEnumTetrisTypeT,
	kEnumTetrisTypeZ,
	
	kEnumTetrisType_MAX
	
} EnumTetrisType;

typedef enum
{
	kMoveDirectionInvalid = 0,
	
	kMoveDirectionLeft,
	kMoveDirectionDown,
	kMoveDirectionRight,
	
	kMoveDirection_MAX
	
} EnumMoveDirections;

typedef enum
{
	kRotateDirectionInvalid = 0,
	
	kRotateDirectionLeft,
	kRotateDirectionRight,
	
	kRotateDirection_MAX
	
} EnumRotateDirections;



@interface GATetris : CCNode


@property (readwrite, nonatomic, assign) EnumTetrisType tetrisType;
@property (readonly, nonatomic) CCNode *tetrisShadow;


+(GATetris *)tetrisOfType:(EnumTetrisType)tetrisType withTiles:(NSSet *)tiles;

-(CCNode *)askedToMoveTo:(EnumMoveDirections)moveDirection;
-(CCNode *)askedToRotate:(EnumRotateDirections)rotateDirection;

-(void)moveToDirection:(EnumMoveDirections)moveDirection;
-(void)rotateToDirection:(EnumRotateDirections)rotateDirection;

//use moveTo instead of directly set the tetris position
-(void)moveTo:(CGPoint)position;

@end
