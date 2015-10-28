//
//  ViewController.m
//  Quiz
//
//  Created by ChenHao on 15/8/31.
//  Copyright (c) 2015年 ChenHao. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@property(nonatomic,weak)IBOutlet UILabel *questionLabel;

@property(nonatomic,weak)IBOutlet UILabel *answerLabel;

@property(nonatomic) int currentQuestionIndex;

@property(nonatomic,copy) NSArray *questions;

@property(nonatomic,copy) NSArray *answers;

@end

@implementation QuizViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.questions = @[@"From what is cognac made?",@"What is 7+7 ?",@"What is the capital of Vermont?"];
    self.answers = @[@"Grapes",@"14",@"Montpelier"];
    self.questionLabel.text = self.questions[0];
}

- (IBAction)showQuest:(id)sender {
    self.currentQuestionIndex++;
    if (_currentQuestionIndex == self.questions.count) {
        _currentQuestionIndex = 0;
    }
    self.questionLabel.text = self.questions[_currentQuestionIndex];
    self.answerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender {
    NSString *answer = self.answers[_currentQuestionIndex];
    self.answerLabel.text = answer;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
