//
//  CMCustomResponsesViewController.m
//  covrme
//
//  Created by Anthony Wong on 2013-06-29.
//
//

#import "CMCustomResponsesViewController.h"
#import "CMCustomResponse.h"

@interface CMCustomResponsesViewController ()

@end

@implementation CMCustomResponsesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Responses";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    self.frc = [CMCustomResponse fetchAllGroupedBy:nil
                                     withPredicate:nil
                                          sortedBy:@"createdDate"
                                         ascending:YES];
    self.frc.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTouched:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add a response"
                                                    message:@"Please enter the custom response you wish to send"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"Your custom response";
    
    [alert show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *text = textField.text;
        
        if (text.length) {
            [MagicalRecord
             saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
                 CMCustomResponse *newResponse = [CMCustomResponse createInContext:localContext];
                 newResponse.responseText = text;
                 newResponse.createdDate = [NSDate date];
             } completion:nil];
        }

    }
}

#pragma mark - UITableViewMethods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMCustomResponse *customResponse = [self.frc.fetchedObjects objectAtIndex:indexPath.row];
    [self.responderDelegate sendResponse:customResponse.responseText];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CMCustomResponseTableCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CMCustomResponseTableCell"];
    }
    
    CMCustomResponse *customResponse = [self.frc.fetchedObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = customResponse.responseText;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.frc.fetchedObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - NSFetchedResultsController Delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}
@end
