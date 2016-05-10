//
//  GameViewController.m
//  Randall Beck
//
//  Created by Randall Beck on 4/17/15.
//  Copyright (c) 2015 Ch1pa Software. All rights reserved.
//

#import "GameViewController.h"
#import "Score.h"
#import "Randall_Beck-Swift.h"

@implementation GameViewController {
    
    Score *scoreController;
    GameScene *_myScene;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scoreController = [[Score alloc] init];
    
    
    _skView = (SKView *)self.view;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eventWasted:) name:@"gameOver" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story1:) name:@"story1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story2:) name:@"story2" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story3:) name:@"story3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story4:) name:@"story4" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story5:) name:@"story5" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(story6:) name:@"story6" object:nil];
    
    _myScene = [GameScene sceneWithSize:_skView.bounds.size];
    _myScene.scaleMode = SKSceneScaleModeAspectFill;
    _myScene.userInteractionEnabled = NO;
    
    [_skView presentScene:_myScene];
    
    back.alpha = 0;
    if (self.view.bounds.size.height == 480) {
        [_gameOver setBounds:CGRectMake(0, -20, _gameOver.bounds.size.width, _gameOver.bounds.size.height)];
    }
    
    _mainMenu.alpha = 1;

    
}

-(IBAction)play:(id)sender {
    _myScene.welcome.alpha = 1;
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _flash.alpha = 0;
        _gameOver.alpha = 0;
        
        _mainMenu.alpha = 0;
        
        [_myScene performSelector:@selector(startGame:) withObject:_skView];
        
    } completion:^(BOOL finished) {
        _flash.userInteractionEnabled = NO;
        _gameOver.userInteractionEnabled = NO;
        _mainMenu.userInteractionEnabled = NO;
    }];
    
}

-(IBAction)Gplay:(id)sender {
    
    _myScene.welcome.alpha = 1;
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _flash.alpha = 0;
        _gameOver.alpha = 0;
        
        
        [_myScene performSelector:@selector(startGame:) withObject:_skView afterDelay:0];
        
    } completion:^(BOOL finished) {
        
        _flash.userInteractionEnabled = NO;
        _gameOver.userInteractionEnabled = NO;
        _mainMenu.userInteractionEnabled = NO;
        [_myScene performSelector:@selector(restart:) withObject:_skView afterDelay:0];
        
    }];
    
}

-(IBAction)back {
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _creds.alpha = 0;
        back.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
    
        
}


-(IBAction)credits:(id)sender {
    
    [_myScene.view bringSubviewToFront:_creds];
    [_myScene.view bringSubviewToFront:back];
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        back.alpha = 1;
        _creds.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}

-(IBAction)Gcredits:(id)sender {
    
    [_myScene.view bringSubviewToFront:_creds];
    [_myScene.view bringSubviewToFront:back];
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        back.alpha = 1;
        _creds.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
    
}

-(void)story1:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringA;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}
-(void)story2:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringB;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}
-(void)story3:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringC;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}
-(void)story4:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringD;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}
-(void)story5:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringE;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}
-(void)story6:(id)sender {
    
    [_myScene.view bringSubviewToFront:_storyView];
    _storyView.hidden = NO;
    _storyLabel.attributedText = Story.myStringF;
    [_myScene.view insertSubview:self.storyView aboveSubview:_myScene.scene.view];
    _myScene.paused = YES;
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _storyView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}

-(void)eventWasted:(id)sender
{
    
    self.flash = [[UIView alloc] init];
    self.flash.frame=self.view.frame;
    self.flash.backgroundColor = [UIColor whiteColor];
    self.flash.alpha = .9;
    
    [_myScene.view insertSubview:self.gameOver aboveSubview:_myScene.scene.view];
    [_myScene.view insertSubview:_flash belowSubview:self.gameOver];
    
    [self shakeFrame];
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.gameOver.userInteractionEnabled = YES;
        self.flash.alpha = .4;
        self.gameOver.alpha = 1;
        
        _score.text = [NSString stringWithFormat:@"%li",(long)_myScene.points];
        [Score registerScore:_myScene.points];
        _bestScore.text = [NSString stringWithFormat:@"%li",(long)[Score bestScore]];
        
    } completion:^(BOOL finished) {
        _flash.userInteractionEnabled = NO;
        NSLog(@"Received event");
    }];
    
}

-(void)shakeFrame {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([_skView center].x - 4.0f, [_skView  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([_skView center].x + 4.0f, [_skView  center].y)]];
    [[_skView layer] addAnimation:animation forKey:@"position"];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(IBAction)removeScene {
    
    if (_storyView.alpha == 1.0) {
        _myScene.paused = NO;
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _storyView.alpha = 0;
            _storyView.hidden = YES;
            
        } completion:^(BOOL finished) {
           
        }];
    }
    
}


- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
    
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
