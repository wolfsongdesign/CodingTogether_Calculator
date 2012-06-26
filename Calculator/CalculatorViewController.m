//
//  CalculatorViewController.m
//  Calculator
//
//  Created by andy on 6/26/12.
//  Copyright (c) 2012 Wolfsong, LLC. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (strong, nonatomic) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

// Lazy instantiation of Array 
- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

//
// digit Key Pressed
//
- (IBAction)digitPressed:(UIButton *)sender {
    // FIXME using currentTitle of button instead of using localization
    NSString *digit = sender.currentTitle;
    NSString *displayString = self.display.text;
    // FIXME temporarily setting Pi
    // if ([digit isEqualToString:@"π"]) digit = M_PI;
    
    // Do not allow multiple decimal points
    if ([digit isEqualToString:@"."]) {
        // Split string on "." and count number of fields
        NSArray *fields = [displayString componentsSeparatedByString:@"."];
        NSUInteger numberofFields = fields.count;
        // Return if more than 1 fields 
        if (numberofFields > 1) return;
    }
    // Add digits to display string
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

//
// enter Key Pressed
//
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

//
// operation Key Pressed
//
- (IBAction)operationPressed:(id)sender {
    // If user presses a number then an operation, press Enter for the user
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end

