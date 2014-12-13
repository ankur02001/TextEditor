/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//  TXTMainViewController.m-  TextEdit                                         //
//              Source file containing TxtmainView Controller Implementation.  //
//  Language:        Objective-C 2.0                                           //
//  Platform:        Mac OS X                                                  //
//  Course No.:      CIS-651                                                   //
//  Assignment No.:  hw3,part1                                                 //
//  Author:          Ankur Pandey, SUID: 408067486 , Syracuse University       //
//                   (315)572-2879, apandey@syr.edu                            //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////

#import "TXTMainViewController.h"

@interface TXTMainViewController ()
@end

//------------------------------------------------------------------------------
// Text Main View Controller implementation
//------------------------------------------------------------------------------
@implementation TXTMainViewController

//------------------------------------------------------------------------------
// viewDidload Called
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    openedFileName= NULL;
}

//------------------------------------------------------------------------------
// chechking FlipSide view Controller status
//------------------------------------------------------------------------------
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(TXTFlipsideViewController *)controller
{
    self.text.textColor = [UIColor colorWithRed: controller.redIntensity.value
                                         green: controller.greenIntensity.value
                                          blue: controller.blueIntensity.value
                                         alpha: 1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
       // NSLog(@"in prepareForSegue");
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.text resignFirstResponder];
}

//------------------------------------------------------------------------------
// Handling multiple Alert command
//------------------------------------------------------------------------------
-(void) alertView:(UIAlertView *)viewAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(viewAlert == _createAlert){
        if(buttonIndex == 1){
            UITextField *alertTextField = [viewAlert textFieldAtIndex:0];
            NSString *fileName = alertTextField.text;
            [self createFileWithName:(fileName)];
        }
    }
    if (viewAlert == _openAlert) {
        if(buttonIndex == 1){
        UITextField *alertTextField = [viewAlert textFieldAtIndex:0];
        NSString *fileName = alertTextField.text;
        [self readFileWithName:(fileName)];
        }
    }
    if (viewAlert == _saveAsAlert) {
        if(buttonIndex == 1){
            UITextField *alertTextField = [viewAlert textFieldAtIndex:0];
            NSString *fileName = alertTextField.text;
            if(openedFileName!=NULL){            [self renameFileWithName:openedFileName toName:fileName];
            }else{
                [self createFileWithName:(fileName)];
            }
        }
    }
    if (viewAlert == _insertAlert) {
        if(buttonIndex == 1){
            UITextField *alertTextField = [viewAlert textFieldAtIndex:0];
            NSString *fileName = alertTextField.text;
            [self insertstring:(fileName)];

        }
    }
}

//------------------------------------------------------------------------------
// Called when Save button is pressed
//------------------------------------------------------------------------------
- (IBAction)saveFile:(id)sender
{
    [self.text resignFirstResponder];
    
    if(openedFileName ==NULL){
        _createAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter file name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
        _createAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [_createAlert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"Enter File name";
        [_createAlert show];
    }else{
        [self writeString:self.text.text toFile:(openedFileName)];
    }
}

//------------------------------------------------------------------------------
// Called when Open button is pressed
//------------------------------------------------------------------------------
- (IBAction)openFile:(id)sender
{
    [self.text resignFirstResponder];
    
    _openAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter file to be open:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open",nil];
    _openAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [_openAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter File name";
    [_openAlert show];
    
}

//------------------------------------------------------------------------------
// Called when SaveAs button is pressed
//------------------------------------------------------------------------------
- (IBAction)SaveAsFile:(id)sender
{
    [self.text resignFirstResponder];
    _saveAsAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter file to be renamed:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    _saveAsAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [_saveAsAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter File name";
    [_saveAsAlert show];
}

//------------------------------------------------------------------------------
// Called when Insert button is pressed
//------------------------------------------------------------------------------
- (IBAction)InsertFile:(id)sender
{
    [self.text resignFirstResponder];
    _insertAlert  = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter file renamed to be inserted:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Insert",nil];
    _insertAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [_insertAlert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter File name";
    [_insertAlert show];
}

//------------------------------------------------------------------------------
// Creating file with specific name
//------------------------------------------------------------------------------
- (void)createFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager createFileAtPath:filePath contents:self.text.text attributes:nil]) {
        NSLog(@"Created the File Successfully.");
        openedFileName = fileName;
    } else {
        openedFileName = NULL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Failed to Create the File" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Failed to Create the File");
        
    }
}

//------------------------------------------------------------------------------
// Renaming file with new given name
//------------------------------------------------------------------------------
- (void)renameFileWithName:(NSString *)srcName toName:(NSString *)dstName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:srcName];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:dstName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        openedFileName = dstName;
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", srcName);
        [self createFileWithName:(dstName)];
    }
}

//------------------------------------------------------------------------------
// Reads the contains from the given file name
//------------------------------------------------------------------------------
- (void)readFileWithName:(NSString *)fileName
{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        // Start to Read.
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSLog(@"File Content: %@", content);
        self.text.text = content;
        openedFileName = fileName;
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
        self.text.text = NULL;
        openedFileName = NULL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"File does not exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

//------------------------------------------------------------------------------
// inserting file content to last position of cursor
//------------------------------------------------------------------------------
-(void) insertstring:(NSString *)fileName
{
    
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        // Start to Read.
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSLog(@"File Content: %@", content);
        [self.text replaceRange:_text.selectedTextRange withText:content];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"File does not exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

//------------------------------------------------------------------------------
// writng content to specific file name
//------------------------------------------------------------------------------
- (void)writeString:(NSString *)content toFile:(NSString *)fileName
{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Check if the file named fileName exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
             NSString *tmp =[[NSString alloc] initWithContentsOfFile:fileName usedEncoding:NSStringEncodingConversionAllowLossy error:nil];
                if (tmp) {
                    content = [tmp stringByAppendingString:content];
                }
        // Write NSString content to the file.
        [content writeToFile:filePath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
        // If error happens, log it.
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        // If the file doesn't exists, log it.
        NSLog(@"File %@ doesn't exists", fileName);
    }
}

//------------------------------------------------------------------------------
// Dispose of any resources that can be recreated.
//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
