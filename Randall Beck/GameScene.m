//
//  GameScene.m
//  Randall Beck
//
//  Created by Randall Beck on 4/17/15.
//  Copyright (c) 2015 Ch1pa Software. All rights reserved.
//

#import "GameScene.h"
#import "Score.h"
#import "Randall_Beck-Swift.h"
#import <AVFoundation/AVFoundation.h>
@import AVFoundation;

static const float BG_MOVE_SEC = 165;
static const float SLOTH_MOVE_SEC = 10;
//static const float SLOTH_ROTATE_RADIANS_SEC = 4*M_PI;

#define ARC4RANDOM_MAX 0x100000000

static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random()/ARC4RANDOM_MAX) *(max - min) +min);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x+b.x, a.y+b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x-b.x, a.y-b.y);
}

static inline CGPoint CGPointScalar(const CGPoint a, const CGFloat b) {
    return CGPointMake(a.x*b, a.y*b);
}

static inline CGFloat CGPointLength(const CGPoint a) {
    return sqrtf(a.x*a.x + a.y*a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a) {
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x/length, a.y/length);
}

/*static inline CGFloat CGPointToAngle(const CGPoint a) {
 return atan2f(a.y, a.x);
 }
 */
/*static inline CGFloat ScalarSign(CGFloat a) {
 return a>=0 ? 1:-1;
 }
 
 static inline CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b) {
 CGFloat distance = b-a;
 CGFloat angle = fmodf(distance, M_PI * 2);
 if (angle >=M_PI) {
 angle -=M_PI*2;
 }
 else if (angle <= -M_PI) {
 angle +=M_PI*2;
 }
 return angle;
 }*/

@implementation GameScene {
    
    SKSpriteNode *_sloth;
    SKSpriteNode *_enemy;
    SKSpriteNode *_jaguar;
    SKAction *_slothAnimation;
    SKAction *_eagleAnimation;
    SKAction *_jaguarAnimation;
    CGPoint _velocity;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _lastTouchLocation;
    AVAudioPlayer *_backgroundMusic;
    int _lives;
    BOOL _gameOver;
    BOOL _invincible;
    BOOL _shouldStart;
    BOOL _storyTime;
    SKSpriteNode *_welcome;
    BOOL _welcomeExists;
    
    float slothScale;
    
    SKSpriteNode *heart1;
    SKSpriteNode *heart2;
    SKTexture *emptyHeart;
    SKTexture *fullHeart;
    SKLabelNode *labelNode;
    
    SKSpriteNode *bullet;
    SKSpriteNode *bullet2;
    SKSpriteNode *fire;
    SKSpriteNode *bull1;
    SKSpriteNode *bull2;
    SKSpriteNode *container;
    SKTexture *fullBullet;
    SKTexture *emptyBullet;
    BOOL _didFire;
    int ammo;
    
    SKEmitterNode *smoke;
    SKEmitterNode *smoke2;
    
    BOOL shouldCheck1;
    BOOL shouldCheck2;
    
    SKSpriteNode *shrinker;
    SKSpriteNode *pointPower;
    SKSpriteNode *livePlus;
    BOOL _didSendHeart;
    
    SKSpriteNode *pointBonus;
    SKSpriteNode *pointImage;
    
    GameViewController *_vc;
    
    BOOL story1;
    BOOL story2;
    BOOL story3;
    BOOL story4;
    BOOL story5;
    BOOL story6;
    
}

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        _lives = 2;
        _gameOver = NO;
        _points = 0;
        if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
            [self playBackgroundMusic:@"musicTechno.mp3"];
        }
        
        for (int i=0; i<2; i++) {
            SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"RoadBG"];
            bg.anchorPoint = CGPointZero;
            bg.position = CGPointMake(0, i * bg.size.height);
            [bg setSize:CGSizeMake(self.size.width, bg.size.height)];
            bg.name = @"bg";
            bg.zPosition = 0;
            [self addChild:bg];
            
        }
        
        _stop = NO;
        
        _vc = [[GameViewController alloc] init];
        
        
        _didSendHeart = NO;
        slothScale = 0.3;
        shouldCheck1 = NO;
        shouldCheck2 = NO;
        _sloth = [SKSpriteNode spriteNodeWithImageNamed:@"rb1"];
        //[_sloth setScale:.1111];
        [_sloth setScale:.03];
        _sloth.position = CGPointMake(self.size.width/2, 60);
        _sloth.name = @"MrSloth";
        _sloth.zPosition = 10;
        [self addChild:_sloth];
        
        _welcome = [SKSpriteNode spriteNodeWithImageNamed:@"InstructionScreen"];
        //_welcome.anchorPoint = CGPointZero;
        _welcome.position = CGPointMake(self.size.width/2, self.size.height/2);
        _welcome.zPosition = 1;
        _welcome.name = @"Welcome";
        [self addChild:_welcome];
        _welcomeExists = YES;
        
        heart1 = [SKSpriteNode spriteNodeWithImageNamed:@"heart"];
        heart2 = [SKSpriteNode spriteNodeWithImageNamed:@"heart"];
        [heart1 setScale:.25];
        [heart2 setScale:.25];
        heart1.position = CGPointMake(self.size.width-30, self.size.height-20);
        heart2.position = CGPointMake(heart1.position.x-36, self.size.height-20);
        heart1.zPosition = 8;
        heart2.zPosition = 8;
        [self addChild:heart1];
        [self addChild:heart2];
        
        emptyHeart = [SKTexture textureWithImageNamed:@"heartEmpty"];
        fullHeart = [SKTexture textureWithImageNamed:@"heart"];
        
        labelNode = [SKLabelNode labelNodeWithFontNamed:@"Sinkhole"];
        labelNode.text = [NSString stringWithFormat:@"%li", _points];
        labelNode.fontSize = 32;
        labelNode.fontColor = [SKColor lightTextColor];
        [labelNode setPosition:CGPointMake(self.size.width/2.8, self.size.height-30)];
        [self addChild:labelNode];
        
        container = [SKSpriteNode spriteNodeWithImageNamed:@"bulletContainer"];
        container.zPosition = 15;
        [container setScale:.175];
        container.position = CGPointMake(self.size.width-10, self.size.height-self.size.height/1.5);
        [self addChild:container];
        
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        [bullet setScale:.333];
        bullet.zPosition = 12;
        
        bullet2 = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        [bullet2 setScale:.333];
        bullet2.zPosition = 13;
        
        fire = [SKSpriteNode spriteNodeWithImageNamed:@"fireButton"];
        fire.position = CGPointMake(self.size.width-20, 140);
        [fire setScale:.2];
        fire.zPosition = 20;
        fire.name = @"fireButtonNode";
        [self addChild:fire];
        
        bull1 = [SKSpriteNode spriteNodeWithImageNamed:@"fullBulletContainer"];
        [bull1 setScale:0.2];
        bull1.zPosition = 16;
        bull1.position = CGPointMake(container.position.x, container.position.y-12.0);
        bull2 = [SKSpriteNode spriteNodeWithImageNamed:@"fullBulletContainer"];
        [bull2 setScale:0.2];
        bull2.zPosition = 16;
        bull2.position = CGPointMake(container.position.x, container.position.y+12.5);
        [self addChild:bull1];
        [self addChild:bull2];
        
        fullBullet = [SKTexture textureWithImageNamed:@"fullBulletContainer"];
        emptyBullet = [SKTexture textureWithImageNamed:@"emptyBulletContainer"];
        _didFire = NO;
        ammo = 2;
        
        
