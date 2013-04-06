//
//  GATetris.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GATetris.h"
#import "GATile.h"
#import "GameDirector.h"
#import "GAMatrix.h"
#import "GameLayer.h"

typedef enum
{
	kEnumTransTypeRot,
	kEnumTransTypeMov
	
} EnumTransformType;

static CGPoint *moveDirectionOffsets = NULL;

@implementation GATetris;

@synthesize tetrisType, tetrisShadow;

+(GATetris *)tetrisOfType:(EnumTetrisType)tetrisType withTiles:(NSSet *)tiles
{
	return [[self alloc] initWithTetrisOfType:tetrisType withTiles:(NSMutableSet *)tiles];
}


-(id)initWithTetrisOfType:(EnumTetrisType)type withTiles:(NSMutableSet *)tiles
{
	if(self = [super init])
	{
		NSException *e = [NSException exceptionWithName:@"Init Error"
												 reason:[NSString stringWithFormat:@"%@: %d", @"Invalid Tetris type", tetrisType]
											   userInfo:nil];
		
		tetrisShadow = [CCNode node];
		
		self.tetrisType				= type;
		
		self.anchorPoint			= CGPointZero;
		tetrisShadow.anchorPoint	= CGPointZero;
		
		if (moveDirectionOffsets == NULL)
		{
			if((moveDirectionOffsets = malloc(kMoveDirection_MAX * sizeof(CGPoint))) != NULL)
			{
				moveDirectionOffsets[kMoveDirection_MAX-1]	= CGPointZero;
				moveDirectionOffsets[kMoveDirectionLeft]	= CGPointMake(-1, 0);
				moveDirectionOffsets[kMoveDirectionDown]	= CGPointMake(0, -1);
				moveDirectionOffsets[kMoveDirectionRight]	= CGPointMake(1, 0);
			}
		}
		
		for (int i = 0; i < TETRIS_TILES; i++)
		{
			int j;
			
			GATile *tile		= (GATile *)[tiles anyObject];
			CCNode *shadowTile	= [CCNode node];
			
			NSAssert([tile isKindOfClass:[GATile class]], @"Not a tile");
			
			switch (tetrisType)
			{
				case kEnumTetrisTypeI:
					tile.position = CGPointMake(i, 0);
					tile.color = ccMAGENTA;
					break;
				case kEnumTetrisTypeJ:
					if (i < 3)
						tile.position = CGPointMake(i, 0);
					else
						tile.position = CGPointMake(0, 1);
					tile.color = ccBLUE;
					break;
				case kEnumTetrisTypeL:
					if (i < 3)
						tile.position = CGPointMake(i, 0);
					else
						tile.position = CGPointMake(i - 1, 1);
					tile.color = ccORANGE;
					break;
				case kEnumTetrisTypeO:
					if (i < 2)
						tile.position = CGPointMake(i, 0);
					else
						tile.position = CGPointMake(3 - i, 1);
					tile.color = ccYELLOW;
					break;
				case kEnumTetrisTypeS:
					if (i < 2)
						tile.position = CGPointMake(-i, 0);
					else
						tile.position = CGPointMake(i - 2, 1);
					tile.color = ccGREEN;
					break;
				case kEnumTetrisTypeT:
					j = (i == 2) ? 1 : 0;
					tile.position = CGPointMake(i - 2, j);
					tile.color = ccRED;
					break;
				case kEnumTetrisTypeZ:
					if (i < 2)
						tile.position = CGPointMake(i, 0);
					else
						tile.position = CGPointMake(2 - i, 1);
					tile.color = ccWHITE;
					break;
					
				default:
					@throw e;
			}
			
			if (i == 0)
			{
				
				#ifdef DEBUG
				tile.color = ccBLACK;
				#endif
				
				tile.position = CGPointZero;
				tile.isPivot = YES;
			}
			else
				tile.isPivot = NO;
			
			
			tile.visible			= YES;
			shadowTile.position		= (tile.position = ccpMult(tile.position, TILE_SIZE));
			shadowTile.anchorPoint	= (tile.anchorPoint = OFFSET);
			
			[self addChild:tile];
			
			[tiles removeObject:tile];
			
			[tetrisShadow addChild:shadowTile];
			
		}
	}
	
	return self;
}

-(CCNode *)askedToMoveTo:(EnumMoveDirections)moveDirection
{
	[self applyTransformation:kEnumTransTypeMov
					   toNode:self.tetrisShadow
					withValue:[NSNumber numberWithInt:moveDirection]];
	
	return self.tetrisShadow;
}

-(CCNode *)askedToRotate:(EnumRotateDirections)rotateDirection
{
	[self applyTransformation:kEnumTransTypeRot
					   toNode:self.tetrisShadow
					withValue:[NSNumber numberWithInt:rotateDirection]];
	
	return self.tetrisShadow;
}

