//
//  GameLayer.m
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import "GameLayer.h"
#import "GATetris.h"
#import "GATetrisFactory.h"
#import "GARow.h"
#import "GAControlLayer.h"

static GameLayer *sharedGamelayer = nil;

@implementation GameLayer

@synthesize texture, tileMatrix, tetris = currentTetris, level = _level, deletedRows = _deletedRows;

#pragma mark - Init & Factory methods

+(id)scene
{
	CCScene *scene = [CCScene node];
	
	GameLayer *gamelayer = [GameLayer node];
	GAControlLayer *controlLayer = [GAControlLayer node];
	
	[scene addChild:gamelayer];
	[scene addChild:controlLayer];
	
	return scene;
}

+(GameLayer *)sharedGamelayer
{	
	NSAssert(sharedGamelayer != nil, @"No sharedGameLayer available!");
	
	return sharedGamelayer;	
}

-(id)init
{
	if (self = [super init])
	{
		NSAssert(sharedGamelayer == nil, @"Already existing shared game layer");
		
		CGSize screenSize					= [CCDirector sharedDirector].winSize;

		CCSpriteFrameCache *spriteCache		= [CCSpriteFrameCache sharedSpriteFrameCache];
		CCTextureCache *cache				= [CCTextureCache sharedTextureCache];
		
		[spriteCache addSpriteFramesWithFile:@"tiles.plist"];
		
		/*
		 * Basic Layer initialization
		 *******************************************************************************************/
		sharedGamelayer = self;
		
		skipInputs		= NO;
		_level			= 1;
		_deletedRows	= 0;
		
		texture			= [cache addImage:@"tiles.png"];
		tileMatrix		= [GAMatrix tileMatrix];
		currentTetris	= nil;
		tetrisFactory	= [GATetrisFactory node];
		
		
		self.isTouchEnabled = NO;
		/*******************************************************************************************/

		

		/*
		 * BackGround SubLayer
		 *******************************************************************************************/
		background = [CCSprite spriteWithSpriteFrameName:@"PNG/background.png"];
		
		background.anchorPoint = CGPointMake(0, 0);

		float xBackground = 0;
		float yBackground = (screenSize.height - background.contentSize.height);
		
		background.position = CGPointMake(xBackground, yBackground);
		background.color	= ccYELLOW;
		background.opacity	= 100;

		
		[self addChild:background z:0 tag:kNodeTagBackground];
		
		[background addChild:tetrisFactory z:0 tag:kNodeTagTetrisFactory];
		/*******************************************************************************************/
		
		/*
		 *  Label fonts
		 *******************************************************************************************/
		
		float avaibleHeight = background.position.y / 2;
		
		
		CCLabelTTF *level = [CCLabelTTF node];
		
		[level setColor:ccWHITE];
		[level setFontName:@"Marker Felt"];
		[level setFontSize:32];
		
		level.anchorPoint = CGPointMake(0, 0.5);
		
		level.position = CGPointMake(TILE_SIZE, avaibleHeight);
		
		[self addChild:level z:0 tag:kNodeTagLevelLabel];
		
		CCLabelTTF *deletedRows = [CCLabelTTF node];
		
		[deletedRows setColor:ccWHITE];
		[deletedRows setFontName:@"Marker Felt"];
		[deletedRows setFontSize:32];
		
		deletedRows.anchorPoint = CGPointMake(1, 0.5);
		
		deletedRows.position = CGPointMake(screenSize.width - TILE_SIZE, avaibleHeight);
		
		[self addChild:deletedRows z:0 tag:kNodeTagDeletedLabel];
		
		[self updateLabels];
		
		/*******************************************************************************************/
		
		/*
		 * Game starts!
		 *******************************************************************************************/
		[self dropTetris];
		[self schedule:@selector(moveDownTetris) interval: 2 / self.level];
		/*******************************************************************************************/
	}
	
	return self;
	
}

-(void)dealloc
{
	sharedGamelayer = nil;
}


#pragma mark - Utility methods

-(void)updateLabels
{
	CCLabelTTF *level = (CCLabelTTF *)[self getChildByTag:kNodeTagLevelLabel];
	
	[level setString:[NSString stringWithFormat:@"Level %d", self.level]];
	
	CCLabelTTF *rows = (CCLabelTTF *)[self getChildByTag:kNodeTagDeletedLabel];
	
	[rows setString:[NSString stringWithFormat:@"Rows %d", self.deletedRows]];
}

-(CGPoint)tetrisPositionInWorld
{
	return [[self getChildByTag:kNodeTagBackground] convertToWorldSpaceAR:currentTetris.position];
}