#pragma mark forever
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnEnemy) onTarget:self], [SKAction waitForDuration:1.35]]]]];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnJaguar) onTarget:self], [SKAction waitForDuration:1.1]]]]];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnShrinker) onTarget:self], [SKAction waitForDuration:rand()%20+10]]]]];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(spawnPoints) onTarget:self], [SKAction waitForDuration:rand()%20+15]]]]];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(reallySendHeart) onTarget:self], [SKAction waitForDuration:7.5]]]]];
        _didSendHeart = YES;
        
    }
    
    return self;
    
}

-(void)startGame:(id)sender {
    
    self.userInteractionEnabled = YES;
    
}


-(void)spawnPoints {
    
    if (_shouldStart == YES && _stop == NO) {
        
        pointBonus = [SKSpriteNode spriteNodeWithImageNamed:@"bonusPoints"];
        [pointBonus setScale:.28];
        pointBonus.name = @"Bonus";
        pointBonus.position = CGPointMake(ScalarRandomRange(5, self.size.width-5), self.size.height+pointBonus.size.height);
        [self addChild:pointBonus];
        SKAction *move = [SKAction moveToY:-pointBonus.size.height duration:2.0];
        SKAction *remove = [SKAction removeFromParent];
        [pointBonus runAction:[SKAction sequence:@[move, remove]]];
        //NSLog(@"Spawned points");
        
    }
    
}

