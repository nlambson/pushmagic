//
//  DetailViewController.h
//  PushMagic
//
//  Created by Nathan Lambson on 10/7/14.
//  Copyright (c) 2014 instructure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

