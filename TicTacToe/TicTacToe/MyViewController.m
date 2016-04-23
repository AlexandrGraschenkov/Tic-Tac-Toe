//
//  ViewController.m
//  TicTacToe
//
//  Created by Мария Тимофеева on 06.04.16.
//  Copyright © 2016 ___matim___. All rights reserved.
//

#import "MyViewController.h"
#import "MyButton.h"

@interface MyViewController ()
@property  NSMutableArray *buttons;
@property int activeButtonsCount;
@property NSArray *arr;
@property int i;
@property NSString *alertTitle;
@property int xPoint;
@property int oPoint;
@property UILabel *score;
@end

@implementation MyViewController
- (IBAction)restart:(id)sender {
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:self.alertTitle message:@"Restart game?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartGame];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.oPoint = 0;
    self.xPoint = 0;
    self.score = [UILabel new];
    [self.score setFrame:CGRectMake(60, 500, 200, 200)];
    [self.score setNumberOfLines:2];
    [self restartGame];
}

-(BOOL)gameWasOverWithButtonNumber:(int)number{
    NSString *player;
    
    if([self checkMoveWithLAstButtonNumber:number]) {
       
        if (self.i==0){
            self.oPoint++;
            player=@"0";
        }
        else{
            self.xPoint++;
            player = @"X";
        }self.alertTitle =[NSString stringWithFormat:@"Player %@ win!", player];
    }
    else if([self allButtonsWereClick]) self.alertTitle = @"Game over";
    
    if(self.alertTitle){
        UIAlertController *alert =  [UIAlertController alertControllerWithTitle:self.alertTitle message:@"Restart game?" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self stopGame];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self restartGame];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return YES;
    
        
    }
    
    return NO;
    
}

-(void)restartGame{
    
    self.score.text = [NSString stringWithFormat:@"Player X - %d point \n Player 0 - %d point", self.xPoint, self.oPoint];
    [self.view addSubview:self.score];
    
    int x = 0;
    int y = 0;
    self.alertTitle  = nil;
    self.buttons = [NSMutableArray new];
    self.title = @"Turn X";
    self.i = 0;
    self.activeButtonsCount = 0;
    self.arr =   @[
                   @[@0, @1, @0, @0, @0],
                   @[@0, @1, @1, @1 ,@1],
                   @[@0, @1, @1, @1 ,@0],
                   @[@1, @1, @1, @1 ,@0],
                   @[@0, @0, @0, @1, @0]
                   ];
    // TODO: Х больше походит на У.. может нам тут не хватает искажения на пространство?

    for (int i  = 0 ; i < 5 ; i++){
        
        for (int j = 0; j < 5 ; j++){
            
            if ([self.arr[i][j]  isEqual: @1]) {
                MyButton *button = [MyButton new];
                [button setFrame: CGRectMake(i* 60 + x + 10, j * 60 + y + 100, 60, 60) ];
                [button  addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundColor:[UIColor blackColor]];
                [button setNumber:j*10+i];
                [self.view addSubview:button];
                [self.buttons addObject:button];
                self.activeButtonsCount++;
                
            }
            else {
                MyButton *button = [MyButton new];
                [button setActive:NO];
                [self.buttons addObject:button];
                
            }
            y+=5;
            
            
        }
        x+=5;
        y = 0;
        
    }

    NSLog(@"restart");
}

-(void)stopGame{
    for(MyButton *but in self.buttons){
        but.enabled = NO;
    }
    
    
}

-(BOOL)allButtonsWereClick{
    int k = 0;
    for (MyButton *button in self.buttons){
        if(button.wasClick)k++;
    }
    if (k==self.activeButtonsCount) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSameButtons:(NSArray *)butts {
    NSString *prevVal = [[butts firstObject] colour];
    for (MyButton *butt in butts) {
        if (![prevVal isEqual:butt.colour])
            return false;
        prevVal = butt.colour;
    }
    return prevVal != nil;
}

-(BOOL)checkMoveWithLAstButtonNumber:(int )number{
    int x = number/10;
    int y = number%10;
    
    // а что, если мы поменяем правила игры и теперь нужно будет 4 в ряд?)
    // слава богу такого не намечается..
    
   
    int startX = MAX(1, x-1);
    int startY = MAX(1, y-1);
    int endX = MIN(x+1, (int)self.arr.count-2);
    int endY = MIN(y+1, (int)self.arr.count-2);
    NSArray *buttArr;
    for (int xx = startX; xx <= endX; xx++) {
        for (int yy = startY; yy <= endY; yy++) {
            // нам нужно проверить 4 условия: по Х, У и по 2 диагоналям
            MyButton *first = self.buttons[(yy-1) * 5 + xx - 1];
            MyButton *second = self.buttons[(yy) * 5 + xx];
            MyButton *third = self.buttons[(yy+1) * 5 + xx + 1];
            
            if ([self isSameButtons:@[first, second, third]]) {
                buttArr = @[first, second, third];
                break;
            }
            
            first = self.buttons[(yy+1) * 5 + xx - 1];
            second = self.buttons[(yy) * 5 + xx];
            third = self.buttons[(yy-1) * 5 + xx + 1];
            
            if ([self isSameButtons:@[first, second, third]]) {
                buttArr = @[first, second, third];
                break;
            }
            
            first = self.buttons[(yy) * 5 + xx - 1];
            second = self.buttons[(yy) * 5 + xx];
            third = self.buttons[(yy) * 5 + xx + 1];
            
            if ([self isSameButtons:@[first, second, third]]) {
                buttArr = @[first, second, third];
                break;
            }
            
            first = self.buttons[(yy+1) * 5 + xx];
            second = self.buttons[(yy) * 5 + xx];
            third = self.buttons[(yy-1) * 5 + xx];
            
            if ([self isSameButtons:@[first, second, third]]) {
                buttArr = @[first, second, third];
                break;
            }
        }
        if (buttArr)
            break;
    }
    
    for (UIButton *butt in buttArr) {
        butt.backgroundColor = [UIColor redColor];
    }
    return buttArr != nil;
    
}


-(void)buttonDidClick:(MyButton *)button{
    if (button.wasClick)
        return; // магия сокращения вложенности
    
    if (self.i==0) {
        [button setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
        self.i = 1;
        [button setColour:@"X"];
        
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"o.png"] forState:UIControlStateNormal];
        self.i = 0;
        [button setColour:@"0"];
    }
    
    [self changeTurn];
    button.wasClick= YES;
    if ([self gameWasOverWithButtonNumber:button.number]) {
        NSLog(@"Game over");
    }
}

-(void)changeTurn{
    if ([self.title isEqualToString:@"Turn X"]) {
                self.title = @"Turn 0";
    }
    else{
        
        self.title = @"Turn X";
           }
}




@end