-(void)pickTrait:(int)image {
    
    int rand = arc4random() % 3;
    if (image == 1) {
    switch (rand) {
        case 0: {
            pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iLoveMusic"];
            pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
            pointImage.alpha = 0.65;
            [self addChild:pointImage];
            SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
            SKAction *remove = [SKAction removeFromParent];
            [pointImage runAction:[SKAction sequence:@[move, remove]]];
            break;
        }
        case 1: {
            pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iLoveTech"];
            pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
            pointImage.alpha = 0.65;
            [self addChild:pointImage];
            SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
            SKAction *remove = [SKAction removeFromParent];
            [pointImage runAction:[SKAction sequence:@[move, remove]]];
            break;
        }
        case 2: {
            pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iLoveTheatre"];
            pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
            pointImage.alpha = 0.65;
            [self addChild:pointImage];
            SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
            SKAction *remove = [SKAction removeFromParent];
            [pointImage runAction:[SKAction sequence:@[move, remove]]];
            break;
        }
        
    }
    }
    
    if (image == 2) {
        switch (rand) {
            case 0: {
                pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iPlayPiano"];
                pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
                pointImage.alpha = 0.65;
                [self addChild:pointImage];
                SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
                SKAction *remove = [SKAction removeFromParent];
                [pointImage runAction:[SKAction sequence:@[move, remove]]];
                break;
            }
            case 1: {
                pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iPlayCarillon"];
                pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
                pointImage.alpha = 0.65;
                [self addChild:pointImage];
                SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
                SKAction *remove = [SKAction removeFromParent];
                [pointImage runAction:[SKAction sequence:@[move, remove]]];
                break;
            }
            case 2: {
                pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"iPlaySaxophone"];
                pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
                pointImage.alpha = 0.65;
                [self addChild:pointImage];
                SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
                SKAction *remove = [SKAction removeFromParent];
                [pointImage runAction:[SKAction sequence:@[move, remove]]];
                break;
            }
                
        }
    }
}

-(void)returnToNormal {
    
    NSString *burstPath =
    [[NSBundle mainBundle] pathForResource:@"ShrinkParticle" ofType:@"sks"];
    
    SKEmitterNode *burstEmitter =
    [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstEmitter.zPosition = 12;
    
    burstEmitter.position = _sloth.position;
    [self addChild:burstEmitter];
    [_sloth setScale:.03];
    slothScale = 0.2;
    
}

-(void)shrink {
    
    [_sloth setScale:.012];
    slothScale = 0.3;
    
    
}

-(void)checkAmmo {
    
    if (ammo == 2) {
        bull1.texture = fullBullet;
        bull2.texture = fullBullet;
        
    }
    if (ammo == 1) {
        bull1.texture = fullBullet;
        bull2.texture = emptyBullet;
        
    }
    if (ammo == 0) {
        bull1.texture = emptyBullet;
        bull2.texture = emptyBullet;
        
    }
    
}

-(void)checkLives {
    
    if (_lives == 2) {
        heart1.texture = fullHeart;
        heart2.texture = fullHeart;
    }
    
    if (_lives == 1) {
        heart1.texture = fullHeart;
        heart2.texture = emptyHeart;
    }
    
    if (_lives == 0) {
        heart1.texture = emptyHeart;
        heart2.texture = emptyHeart;
        _gameOver = YES;
    }
    
    if (_lives >=3) {
        _lives = 2;
    }
    
}

-(void)checkForBonusCollisions {
    
    [self enumerateChildNodesWithName:@"Bonus"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *bonus = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(bonus.frame, 0, 0);
                               if (CGRectIntersectsRect(smallerFrame, _sloth.frame)) {
                                   
                                   [bonus removeFromParent];
                                   
                                   if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                       [self runAction:[SKAction playSoundFileNamed:@"point.aiff" waitForCompletion:NO]];
                                   }
                                   
                                   NSString *burstPath =
                                   [[NSBundle mainBundle] pathForResource:@"BonusParticle" ofType:@"sks"];
                                   
                                   SKEmitterNode *burstEmitter =
                                   [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                   
                                   burstEmitter.position = _sloth.position;
                                   [self addChild:burstEmitter];
                                   [self changePoints:150];
                                   
                                   pointImage = [SKSpriteNode spriteNodeWithImageNamed:@"bonusPointScreen"];
                                   pointImage.position = CGPointMake(self.size.width/2, self.size.height/2);
                                   pointImage.alpha = 0.65;
                                   [self addChild:pointImage];
                                   SKAction *move = [SKAction moveToY:self.size.height+pointImage.size.height duration:2.2];
                                   SKAction *remove = [SKAction removeFromParent];
                                   [pointImage runAction:[SKAction sequence:@[move, remove]]];
                                   
                               }
                               
                           }];
    
}


-(void)checkForShrinkCollisions {
    
    [self enumerateChildNodesWithName:@"Shrinker"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *shrink = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(shrink.frame, 0, 0);
                               if (CGRectIntersectsRect(smallerFrame, _sloth.frame)) {
                                   
                                   [shrink removeFromParent];
                                   
                                   if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                       [self runAction:[SKAction playSoundFileNamed:@"point.aiff" waitForCompletion:NO]];
                                   }
                                   
                                   
                                   NSString *burstPath =
                                   [[NSBundle mainBundle] pathForResource:@"ShrinkParticle" ofType:@"sks"];
                                   
                                   SKEmitterNode *burstEmitter =
                                   [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                   
                                   burstEmitter.position = _sloth.position;
                                   [self addChild:burstEmitter];
                                   [self changePoints:50];
                                   [self shrink];
                                   [self performSelector:@selector(returnToNormal) withObject:self afterDelay:8.5];
                                   [self pickTrait:1];
                               }
                               
                           }];
    
}

