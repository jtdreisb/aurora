//
//  AUPerformanceEditViewController.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/7/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "AUSongEditorViewController.h"

@interface AUSongEditorViewController ()

@property (strong, nonatomic) NSMutableArray *lightArray;

@end

@implementation AUSongEditorViewController


- (void)awakeFromNib
{
//    self.view.layer.backgroundColor = [[NSColor greenColor] CGColor];
    if (_lightArray == nil) {
        _lightArray = [NSMutableArray array];
//#if DEBUG
//        DBG_DPHueBridge *dbgBridge = [[DBG_DPHueBridge alloc] initWithHueHost:@"localhost" username:@"48564E5BC8EE70125CE8DDFCF57EC681"];
//        [dbgBridge readWithCompletion:^(DPHueBridge *hue, NSError *err) {
//            _bridge = hue;
//            [_lightArray addObjectsFromArray:_bridge.lights];
//        }];
//#endif
    }
    

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _lightArray.count;
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [_lightArray objectAtIndex:row];
}

@end
