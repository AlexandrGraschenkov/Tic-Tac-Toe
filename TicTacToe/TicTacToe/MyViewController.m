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


-(BOOL)checkMoveWithLAstButtonNumber:(int )number{
    int x = number/10;
    int y = number%10;
    
    
    
    //слева направо
    
    if (x>=2 && y >=2 &&
            [self.arr[y-2][x-2] isEqual:@1 ] &&
            [self.arr[y-1][x-1] isEqual:@1 ] &&
            [self.arr[y][x] isEqual:@1 ]){
            MyButton *first = self.buttons[(y-2)*5+x-2];
            MyButton *second = self.buttons[(y-1)*5+x-1];
            MyButton *third = self.buttons[y*5+x];
    
                if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
                    [first setBackgroundColor:[UIColor redColor]];
                    [second setBackgroundColor:[UIColor redColor]];
                    [third setBackgroundColor:[UIColor redColor]];
                    return YES;
                }
    }
    
    if (x>=1 && y >=1 && x<=3 && y<=3 &&
        [self.arr[y-1][x-1] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x+1] isEqual:@1 ]){
        MyButton *first = self.buttons[(y-1)*5+x-1];
        MyButton *second = self.buttons[y*5+x];
        MyButton *third = self.buttons[(y+1)*5+x+1];
        
            if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
                [first setBackgroundColor:[UIColor redColor]];
                [second setBackgroundColor:[UIColor redColor]];
                [third setBackgroundColor:[UIColor redColor]];
                return YES;
            
        }
        
    }
    
    if (x<=2 && y <=2 &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x+1] isEqual:@1 ] &&
        [self.arr[y+2][x+2] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x];
        MyButton *second = self.buttons[(y+1)*5+x+1];
        MyButton *third = self.buttons[(y+2)*5+x+2];
            if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
                [first setBackgroundColor:[UIColor redColor]];
                [second setBackgroundColor:[UIColor redColor]];
                [third setBackgroundColor:[UIColor redColor]];
                return YES;
            }
        
        
    }
    
    //справа налево
    
    if (x<=2 && y >=2 &&
        [self.arr[y-2][x+2] isEqual:@1 ] &&
        [self.arr[y-1][x+1] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ]){
        MyButton *first = self.buttons[(y-2)*5+x+2];
        MyButton *second = self.buttons[(y-1)*5+x+1];
        MyButton *third = self.buttons[y*5+x];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
    }
    
    if (x>=1 && y >=1 && x<=3 && y<=3 &&
        [self.arr[y-1][x+1] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x-1] isEqual:@1 ]){
        MyButton *first = self.buttons[(y-1)*5+x+1];
        MyButton *second = self.buttons[y*5+x];
        MyButton *third = self.buttons[(y+1)*5+x-1];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
            
        }
        
    }
    
    if (x>=2 && y <=2 &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x-1] isEqual:@1 ] &&
        [self.arr[y+2][x-2] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x];
        MyButton *second = self.buttons[(y+1)*5+x-1];
        MyButton *third = self.buttons[(y+2)*5+x-2];
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
        
        
    }
    
    //горизонталь
    if (y >=2 &&
        [self.arr[y-2][x] isEqual:@1 ] &&
        [self.arr[y-1][x] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ]){
        MyButton *first = self.buttons[(y-2)*5+x];
        MyButton *second = self.buttons[(y-1)*5+x];
        MyButton *third = self.buttons[y*5+x];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
    }
    
    if (y >=1 && y<=3 &&
        [self.arr[y-1][x] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x] isEqual:@1 ]){
        MyButton *first = self.buttons[(y-1)*5+x];
        MyButton *second = self.buttons[y*5+x];
        MyButton *third = self.buttons[(y+1)*5+x];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
            
        }
        
    }
    
    if (y <=2 &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y+1][x] isEqual:@1 ] &&
        [self.arr[y+2][x] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x];
        MyButton *second = self.buttons[(y+1)*5+x];
        MyButton *third = self.buttons[(y+2)*5+x];
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
        
        
    }
    
    //вертикаль
    
    if (x>=2&&
        [self.arr[y][x-2] isEqual:@1 ] &&
        [self.arr[y][x-1] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x-2];
        MyButton *second = self.buttons[y*5+x-1];
        MyButton *third = self.buttons[y*5+x];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
    }
    
    if (x>=1 && x<=3  &&
        [self.arr[y][x-1] isEqual:@1 ] &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y][x+1] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x-1];
        MyButton *second = self.buttons[y*5+x];
        MyButton *third = self.buttons[y*5+x+1];
        
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
            
        }
        
    }
    
    if (x<=2 && y <=2 &&
        [self.arr[y][x] isEqual:@1 ] &&
        [self.arr[y][x+1] isEqual:@1 ] &&
        [self.arr[y][x+2] isEqual:@1 ]){
        MyButton *first = self.buttons[y*5+x];
        MyButton *second = self.buttons[y*5+x+1];
        MyButton *third = self.buttons[y*5+x+2];
        if ([first.colour isEqualToString: second.colour ] && [second.colour isEqualToString: third.colour]) {
            [first setBackgroundColor:[UIColor redColor]];
            [second setBackgroundColor:[UIColor redColor]];
            [third setBackgroundColor:[UIColor redColor]];
            return YES;
        }
        
        
    }
    
    
   
    
    return NO;
    
    
    
}


-(void)buttonDidClick:(MyButton *)button{
    if(!button.wasClick){
        
    if(self.i==0){
        [button setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
        self.i = 1;
        [button setColour:@"X"];
        
    }
    else{
    
        [button setBackgroundImage:[UIImage imageNamed:@"o.png"] forState:UIControlStateNormal];
        self.i = 0;
        [button setColour:@"0"];
       
        
    
    }
        [self changeTurn];
        button.wasClick= YES;
        if ([self gameWasOverWithButtonNumber:button.number]){
            NSLog(@"Game over");
        }
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