-(void)checkForBulletCollisions {
    if(shouldCheck1 == YES) {
        [self enumerateChildNodesWithName:@"enemy"
                               usingBlock:^(SKNode *node, BOOL *stop){
                                   SKSpriteNode *enemy = (SKSpriteNode *)node;
                                   CGRect smallerFrame = CGRectInset(enemy.frame, 10, 10);
                                   if (CGRectIntersectsRect(smallerFrame, bullet.frame)) {
                                       
                                       [enemy removeFromParent];
                                       _didFire = YES;
                                       [bullet setSize:CGSizeZero];
                                       bullet.position = CGPointMake(self.size.width+1000, self.size.height+1000);
                                       //[bullet removeFromParent];
                                       
                                       if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                           [self runAction:[SKAction playSoundFileNamed:@"eagle.wav" waitForCompletion:NO]];
                                       }
                                       
                                       NSString *burstPath =
                                       [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
                                       
                                       SKEmitterNode *burstEmitter =
                                       [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                       
                                       burstEmitter.position = bullet.position;
                                       [self addChild:burstEmitter];
                                       [self changePoints:100];
                                       shouldCheck1=NO;
                                   }
                               }];
    }
    
    if(shouldCheck1 == YES) {
        [self enumerateChildNodesWithName:@"Jaguar"
                               usingBlock:^(SKNode *node, BOOL *stop){
                                   SKSpriteNode *enemy = (SKSpriteNode *)node;
                                   CGRect smallerFrame = CGRectInset(enemy.frame, 10, 10);
                                   if (CGRectIntersectsRect(smallerFrame, bullet.frame)) {
                                       
                                       [enemy removeFromParent];
                                       _didFire = YES;
                                       [bullet setSize:CGSizeZero];
                                       bullet.position = CGPointMake(self.size.width+1000, self.size.height+1000);
                                       if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                           [self runAction:[SKAction playSoundFileNamed:@"jaguar.wav" waitForCompletion:NO]];
                                       }
                                       NSString *burstPath =
                                       [[NSBundle mainBundle] pathForResource:@"JaguarParticle" ofType:@"sks"];
                                       
                                       SKEmitterNode *burstEmitter =
                                       [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                       
                                       burstEmitter.position = bullet.position;
                                       [self addChild:burstEmitter];
                                       [self changePoints:100];
                                       shouldCheck1=NO;
                                   }
                               }];
        
    }
}


-(void)checkForBulletCollisions2 {
    if(shouldCheck2 == YES) {
        [self enumerateChildNodesWithName:@"enemy"
                               usingBlock:^(SKNode *node, BOOL *stop){
                                   SKSpriteNode *enemy = (SKSpriteNode *)node;
                                   CGRect smallerFrame = CGRectInset(enemy.frame, 10, 10);
                                   if (CGRectIntersectsRect(smallerFrame, bullet2.frame)) {
                                       
                                       [enemy removeFromParent];
                                       
                                       [bullet2 setSize:CGSizeZero];
                                       bullet2.position = CGPointMake(self.size.width+1000, self.size.height+1000);
                                       if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                           [self runAction:[SKAction playSoundFileNamed:@"eagle.wav" waitForCompletion:NO]];
                                       }
                                       
                                       NSString *burstPath =
                                       [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
                                       
                                       SKEmitterNode *burstEmitter =
                                       [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                       
                                       burstEmitter.position = bullet2.position;
                                       [self addChild:burstEmitter];
                                       [self changePoints:100];
                                       shouldCheck2=NO;
                                   }
                               }];
    }
    if(shouldCheck2 == YES) {
        [self enumerateChildNodesWithName:@"Jaguar"
                               usingBlock:^(SKNode *node, BOOL *stop){
                                   SKSpriteNode *enemy = (SKSpriteNode *)node;
                                   CGRect smallerFrame = CGRectInset(enemy.frame, 10, 10);
                                   if (CGRectIntersectsRect(smallerFrame, bullet2.frame)) {
                                       
                                       [enemy removeFromParent];
                                       
                                       [bullet2 setSize:CGSizeZero];
                                       bullet2.position = CGPointMake(self.size.width+1000, self.size.height+1000);
                                       
                                       if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                           [self runAction:[SKAction playSoundFileNamed:@"jaguar.wav" waitForCompletion:NO]];
                                       }
                                       
                                       NSString *burstPath =
                                       [[NSBundle mainBundle] pathForResource:@"JaguarParticle" ofType:@"sks"];
                                       
                                       SKEmitterNode *burstEmitter =
                                       [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                       
                                       burstEmitter.position = bullet2.position;
                                       [self addChild:burstEmitter];
                                       [self changePoints:100];
                                       shouldCheck2=NO;
                                   }
                               }];
        
    }
}


-(void)checkForCollisions {
    
    if (_invincible) return;
    [self enumerateChildNodesWithName:@"enemy"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *enemy = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(enemy.frame, 22, 22);
                               if (CGRectIntersectsRect(smallerFrame, _sloth.frame)) {
                                   
                                   [enemy removeFromParent];
                                   
                                   if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                       [self runAction:[SKAction playSoundFileNamed:@"eagle.wav" waitForCompletion:NO]];
                                   }
                                   
                                   NSString *burstPath =
                                   [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
                                   
                                   SKEmitterNode *burstEmitter =
                                   [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                   
                                   burstEmitter.position = _sloth.position;
                                   [self addChild:burstEmitter];
                                   
                                   [self changeInLives:-1];
                                   [self pickTrait:2];
                                   _invincible = YES;
                                   float blinkTimes = 10;
                                   float blinkDuration = 3.0;
                                   SKAction *blinkAction =
                                   [SKAction customActionWithDuration:blinkDuration
                                                          actionBlock:
                                    ^(SKNode *node, CGFloat elapsedTime) {
                                        float slice = blinkDuration / blinkTimes;
                                        float remainder = fmodf(elapsedTime, slice);
                                        node.hidden = remainder > slice / 2;
                                    }];
                                   SKAction *sequence = [SKAction sequence:@[blinkAction, [SKAction runBlock:^{
                                       _sloth.hidden = NO;
                                       _invincible = NO;
                                   }]]];
                                   [_sloth runAction:sequence];
                                   
                               }
                           }];
    
}

-(void)checkForJagCollisions {
    
    if (_invincible) return;
    [self enumerateChildNodesWithName:@"Jaguar"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *enemy = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(enemy.frame, 26, 20);
                               if (CGRectIntersectsRect(smallerFrame, _sloth.frame)) {
                                   
                                   [enemy removeFromParent];
                                   
                                   if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                       [self runAction:[SKAction playSoundFileNamed:@"jaguar.wav" waitForCompletion:NO]];
                                   }
                                   
                                   NSString *burstPath =
                                   [[NSBundle mainBundle] pathForResource:@"JaguarParticle" ofType:@"sks"];
                                   
                                   SKEmitterNode *burstEmitter =
                                   [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                   
                                   burstEmitter.position = _sloth.position;
                                   [self addChild:burstEmitter];
                                   
                                   [self changeInLives:-1];
                                   [self pickTrait:1];
                                   _invincible = YES;
                                   float blinkTimes = 10;
                                   float blinkDuration = 3.0;
                                   SKAction *blinkAction =
                                   [SKAction customActionWithDuration:blinkDuration
                                                          actionBlock:
                                    ^(SKNode *node, CGFloat elapsedTime) {
                                        float slice = blinkDuration / blinkTimes;
                                        float remainder = fmodf(elapsedTime, slice);
                                        node.hidden = remainder > slice / 2;
                                    }];
                                   SKAction *sequence = [SKAction sequence:@[blinkAction, [SKAction runBlock:^{
                                       _sloth.hidden = NO;
                                       _invincible = NO;
                                   }]]];
                                   [_sloth runAction:sequence];
                                   
                               }
                           }];
    
}

-(void)checkForHeartCollisions {
    [self enumerateChildNodesWithName:@"heart"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *heart = (SKSpriteNode *)node;
                               CGRect smallerFrame = CGRectInset(heart.frame, 0, 0);
                               if (CGRectIntersectsRect(smallerFrame, _sloth.frame)) {
                                   
                                   [heart removeFromParent];
                                   [self changeInLives:1];
                                   
                                   if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
                                       [self runAction:[SKAction playSoundFileNamed:@"point.aiff" waitForCompletion:NO]];
                                   }
                                   
                                   NSString *burstPath =
                                   [[NSBundle mainBundle] pathForResource:@"HeartParticle" ofType:@"sks"];
                                   
                                   SKEmitterNode *burstEmitter =
                                   [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                                   
                                   burstEmitter.position = _sloth.position;
                                   [self addChild:burstEmitter];
                                   [self changePoints:30];
                                   [self pickTrait:2];
                                   
                               }
                               if (livePlus.position.y <= 0-livePlus.size.height) {
                                   
                                   
                               }
                           }];
    
}

