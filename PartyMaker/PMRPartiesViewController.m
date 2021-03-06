//
//  PMRMainViewController.m
//  PartyMaker
//
//  Created by 2 on 2/3/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartiesViewController.h"
#import "PMRPartyTableViewCell.h"
#import "PMRParty.h"
#import "PMRPartyInfoViewController.h"
#import "PMRApiController.h"
#import "PMRUser.h"
#import "PMRPartyMakerNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface PMRPartiesViewController() <UITableViewDataSource,
                                       UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *parties;
@property (nonatomic) PMRPartyTableViewCell *selectedCell;

@end


@implementation PMRPartiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Back", @"Language", nil)]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1], NSForegroundColorAttributeName, [UIFont fontWithName:@"MyriadPro-Regular" size:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255. green:31/255. blue:36/255. alpha:1];
    self.parties = [[NSMutableArray alloc] init];
    
    [self.tabBarItem setTitle:@"STROka"];
    self.navigationItem.title = NSLocalizedStringFromTable(@"PARTY MAKER", @"Language", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __block __weak PMRPartiesViewController *weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedStringFromTable(@"Loading...", @"Language", nil);
    
    PMRUser *user = [PMRApiController apiController].user;
    [[PMRApiController apiController] loadAllPartiesByUserId:user.userId withCallback:^(NSArray *parties) {
        [weakSelf.parties removeAllObjects];
        [weakSelf.parties addObjectsFromArray:parties];
        [weakSelf.tableView reloadData];
        [weakSelf recreateAllNotificationsForEachParty];
        
        [hud hide:YES];
        
    }];
}

#pragma mark - TableView delegates methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMRPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PMRPartyTableViewCell reuseIdentifier] forIndexPath:indexPath];
    PMRParty *selectedParty = self.parties[indexPath.row];
    [cell configureWithParty:selectedParty];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parties.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"PartyMkerViewControllerToPartyInfoViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PartyMkerViewControllerToPartyInfoViewController"]) {
        PMRPartyInfoViewController *partyInfoViewController = segue.destinationViewController;
        PMRParty *selectedParty = [self partyDictionaryById:self.selectedCell.partyId];
        partyInfoViewController.party = selectedParty;
    }
}

#pragma mark - Helpers

- (PMRParty *)partyDictionaryById:(NSInteger)partyId {
    for (PMRParty *party in self.parties) {
        if (party.eventId == partyId) {
            return party;
        }
    }
    return nil;
}

- (void)recreateAllNotificationsForEachParty {
    [PMRPartyMakerNotification deleteAllLocalNotifications];
    [PMRPartyMakerNotification createNewLocalNotificationsForParties:self.parties];
}

@end
