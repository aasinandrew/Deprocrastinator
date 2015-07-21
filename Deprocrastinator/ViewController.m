//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Sean's Macboo Pro on 7/20/15.
//  Copyright (c) 2015 seanallen.co. All rights reserved.
//

#import "ViewController.h"
#import "Tasks.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property NSMutableArray *tasks;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray new];
    Tasks *task = [Tasks new];
    task.titleName = @"Your first task";
    task.color = [UIColor blackColor];
    task.done = NO;
    [self.tasks addObject:task];
    [self.tableView setEditing: NO];
    self.editing = NO;
    self.addButton.enabled = NO;
    [self.addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

- (IBAction)onAddButtonPressed:(UIButton *)sender {
    Tasks *newTask = [Tasks new];
    newTask.titleName = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    newTask.color = [UIColor blackColor];
    newTask.done = NO;
    [self.tasks addObject:newTask];
    [self.tableView reloadData];
    [self.textField resignFirstResponder];
    self.textField.text =@"";
    sender.enabled = NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Tasks *tempTask = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = tempTask.titleName;
    cell.textLabel.textColor = tempTask.color;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size: 20]];

    if (tempTask.done) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tasks *tempTask = [self.tasks objectAtIndex:indexPath.row];
    if (tempTask.done) {
        tempTask.done = NO;
    }
    else
    {
        tempTask.done = YES;
    }
    [tableView reloadData];
}

- (IBAction)onEditPressed:(UIButton *)sender {
    if (self.editing) {
        self.editing = NO;
        [self.tableView setEditing: NO];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];

    } else {
        self.editing = YES;
        [self.tableView setEditing: YES];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task?" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction: delete];
    [alert addAction: cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)swipePriority:(UISwipeGestureRecognizer *)sender {
    CGPoint swipePoint = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:swipePoint];

    Tasks *temp = [self.tasks objectAtIndex:indexPath.row];

    if (temp.color == [UIColor blackColor]) {
        temp.color = [UIColor redColor];
    } else if (temp.color == [UIColor redColor]) {
        temp.color = [UIColor orangeColor];
    } else if (temp.color == [UIColor orangeColor]) {
        temp.color = [UIColor colorWithRed:107.0 /255 green:223.0 / 255 blue:16.0 / 255 alpha:1.0];
    } else {
        temp.color = [UIColor blackColor];
    }
    [self.tableView reloadData];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Tasks *task = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObject:task];
    [self.tasks insertObject:task atIndex:destinationIndexPath.row];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self onAddButtonPressed:self.addButton];
//    NSString *tempString = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    if (tempString.length > 0 && textField.returnKeyType == UIReturnKeyDone) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    NSString *textWithoutSpaces = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (textWithoutSpaces.length > 0) {
        self.addButton.enabled = YES;
    } else {
        self.addButton.enabled = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}



@end