-(void)reallySendHeart {
    
    if (_shouldStart == YES && _stop == NO) {
        livePlus = [SKSpriteNode spriteNodeWithImageNamed:@"heartContainer"];
        [livePlus setScale:.3];
        livePlus.zPosition = 11;
        livePlus.name = @"heart";
        livePlus.zPosition = 11;
        livePlus.position = CGPointMake(ScalarRandomRange(5, self.size.width-5), self.size.height+livePlus.size.height/2);
        [self addChild:livePlus];
        SKAction *move = [SKAction moveToY:0-livePlus.size.height duration:2.0];
        SKAction *remove = [SKAction removeFromParent];
        [livePlus runAction:[SKAction sequence:@[move, remove]]];
    }
    
}

-(void)changeInLives:(int)change {
    
    _lives += change;
    //  NSLog(@"Number of lives left: %i", _lives);
    
}

-(void)spawnEnemy {
    
    if (_shouldStart == YES && _stop == NO) {
        
        _enemy = [SKSpriteNode spriteNodeWithImageNamed:@"harpyeagle1"];
        /*enemy.position = CGPointMake(ScalarRandomRange(enemy.size.width/2, self.size.width-enemy.size.width/2), self.size.height+enemy.size.height/2);*/
        _enemy.position = CGPointMake(ScalarRandomRange(5, self.size.width-5), self.size.height+_enemy.size.height/2);
        [_enemy setScale:0.7];
        _enemy.name = @"enemy";
        _enemy.zPosition = 15;
        [self addChild:_enemy];
        
        SKAction *actionMove = [SKAction moveToY:-_enemy.size.height/2 duration:2.2];
        SKAction *actionRemove = [SKAction removeFromParent];
        [self startEagleAnimation];
        [_enemy runAction:[SKAction sequence:@[actionMove, actionRemove]]];
        [self changePoints:10];
    }
}

