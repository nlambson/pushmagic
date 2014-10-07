//
//  UsersTableViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UsersTableViewController.h"
#import "UserDetailViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "User.h"

@interface UsersTableViewController ()
@property (nonatomic, strong) NSMutableArray *contactsArray;
@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contactsArray = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewUser)];
    
    PFQuery *query = [PFQuery queryWithClassName:[User className]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
            // The find succeeded. The first 100 objects are available in objects
            NSLog(@"objects: %@", objects);
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"knockTimings"]);
                NSArray *knockTimings = @[];
                User *user = [[User alloc] initWithName:object[@"name"] color:object[@"color"] knockTimings:knockTimings keycode:object[@"keycode"]];
                
                [self.contactsArray addObject:user];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

        }
    }];
    
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addNewUser {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard-Main" bundle:nil];
    UserDetailViewController *controller = [sb instantiateViewControllerWithIdentifier:@"UserDetailStoryboard"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.contactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    // Configure the cell...
    User *user = self.contactsArray[indexPath.row];
    
    cell.textLabel.text = user.name;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