-(BOOL)legalMove:(CCNode *)shadow
{
	BOOL canMove = YES;
	
	for (CCNode *tile in shadow.children)
	{
		CGPoint matrixPosition  = [shadow convertToWorldSpaceAR:tile.position];
				
		if (matrixPosition.x < 0 || matrixPosition.x >= (TILE_COL * TILE_SIZE) || matrixPosition.y < 0)
		{
			canMove = NO;
			break;
		}
		else if ([tileMatrix isCoordOccupied:[self convertPositionToIndex:matrixPosition]])
		{
			canMove = NO;
			break;
		}
		
	}
	
	return canMove;
}

-(CGPoint)convertPositionToIndex:(CGPoint)matrixPosition
{
	CGPoint index;
	
	index.y = (int)(matrixPosition.x / TILE_SIZE);
	index.x = (int)(matrixPosition.y / TILE_SIZE);
	
	return index;
}

-(CGPoint)convertIndexToPosition:(CGPoint)index
{
	CGPoint position;
	
	position.y = (int)(index.x * TILE_SIZE);
	position.x = (int)(index.y * TILE_SIZE);
	
	return position;
}


#pragma mark - Gameplay methods

-(void)updateGame
{
	_deletedRows++;
	
	if (!(self.deletedRows % ROWS_PER_LEVEL))
	{
		_level++;
		
		[self schedule:@selector(moveDownTetris) interval:2 / self.level];
	}
	
	[self updateLabels];
}

-(void)moveTetris:(EnumMoveDirections)move
{
	if (skipInputs)
		return;
	
	CCNode *shadow = [currentTetris askedToMoveTo:move];
	
	if ([self legalMove:shadow])
	{
		[currentTetris moveToDirection:move];
	}
	
}

-(void)rotateTetris:(EnumRotateDirections)rotate
{
	if (skipInputs)
		return;
	
	CCNode *shadow = [currentTetris askedToRotate:rotate];
	
	if ([self legalMove:shadow])
	{
		[currentTetris rotateToDirection:rotate];
	}
	
}

-(void)dropTetris
{

	float yCoord = background.contentSize.height - TILE_SIZE;
	float xCoord = 0;
	CGPoint tetrisPosition = CGPointMake(xCoord, yCoord);
	
	currentTetris = [tetrisFactory randomTetris];
	
	[background addChild:currentTetris];
	
	do
	{
		xCoord = (abs(rand()) % TILE_COL) * TILE_SIZE;
		tetrisPosition = CGPointMake(xCoord, yCoord);
		
		[currentTetris moveTo:tetrisPosition];
		
	} while (![self legalMove:currentTetris]);
	
}

-(void)moveTetrisAllDown
{
	skipInputs = YES;
	
	if([self moveDownTetris])
	{
		[self schedule:_cmd interval: DROP_RATE / self.level];
	}
	else
	{
		[self unschedule:_cmd];
		skipInputs = NO;
	}
}

-(BOOL)moveDownTetris;
{
	NSMutableArray *rowsToProcess;
	
	BOOL canMove = YES;
	
	CCNode *shadowTetris = [currentTetris askedToMoveTo:kMoveDirectionDown];
	
	canMove = [self legalMove:shadowTetris];
	
	if (canMove)
		[currentTetris moveToDirection:kMoveDirectionDown];
	else
	{
		/*
		 Tetris is destroyed and tiles are given back to the TetrisFactory.
		 Rows occupied by the tetris are returned for next checks.
		*/
		rowsToProcess = [self killCurrentTetris];
		
		/*
		 Rows checked as full are marked for deletion.
		*/
		[self checkRowsForDeletion:&rowsToProcess];
		
		/*
		The rows marked for deletion are deleted from the game Matrix (tiles are substituted with NSNull objects).
		*/
		[self deleteRows:rowsToProcess];
		
		/*
		Not-empty rows above deleted ones are shifted down to the lowest legal position.
		*/
		[self shiftDownMatrixRows:&rowsToProcess];
		
		/*
		For shifted rows, tiles' position is updated.
		*/
		[self collapseDownTilesInRows:rowsToProcess];
		
		/*
		The game loop restart.
		*/
		[self dropTetris];

	}
	
	return canMove;
}

