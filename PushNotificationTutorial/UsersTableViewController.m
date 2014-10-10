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
#import "UserDetailViewController.h"

#import "KnockResponseViewController.h"

@interface UsersTableViewController ()
@property (nonatomic, strong) NSMutableArray *contactsArray;

//@property (nonatomic, strong) User *selectedUser;

@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contactsArray = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewUser)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Users";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8 + 45 + 8, 0, 0);
}

- (void)queryUsersAndReload {
    
    [self.contactsArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:[User className]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        } else {
            // The find succeeded. The first 100 objects are available in objects
            NSLog(@"objects: %@", objects);
            
            for (PFObject *object in objects) {
                NSArray *knockTimings = object[@"knockTimings"];
                User *user = [[User alloc] initWithName:object[@"name"] color:object[@"color"] knockTimings:knockTimings keycode:object[@"keycode"]];
                user.avatar = [object valueForKey:@"avatar"];
                
                NSLog(@"%@", user.knockTimings);
                [self.contactsArray addObject:user];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveKnockNotification:)
                                                 name:@"PushKnock"
                                               object:nil];
    
    [self queryUsersAndReload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:2];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    
    lbl.text = user.name;
    imageView.image = nil;
    
    imageView.layer.cornerRadius = imageView.frame.size.height * 0.5;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1.0];
    
    [user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            imageView.image = image;
        }
    }];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowUserDetailsSegue"]) {
        UserDetailViewController *detail = (UserDetailViewController *)segue.destinationViewController;
        detail.user = [self.contactsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
    }
}

- (void)receiveKnockNotification:(NSNotification *)notification {
    KnockResponseViewController *knockResponse = [[UIStoryboard storyboardWithName:@"KnockResponseStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    knockResponse.hue = [notification.object objectForKey:@"color"] ?: @(0);
    knockResponse.userName = [notification.object objectForKey:@"name"] ?: @"A Visitor";
    [self.navigationController pushViewController:knockResponse animated:YES];
}

@end
