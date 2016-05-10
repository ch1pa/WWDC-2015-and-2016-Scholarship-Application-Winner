//
//  GameScene.h
//  Randall Beck
//

//  Copyright (c) 2015 Ch1pa Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"

@class Story;
@interface GameScene : SKScene {
    
}

@property (nonatomic, assign)long int points;
@property (nonatomic, retain)SKSpriteNode *welcome;
@property (nonatomic, assign)BOOL stop;


-(void)startGame:(id)sender;
-(void)restart:(id)sender;

@end