-(void)shiftDownMatrixRows:(NSMutableArray **)rowSet
{
	NSMutableArray *shiftedRows = [NSMutableArray array];
	
	NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES];
	
	NSArray *orderedRows = [*rowSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
	
	for (int i = 0; i < [orderedRows count]; i++)
	{
		int nextRowToShiftIndex = [[orderedRows objectAtIndex:i] intValue] + 1;
		
		if (nextRowToShiftIndex >= TILE_ROW)
			break;
		
		GARow *nextRowToShift;
		
		while (![(nextRowToShift = [[tileMatrix rows] objectAtIndex:nextRowToShiftIndex]) isEmpty])
		{
			int j = nextRowToShiftIndex - 1;
			
			GARow *toRow;
			
			while ([[[tileMatrix rows] objectAtIndex:j] isEmpty])
				j--;
			
			toRow = [[tileMatrix rows] objectAtIndex:++j];
			
			for (int k = 0; k < TILE_COL; k++)
			{
				id tile = [[nextRowToShift columns] objectAtIndex:k];
				
				if (tile != [NSNull null])
				{
					[[toRow columns] replaceObjectAtIndex:k withObject:tile];
					[[nextRowToShift columns] replaceObjectAtIndex:k withObject:[NSNull null]];
				}
			}
			
			nextRowToShift.isEmpty = YES;
			toRow.isEmpty = NO;
			
			NSNumber *indexOfShiftedRow = [NSNumber numberWithInt:j];
			
			if ([shiftedRows indexOfObject:indexOfShiftedRow] == NSNotFound)
				[shiftedRows addObject:indexOfShiftedRow];
			
			nextRowToShiftIndex++;
			
			if (nextRowToShiftIndex >= TILE_ROW)
				break;
		}
	
	}
	
	*rowSet = shiftedRows;
	
}

-(void)collapseDownTilesInRows:(NSMutableArray *)rowSet
{
	for (id object in rowSet)
	{
		int index = [(NSNumber *)object integerValue];
		
		GARow *row = [[tileMatrix rows] objectAtIndex:index];
		
		for (int i = 0; i < TILE_COL; i++)
		{
			id col = [[row columns] objectAtIndex:i];
			
			if (col != [NSNull null])
			{
				GATile *tile = (GATile *)col;
				
				CGPoint newPosition = [self convertIndexToPosition:CGPointMake(index, i)];
				
				[tile moveTo:newPosition];
			}
		}
	}
}

-(NSMutableArray *)killCurrentTetris
{
	NSMutableArray *toCheck		= [NSMutableArray array];
	NSMutableSet *tiles			= [NSMutableSet set];
	NSNumber *indexToAdd;
	
	for (CCNode *node in currentTetris.children)
	{
		NSAssert([node isKindOfClass:[GATile class]], @"%@ - Incredibly...not a tile!", NSStringFromSelector(_cmd));
		
		GATile *tile = (GATile *)node;
		
		CGPoint newPosition = [currentTetris convertToWorldSpace:tile.position];
		newPosition			= [background convertToNodeSpaceAR:newPosition];
		
		[tile setPosition:newPosition];
		[tiles addObject:tile];

		CGPoint coord = [self convertPositionToIndex:newPosition];
		
		GARow *row = [[tileMatrix rows] objectAtIndex:coord.x];
		
		row.isEmpty = NO;
		
		[[row columns] replaceObjectAtIndex:coord.y withObject:tile];
		
		indexToAdd = [NSNumber numberWithInt:(int)coord.x];
		
		if ([toCheck indexOfObject:indexToAdd] == NSNotFound)
			[toCheck addObject:indexToAdd];
		
	}
	
	[currentTetris removeAllChildrenWithCleanup:YES];
	[tetrisFactory tilesFromKilledTetris:tiles];
	
	currentTetris = nil;
	
	return toCheck;
}

-(void)checkRowsForDeletion:(NSMutableArray **)rowSet
{
	NSMutableArray *toDelete = [NSMutableArray array];
	
	for (int i = 0; i < [*rowSet count]; i++)
	{
		BOOL full = YES;
		
		int currentRowIndex = [[*rowSet objectAtIndex:i] intValue];
		
		GARow *row = [[tileMatrix rows] objectAtIndex:currentRowIndex];
		
		for (id tile in [row columns])
		{
			if (tile == [NSNull null])
			{
				full = NO;
				break;
			}
		}
		
		if (full)
			[toDelete addObject:[NSNumber numberWithInt:currentRowIndex]];
	}
	
	*rowSet = toDelete;
}

-(void)deleteRows:(NSMutableArray *)rowSet
{
	
	for (NSNumber *index in rowSet)
	{
		GARow *row = [[tileMatrix rows] objectAtIndex:[index integerValue]];
		
		for (int i = 0; i < TILE_COL; i++)
		{
			id tile = [[row columns] objectAtIndex:i];
			
			if (tile != [NSNull null])
			{
				[tetrisFactory returnBackTile:(GATile *)tile];
				[[row columns] replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
		
		row.isEmpty = YES;
		
		[self updateGame];
	}
	
	//add particle emitter here!!
	
}


@end


