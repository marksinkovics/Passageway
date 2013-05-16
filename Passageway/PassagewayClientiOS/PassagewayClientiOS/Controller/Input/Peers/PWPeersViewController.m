//
//  PWPeersViewController.m
//  PassagewayClientiOS
//
//  Created by Mark Sinkovics on 3/19/13.
//  Copyright (c) 2013 mscodefactory. All rights reserved.
//

#import "PWPeersViewController.h"
#import "PWPeersCell.h"

@interface PWPeersViewController ()

@property (nonatomic, strong) NSArray* peers;

@end

@implementation PWPeersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
	
    if (self)
	{
        // Custom initialization
    }
    return self;
}

#pragma mark - View Handling

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowViewController:)])
    {
        [self.delegate didShowViewController:self];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didHideViewController:)])
    {
        [self.delegate didHideViewController:self];
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (void)updateListWithPeers:(NSArray*)peers
{
	self.peers = peers;
	
	[self.tableView reloadData];
}

- (IBAction)cancel:(id)sender
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(didCancelViewController:)])
    {
        [self.delegate didCancelViewController:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PWPeersCell";
	
    PWPeersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
		cell = [[PWPeersCell alloc] init];
	}
	
	PWBasePeer* peer = [self.peers objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = peer.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PWBasePeer* _selectedPeer = [self.peers objectAtIndex:indexPath.row];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewController:didSelectPeer:)])
    {
        [self.delegate viewController:self didSelectPeer:_selectedPeer];
    }
}

@end
