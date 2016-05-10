//
//  GameViewController.h
//  Randall Beck
//

//  Copyright (c) 2015 Ch1pa Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@class Story;
@interface GameViewController : UIViewController {
    
    IBOutlet UIButton *back;
    
}

@property (nonatomic, retain)IBOutlet UIImageView *imageView;
@property (nonatomic, retain)IBOutlet SKView *mainMenu;
@property (nonatomic, retain)IBOutlet SKView *gameOver;
@property (nonatomic, retain)IBOutlet SKView *storyView;
@property (nonatomic, retain)IBOutlet UIButton *play;
@property (nonatomic, retain)IBOutlet UIButton *credits;
@property (nonatomic, retain)IBOutlet UILabel *score;
@property (nonatomic, retain)IBOutlet UILabel *bestScore;
@property (nonatomic, retain)IBOutlet UIButton *Gplay;
@property (nonatomic, retain)IBOutlet UIButton *Gcredits;
@property (nonatomic, retain)UIView *flash;
@property (nonatomic, retain)IBOutlet SKView *skView;
@property (nonatomic, retain)IBOutlet UIImageView *creds;
@property (nonatomic, retain)IBOutlet UILabel *storyLabel;

-(IBAction)play:(id)sender;
-(IBAction)credits:(id)sender;
-(IBAction)back;
-(IBAction)Gplay:(id)sender;
-(IBAction)Gcredits:(id)sender;
-(IBAction)removeScene;

-(void)eventWasted:(id)sender;
-(void)story1:(id)sender;
-(void)story2:(id)sender;
-(void)story3:(id)sender;
-(void)story4:(id)sender;
-(void)story5:(id)sender;
-(void)story6:(id)sender;


@end