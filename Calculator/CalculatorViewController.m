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
@property (weak, nonatomic) IBOutlet UILabel *program;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize program = _program;

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
        self.display.text = [displayString stringByAppendingFormat:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

//
// clear Key Pressed
//
- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    // Clear display(s)
    self.display.text = @"0";
    self.program.text = @"0";
    // Clear stack
    [self.brain performOperation: @"CLEAR"];
}

//
// enter Key Pressed
//
- (IBAction)enterPressed {    
    NSString *displayString = self.display.text;
    NSString *programString = self.program.text;

    // Catch corner case if user presses "." then Enter
    if ([displayString isEqualToString:@"."]) return;

    // Set program label
    if ([programString isEqualToString:@"0"]) {
        self.program.text = displayString;
    } else {
        self.program.text = [self.program.text stringByAppendingFormat:@" "];
        self.program.text = [self.program.text stringByAppendingFormat:displayString];
    }

    // Push operand on stack
    [self.brain pushOperand:[displayString doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

//
// operation Key Pressed
//
- (IBAction)operationPressed:(id)sender {    
    NSString *operation = [sender currentTitle];
    
    // If user presses a number then an operation, press Enter for the user
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    // Set program label
    self.program.text = [self.program.text stringByAppendingFormat:@" "];
    self.program.text = [self.program.text stringByAppendingFormat:operation];
    //
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)viewDidUnload {
    [self setProgram:nil];
    [super viewDidUnload];
}
@end

