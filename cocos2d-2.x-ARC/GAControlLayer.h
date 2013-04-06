//
//  GAControlLayer.h
//  GATetris
//
//  Created by Christian Lao on 30/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GAControlLayer : CCLayer
{
	BOOL isSwipe;
	CGPoint firstTouch;
	CGSize winsize;
}

@end
