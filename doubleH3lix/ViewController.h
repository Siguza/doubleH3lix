//
//  ViewController.h
//  doubleH3lix
//
//  Created by tihmstar on 18.02.18.
//  Copyright © 2018 tihmstar. All rights reserved.
//

#ifndef HEADLESS

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)go:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gobtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

#endif
