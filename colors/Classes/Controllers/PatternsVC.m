//
//  PatternsVC.m
//  colors
//
// Copyright 2013 Alexis Creuzot
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "PatternsVC.h"
#import "Pattern.h"
#import "PatternCell.h"

@interface PatternsVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *patternsCollectionView;
@end

@implementation PatternsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Patterns";
    [_searchBar setText:@""];
    self.patternsCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.patternsCollectionView registerClass:[PatternCell class] forCellWithReuseIdentifier:@"PatternCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    // We check the database, and proceed to do a web request
    // if the database doesn't return any results
    if([[Pattern allObjects] count] == 0){
        [self requestPatterns];
    }else{
        [_patternsCollectionView reloadData];
    }
}

#pragma mark - Networking

- (void) requestPatterns
{
    // Init client
    // Launch progressHUD and request
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:URL_BASE];
    [manager GET:@"patterns" parameters:@{@"format" : @"json",@"keywords" : _searchBar.text}
            success:^(AFHTTPRequestOperation *operation, NSArray * JSON) {
                                
                // Refresh the data with the new values
                [[RLMRealm defaultRealm] transactionWithBlock:^{
                    [[RLMRealm defaultRealm] deleteObjects:[Pattern allObjects]];
                    for(NSDictionary * obj in JSON){
                        [Pattern createOrUpdateInDefaultRealmWithObject:obj];
                    }
                }];
                
                [_patternsCollectionView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"Done"];
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
}

#pragma mark - CollectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [Pattern allObjects].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PatternCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
    Pattern * currentPattern = [Pattern allObjects][indexPath.row];
    [cell.patternImage sd_setImageWithURL:[NSURL URLWithString:currentPattern.imageUrl]];
    return cell;
}

#pragma mark - SearchBar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestPatterns];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

@end