-(void)moveToDirection:(EnumMoveDirections)moveDirection
{
	[self applyTransformation:kEnumTransTypeMov
					   toNode:self
					withValue:[NSNumber numberWithInt:moveDirection]];
	
}
-(void)rotateToDirection:(EnumRotateDirections)rotateDirection
{

	[self applyTransformation:kEnumTransTypeRot
					   toNode:self
					withValue:[NSNumber numberWithInt:rotateDirection]];
	
}

-(void)applyTransformation:(EnumTransformType)transfType toNode:(CCNode *)node withValue:(NSNumber *)value
{
	
	int trsfValue = [value integerValue];
	float rotation;
	
	switch (transfType)
	{
		case kEnumTransTypeMov:
			NSAssert(trsfValue > kMoveDirectionInvalid && trsfValue < kMoveDirection_MAX, @"Invalid Move Direction");
			
			node.position = ccpAdd(self.position, ccpMult(moveDirectionOffsets[trsfValue], TILE_SIZE));

			break;
		
		case kEnumTransTypeRot:
			NSAssert(trsfValue > kRotateDirectionInvalid && trsfValue < kRotateDirection_MAX, @"Invalid Rotation Direction");
			
			if (self.tetrisType == kEnumTetrisTypeO)
				return;
			
			switch (trsfValue)
			{
				case kRotateDirectionLeft:
					rotation = - 90;
					break;
				case kRotateDirectionRight:
					rotation = 90;
					break;
				default:
					break;
			}
			
			node.rotation += rotation;
			
			break;
			
		default:
			break;
	}
}

-(void)setPosition:(CGPoint)position
{
	[super setPosition:position];
	
	[tetrisShadow setPosition:position];
}

-(void)setRotation:(float)rotation
{
	[super setRotation:rotation];
	
	[tetrisShadow setRotation:rotation];
}

-(void)moveTo:(CGPoint)position
{
	self.position = ccpAdd(position, ccpMult(OFFSET, TILE_SIZE));
}

//-(void)moveDirection:(EnumMoveDirections)moveDirection withAction:(CCAction *)action
//{
//	NSAssert(moveDirection > kMoveDirectionInvalid && moveDirection < kMoveDirection_MAX, @"Invalid Move Direction");
//	
//	BOOL canMove;
//	
//	previousPosition = self.position;
//	previousRotation = self.rotation;
//	
//	self.position = ccpAdd(self.position, ccpMult(moveDirectionOffsets[moveDirection], TILE_SIZE));
//	
//	canMove = [self canMoveTo];
//	
//	self.position = previousPosition;
//	
//	if (canMove)
//		[self runAction:action];
//		
//	
//}
//-(void)moveAllDownWithSpeed:(float)speed
//{
//	previousPosition = self.position;
//	
//	CGPoint newPosition = self.position;
//	
//	while ([self canMoveTo])
//		newPosition.y -= TILE_SIZE;
//		
//	newPosition.y += TILE_SIZE;
//	
//	ccTime duration = (ccTime)(previousPosition.y - newPosition.y) / speed;
//	
//	CCMoveTo *action = [CCMoveTo actionWithDuration:duration position:newPosition];
//	
//	[self moveDirection:kMoveDirectionDown withAction:action];
//	
//}
//-(BOOL)canMoveTo
//{
//	BOOL canMove = YES;
//	
//	for (CCNode *node in self.children)
//	{
//		if (node.position.x < TILE_SIZE / 2 || node.position.x >= (TILE_SIZE) * (TILE_COL - 3/2) || node.position.y <= TILE_SIZE / 2)
//		{
//			canMove = NO;
//			break;
//		}
//		else if ([[GameLayer sharedGamelayer].tileMatrix isCoordOccupied:[self positionToCoordWithNode:node]])
//		{
//			canMove = NO;
//			break;
//		}
//	}
//	
//	return canMove;
//	
//}
//-(void)rotateDirection:(EnumRotateDirections)rotateDirection withAction:(CCAction *)action
//{
//	previousRotation = self.rotation;
//	
//	float rotation;
//	
//	switch (rotateDirection)
//	{
//		case kRotateDirectionLeft:
//			rotation = - 90;
//			break;
//		case kRotateDirectionRight:
//			rotation = 90;
//			break;
//		default:
//			break;
//	}
//	
//	self.rotation += rotation;
//	
//	if ([self canMoveTo])
//	{
//		if (action)
//		{
//			self.rotation = previousRotation;
//			
//			[self runAction:action];
//		}
//	}
//	else
//		self.rotation = previousRotation;
//
//	
//}
//
//-(CGPoint)positionToCoordWithNode:(CCNode *)node
//{
//	CGPoint positionInMatrix = ccpAdd(self.position, node.position);
//	
//	positionInMatrix.x = (int)positionInMatrix.x / TILE_SIZE;
//	positionInMatrix.y = (int)positionInMatrix.y / TILE_SIZE;
//	
//	return positionInMatrix;
//	
//}


@end