-(void)spawnJaguar {
    
    if (_shouldStart == YES && _stop == NO) {
        
        _jaguar = [SKSpriteNode spriteNodeWithImageNamed:@"jaguar1"];
        _jaguar.position = CGPointMake(ScalarRandomRange(5, self.size.width-5), self.size.height+_enemy.size.height/2);
        [_jaguar setScale:0.111];
        _jaguar.name = @"Jaguar";
        _jaguar.zPosition = 14;
        [self addChild:_jaguar];
        
        SKAction *actionMove = [SKAction moveToY:-_jaguar.size.height/2 duration:1.675];
        SKAction *actionRemove = [SKAction removeFromParent];
        [self startJaguarAnimation];
        [_jaguar runAction:[SKAction sequence:@[actionMove, actionRemove]]];
        [self changePoints:10];
    }
}

-(void)spawnShrinker {
    
    if (_shouldStart == YES && _stop == NO) {
        
        shrinker = [SKSpriteNode spriteNodeWithImageNamed:@"shrinker"];
        [shrinker setScale:.28];
        shrinker.name = @"Shrinker";
        shrinker.position = CGPointMake(ScalarRandomRange(5, self.size.width-5), self.size.height+shrinker.size.height);
        [self addChild:shrinker];
        SKAction *move = [SKAction moveToY:-shrinker.size.height duration:2.3];
        SKAction *remove = [SKAction removeFromParent];
        [shrinker runAction:[SKAction sequence:@[move, remove]]];
        // NSLog(@"Spawned shrinker");
        
    }
    
}

-(void)playBackgroundMusic:(NSString *)filename {
    
    NSError *error;
    NSURL *backgroundMusURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusURL error:&error];
    _backgroundMusic.numberOfLoops = -1;
    [_backgroundMusic prepareToPlay];
    [_backgroundMusic play];
    
    
}

-(void)moveBg {
    if (_shouldStart == YES) {
        [self enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop) {
            
            SKSpriteNode *bg = (SKSpriteNode *) node;
            CGPoint bgVelocity = CGPointMake(0, -BG_MOVE_SEC);
            CGPoint amtToMove = CGPointScalar(bgVelocity, _dt);
            bg.position = CGPointAdd(bg.position, amtToMove);
            if (bg.position.y <= -bg.size.height) {
                bg.position = CGPointMake(bg.position.x, bg.position.y + bg.size.height*2);
            }
        }];
    }
}

#pragma mark - UPDATE

