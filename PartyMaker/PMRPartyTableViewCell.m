//
//  PMRTableViewCell.m
//  PartyMaker
//
//  Created by 2 on 2/11/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRPartyTableViewCell.h"
#import "PMRParty.h"
#import "NSDate+Utility.h"

@interface PMRPartyTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventTimeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation PMRPartyTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.logoImageView.image = nil;
    self.eventNameLabel.text = nil;
    self.eventTimeStartLabel.text = nil;
}

+ (NSString *)reuseIdentifier {
    return @"PMRPartyTableViewCellIdentifier";
}

- (void)configureWithParty:(PMRParty *)party {
    NSString *logoName = [NSString stringWithFormat:@"PartyLogo_Small_%d", party.imageIndex];
    
    self.logoImageView.image = [UIImage imageNamed:logoName];
    self.eventNameLabel.text = party.eventName;
    self.eventTimeStartLabel.text = [NSDate stringDateFromSeconds:(NSInteger)party.startTime withDateFormat:@"dd.MM.yyyy HH:mm"];
    self.partyId = (NSInteger)party.eventId;
    self.locationLabel.text = party.latitude;
}

@end
