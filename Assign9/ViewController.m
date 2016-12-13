//
//  ViewController.m
//  Assign9
//
//  Created by Suzanna Schlottach-Ratcliff on 11/28/16.
//  Copyright © 2016 Suzanna Schlottach-Ratcliff. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"

@interface ViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) BallView * ball;
@property (nonatomic, strong) BallView *pongBallPaddle;
@property (nonatomic) CGPoint pongPaddleCenterPoint;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) UIView *floorView;
@property int score;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gameSetUp];
    [self startPong];
  }

-(void) setUpFloorView {
    float floorHeight = 28.0;
    CGSize viewSize = self.view.bounds.size;
    self.floorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewSize.height - floorHeight, viewSize.width, floorHeight)];
    [self setDefaultFloorColor];
    self.floorView.layer.cornerRadius = 5;
    [self.view addSubview:self.floorView];
}

-(void) setUpBallViewWithSize: (float) size {
    self.ball = [[BallView alloc] initWithFrame:CGRectMake(100.0, 100.0, size, size)];
    UIColor * suzysPinkColor = [UIColor colorWithRed:255.0f/255.0f green:182.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
    self.ball.backgroundColor = suzysPinkColor;
    self.ball.layer.cornerRadius = size / 2;
    self.ball.clipsToBounds = YES;
    
    [self.view addSubview:self.ball];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    gravityBehavior.magnitude = 1.5;
    [self.animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
    ballBehavior.elasticity = 1.0;
    ballBehavior.resistance = 0;
    ballBehavior.friction = 0;
    [self.animator addBehavior:ballBehavior];
}

-(void) setUpPongBallPaddleWithSize: (float) size {
    CGSize viewSize = self.view.frame.size;
    self.pongBallPaddle = [[BallView alloc] initWithFrame:CGRectMake(viewSize.width / 2 - size,
                                                                     viewSize.height - size - self.floorView.bounds.size.height ,
                                                                     size,
                                                                     size)];
    self.pongBallPaddle.backgroundColor = [UIColor colorWithRed:193.0f/255.0f green:255.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
    self.pongBallPaddle.layer.cornerRadius = size / 2;
    self.pongBallPaddle.clipsToBounds = YES;
    self.pongPaddleCenterPoint = self.pongBallPaddle.center;
    
    [self.view addSubview:self.pongBallPaddle];
    
    UIDynamicItemBehavior *paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.pongBallPaddle]];
    paddleBehavior.allowsRotation = NO;
    paddleBehavior.density = 100000.0;
    [self.animator addBehavior:paddleBehavior];
}

-(void) gameSetUp {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self setUpFloorView];
    [self setUpBallViewWithSize:50.0f];
    [self setUpPongBallPaddleWithSize:75.0];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.pongBallPaddle, self.floorView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    CGFloat yPoint = self.pongPaddleCenterPoint.y;
    CGPoint paddleCenter = CGPointMake(touchLocation.x, yPoint);
    
    self.pongBallPaddle.center = paddleCenter;
    [self.animator updateItemUsingCurrentState:self.pongBallPaddle];
}

-(void) startPong {
    self.score = 0;
    [self updatePointLabel];
}

-(void) scorePoint {
    self.score++;
    [self updatePointLabel];
}

-(void) updatePointLabel {
    [self.scoreLabel setText: [NSString stringWithFormat:@"Score : %d", self.score]];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item1 withItem:(id)item2 atPoint:(CGPoint)p{
    UIColor * suzysBlueColor = [UIColor colorWithRed:182.0f/255.0f green:255.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    self.ball.backgroundColor = suzysBlueColor;
    if (item1 == self.ball && item2 == self.pongBallPaddle) {
        [self scorePoint];
    } else if (item2 == self.ball && item1 == self.floorView) {
        UIColor * suzysPurpleColor = [UIColor colorWithRed:182.0f/255.0f green:193.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        self.floorView.backgroundColor = suzysPurpleColor;
        [self performSelector: @selector(setDefaultFloorColor) withObject:self afterDelay:(.25)];
        [self startPong];
    }
}

-(void) setDefaultFloorColor {
    UIColor * suzysBrownColor = [UIColor colorWithRed:221.0f/255.0f green:191.0f/255.0f blue:120.0f/255.0f alpha:1.0f];
    self.floorView.backgroundColor = suzysBrownColor;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier{
    UIColor * suzysPinkColor = [UIColor colorWithRed:255.0f/255.0f green:182.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
    self.ball.backgroundColor = suzysPinkColor;
}

@end