-(void)update:(NSTimeInterval)currentTime {
    if (_stop) {
        return;
    }
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    //if (_stop == YES) {
    CGPoint offset = CGPointSubtract(_lastTouchLocation, _sloth.position);
    float distance = CGPointLength(offset);
    if (distance < SLOTH_MOVE_SEC * _dt) {
        //_sloth.position = _lastTouchLocation;
        _velocity = CGPointZero;
        [self stopSlothAnimation];
    } else {
        // [self moveSprite:_sloth velocity:_velocity];
        [self boundsCheckPlayer];
        // [self rotateSprite:_sloth toFace:_velocity rotateRadiansPerSec:SLOTH_ROTATE_RADIANS_SEC];
    }
    if (_shouldStart == YES) {
        [self hide];
    }
    [self moveBg];
    [self checkForHeartCollisions];
    [self checkForShrinkCollisions];
    [self checkForBonusCollisions];
    if (_gameOver == YES) {
        [self gameOver];
    }
    if (_sloth.position.x <= 20) {
        
        SKAction *move = [SKAction moveToX:21 duration:0.50];
        [_sloth runAction:move];
        
    }
    else if (_sloth.position.x >= 300) {
        
        SKAction *move = [SKAction moveToX:299 duration:0.50];
        [_sloth runAction:move];
        
    }
    [self checkForCollisions];
    [self checkForJagCollisions];
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"rb%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    for (int i=3; i>1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"rb%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    _slothAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    NSMutableArray *textures2 = [NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<6; i++) {
        NSString *textureName = [NSString stringWithFormat:@"harpyeagle%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures2 addObject:texture];
    }
    for (int i=6; i>1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"harpyeagle%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures2 addObject:texture];
    }
    _eagleAnimation = [SKAction animateWithTextures:textures2 timePerFrame:0.12];
    
    NSMutableArray *textures3 = [NSMutableArray arrayWithCapacity:10];
    for (int i=1; i<6; i++) {
        NSString *textureName = [NSString stringWithFormat:@"jaguar%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures2 addObject:texture];
    }
    for (int i=6; i>1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"jaguar%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures3 addObject:texture];
    }
    _jaguarAnimation = [SKAction animateWithTextures:textures3 timePerFrame:0.08];
    
    if (_welcome.alpha == 0 && _welcomeExists == YES) {
        [_welcome removeFromParent];
        _welcomeExists = NO;
    }
    labelNode.text = [NSString stringWithFormat:@"%li", _points];
    [self checkLives];
    [self checkAmmo];
    
    [self checkForBulletCollisions];
    
    [self checkForBulletCollisions2];
    
    [self checkScore];
    
    /*if (bullet2.position.y >= self.size.height) {
     [bullet2 removeFromParent];
     //[smoke removeFromParent];
     }
     if (bullet.position.y >= self.size.height) {
     [bullet removeFromParent];
     //[smoke removeFromParent];
     }*/
    //}
}

-(void)restart:(id)sender {
    
    //[self hide];
    _gameOver = NO;
    _stop = NO;
    _shouldStart = NO;
    _points = 0;
    ammo = 2;
    shouldCheck1 = NO;
    shouldCheck2 = NO;
    _didFire = NO;
    _welcome.alpha = 1;
    [self changeInLives:2];
    story1 = NO;
    story2 = NO;
    story3 = NO;
    story4 = NO;
    story5 = NO;
    story6 = NO;
    
}

-(void)checkScore {
    
    if (_points >= 150 && story1 == NO) {
        story1 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story1" object:nil];
        
    }
    if (_points >= 500 && story2 == NO) {
        story2 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story2" object:nil];
        
    }
    if (_points >= 850 && story3 == NO) {
        story3 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story3" object:nil];
        
    }
    if (_points >= 1200 && story4 == NO) {
        story4 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story4" object:nil];
        
    }
    if (_points >= 1550 && story5 == NO) {
        story5 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story5" object:nil];
        
    }
    if (_points >= 1900 && story6 == NO) {
        story6 = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"story6" object:nil];
    }
    
}

-(void)hide {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    
}

-(void)show {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
}

-(void)gameOver {
    
    _stop = YES;
    self.userInteractionEnabled = NO;
    NSLog(@"Sent game over");
    [self stopSlothAnimation];
    _sloth.texture = [SKTexture textureWithImageNamed:@"rb2"];
    if (slothScale == .2) {
        [self returnToNormal];
    }
    NSString *burstPath =
    [[NSBundle mainBundle] pathForResource:@"GodParticle" ofType:@"sks"];
    
    SKEmitterNode *burstEmitter =
    [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    
    // burstEmitter.position = CGPointMake(self.size.width/2, self.size.height/2);
    burstEmitter.position = _sloth.position;
    [self addChild:burstEmitter];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gameOver" object:nil];
    [self show];
    
    
}


-(void)startSlothAnimation {
    
    if (![_sloth actionForKey:@"animation"]) {
        [_sloth runAction:[SKAction repeatActionForever:_slothAnimation] withKey:@"animation"];
        
    }
    
}

-(void)stopSlothAnimation {
    
    [_sloth removeActionForKey:@"animation"];
    
}

-(void)startEagleAnimation {
    
    if (![_enemy actionForKey:@"animation"]) {
        [_enemy runAction:[SKAction repeatActionForever:_eagleAnimation] withKey:@"animation"];
    }
    
}

-(void)startJaguarAnimation {
    
    if (![_jaguar actionForKey:@"animation"]) {
        [_jaguar runAction:[SKAction repeatActionForever:_jaguarAnimation] withKey:@"animation"];
    }
    
}


-(void)moveSprite:(SKSpriteNode *)sprite
         velocity:(CGPoint)velocity {
    
    CGPoint amountToMove = CGPointScalar(velocity, _dt);
    // NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    sprite.position = CGPointAdd(amountToMove, sprite.position);
    
}

-(void)moveSlothToward:(CGPoint)location {
    
    CGPoint offset = CGPointSubtract(location, _sloth.position);
    CGPoint direction = CGPointNormalize(offset);
    _velocity = CGPointScalar(direction, SLOTH_MOVE_SEC);
    
}

-(void)boundsCheckPlayer {
    
    CGPoint newPosition = _sloth.position;
    CGPoint newVelocity = _velocity;
    
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(self.size.width, self.size.height);
    
    if (newPosition.x<=bottomLeft.x) {
        newPosition.x = bottomLeft.x;
        newVelocity.x = -newVelocity.x;
    }
    if (newPosition.x>=topRight.x) {
        newPosition.x = topRight.x;
        newVelocity.x = -newVelocity.x;
    }
    if (newPosition.y<=bottomLeft.y) {
        newPosition.y = bottomLeft.y;
        newVelocity.y = -newVelocity.y;
    }
    if (newPosition.y>=topRight.y) {
        newPosition.y = topRight.y;
        newVelocity.y = -newVelocity.y;
    }
    
    
    _sloth.position = newPosition;
    _velocity = newVelocity;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    CGPoint lastPosition = [touch previousLocationInNode:self];
    CGPoint translation = CGPointMake(scenePosition.x - lastPosition.x, lastPosition.y - lastPosition.y);
    if (_sloth.position.x > 20 && _sloth.position.x < 300) {
        SKAction *move = [SKAction moveToX:_sloth.position.x + translation.x duration:slothScale];
        [_sloth runAction:move];
        if (_shouldStart == NO) {
            _shouldStart = YES;
            [self startSlothAnimation];
            SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1];
            [_welcome runAction:disappear];
        }
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"fireButtonNode"]) {
        if (ammo==2 && _didFire == NO) {
            [self fireBullet];
        }
        if (ammo==1 && _didFire == YES) {
            [self fireBullet2];
        }
    }
}
-(void)check1 {
    shouldCheck1 = NO;
    _didFire = YES;
}
-(void)check2 {
    shouldCheck2 = NO;
}
-(void)fireBullet {
    
    bullet.position = CGPointMake(_sloth.position.x, _sloth.position.y+10);
    bullet.zPosition = 14;
    [self addChild:bullet];
    shouldCheck1 = YES;
    SKAction *moveB = [SKAction moveToY:self.size.height+1000 duration:.9];
    SKAction *remove = [SKAction removeFromParent];
    NSString *burstPath =
    [[NSBundle mainBundle] pathForResource:@"RocketParticle" ofType:@"sks"];
    smoke =
    [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    [smoke setTargetNode:bullet];
    smoke.position = smoke.targetNode.position;
    [self addChild:smoke];
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
        [self runAction:[SKAction playSoundFileNamed:@"laser.wav" waitForCompletion:NO]];
    }
    
    [bullet runAction:[SKAction sequence:@[moveB, remove]] completion:^ {
        [self check1];
    }];
    ammo--;
    
    
    
    
}

-(void)fireBullet2 {
    
    bullet2.position = CGPointMake(_sloth.position.x, _sloth.position.y+10);
    bullet2.zPosition = 14;
    [self addChild:bullet2];
    
    SKAction *moveB = [SKAction moveToY:self.size.height+1000 duration:.9];
    SKAction *remove = [SKAction removeFromParent];
    NSString *burstPath =
    [[NSBundle mainBundle] pathForResource:@"RocketParticle" ofType:@"sks"];
    smoke2 =
    [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    [smoke2 setTargetNode:bullet2];
    smoke2.position = smoke2.targetNode.position;
    [self addChild:smoke2];
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] == NO) {
        [self runAction:[SKAction playSoundFileNamed:@"laser.wav" waitForCompletion:NO]];
    }
    
    [bullet2 runAction:[SKAction sequence:@[moveB, remove]] completion:^ {
        [self check2];
    }];
    ammo--;
    shouldCheck2=YES;
}

-(void)changePoints:(int)change {
    
    _points += change;
    
}

@end