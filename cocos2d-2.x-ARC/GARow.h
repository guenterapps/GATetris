//
//  GARow.h
//  GATetris
//
//  Created by Christian Lao on 09/02/13.
//  Copyright 2013 Christian Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GATetris.h"
#import "GameLayer.h"

@interface GARow : NSObject

@property (nonatomic, readwrite, assign) BOOL isEmpty;
@property (nonatomic, readwrite) NSMutableArray *columns;


+(GARow *)row;



@end
