//
//  MyButton.m
//  TicTacToe
//
//  Created by Мария Тимофеева on 14.04.16.
//  Copyright © 2016 ___matim___. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton



-(instancetype)init{
    self = [super init];
    self.wasClick = NO;
    [self setFrame:CGRectMake(60 , 60 , 60, 60) ];
    [self setBackgroundColor:[UIColor blackColor]];
    self.active = YES;
    
    return self;
}



@end
