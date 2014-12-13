/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  TXTMainViewController.h-  TextEdit                                         //
//              Source file containing TxtmainView Controller Interface.       //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//  Course No.:      CIS-651                                                   //
//  Assignment No.:  hw3,part1                                                 //
//  Author:          Ankur Pandey, SUID: 408067486 , Syracuse University       //
//                   (315)572-2879, apandey@syr.edu                            //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

#import "TXTFlipsideViewController.h"

//------------------------------------------------------------------------------
// Defining TXT Main View Controller Interface
//------------------------------------------------------------------------------
@interface TXTMainViewController : UIViewController <TXTFlipsideViewControllerDelegate,UITextFieldDelegate>
{
    NSString* openedFileName; // tracking opened file
}
@property (weak, nonatomic) IBOutlet UITextView *text; // text editor
@property (strong, nonatomic) UIAlertView * createAlert; //to save
@property (strong, nonatomic) UIAlertView * openAlert; // to open
@property (strong, nonatomic) UIAlertView * saveAsAlert; //to save as different name
@property (strong, nonatomic) UIAlertView * insertAlert; //to insert file at specific cursor location

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)openFile:(id)sender;
- (IBAction)saveFile:(id)sender;
- (IBAction)SaveAsFile:(id)sender;
- (IBAction)InsertFile:(id)sender;

@end
