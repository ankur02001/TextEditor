/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  TXTFlipSideViewController.h-  TextEdit                                     //
//              Source file containing TxtFlipSideView Controller Interface.   //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//  Course No.:      CIS-651                                                   //
//  Assignment No.:  hw3,part1                                                 //
//  Author:          Ankur Pandey, SUID: 408067486 , Syracuse University       //
//                   (315)572-2879, apandey@syr.edu                            //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@class TXTFlipsideViewController;

@protocol TXTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(TXTFlipsideViewController *)controller;
@end

@interface TXTFlipsideViewController : UIViewController

@property (weak, nonatomic) id <TXTFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISlider *redIntensity;
@property (weak, nonatomic) IBOutlet UISlider *greenIntensity;
@property (weak, nonatomic) IBOutlet UISlider *blueIntensity;
@property (weak, nonatomic) IBOutlet UITextField *preview;

- (IBAction)done:(id)sender;
- (IBAction)previewColor:(id)sender;

@end
