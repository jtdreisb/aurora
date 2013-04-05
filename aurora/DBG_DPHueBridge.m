//
//  DBG_DPHueBridge.m
//  Aurora
//
//  Created by Jason Dreisbach on 3/29/13.
//  Copyright (c) 2013 Jason Dreisbach. All rights reserved.
//

#import "DBG_DPHueBridge.h"

@implementation DBG_DPHueBridge

- (void)readWithCompletion:(void (^)(DPHueBridge *, NSError *))block
{
    NSDictionary *stateDictionary = @{
                                      @"config" :     @{
                                              @"UTC" : @"2013-02-09T05:26:51",
                                              @"dhcp" : @1,
                                              @"gateway" : @"10.0.1.1",
                                              @"ipaddress" : @"10.0.1.2",
                                              @"linkbutton" : @0,
                                              @"mac" : @"00:17:88:09:7e:80",
                                              @"name" : @"Philips hue",
                                              @"netmask" : @"255.255.255.0",
                                              @"portalservices" : @1,
                                              @"proxyaddress" : @"",
                                              @"proxyport" : @0,
                                              @"swupdate" :         @{
                                                      @"notify" : @0,
                                                      @"text" : @"",
                                                      @"updatestate" : @0,
                                                      @"url" : @"",
                                                      },
                                              @"swversion" : @01003542,
                                              @"whitelist" :         @{
                                                      @"33bf7ba02ee74a8f1e9397f03b09fa7f" :             @{
                                                              @"create date" : @"2013-02-02T02:20:36",
                                                              @"last use date" : @"2013-02-02T04:00:33",
                                                              @"name" : @"Hue Disco",
                                                              },
                                                      @"345ddb433da5bef3d2ef3dc23aba957" :             @{
                                                              @"create date" : @"2013-02-07T07:45:50",
                                                              @"last use date" : @"2013-02-08T06:41:26",
                                                              @"name" : @"Hue Disco",
                                                              },
                                                      @"48564E5BC8EE70125CE8DDFCF57EC681" :             @{
                                                              @"create date" : @"2013-02-06T18:31:13",
                                                              @"last use date" : @"2013-02-09T05:26:51",
                                                              @"name" : @"QuickHue",
                                                              },
                                                      @"577f4e61ee0bd99e33783e668e28f4e9" :             @{
                                                              @"create date" : @"2012-11-11T00:30:59",
                                                              @"last use date" : @"2012-11-16T06:14:58",
                                                              @"name" : @"iKane's iPad",
                                                              },
                                                      @"658d135bef3b7f72eba32d03f9b19717" :             @{
                                                              @"create date" : @"2012-11-10T23:42:39",
                                                              @"last use date" : @"2012-11-11T00:00:08",
                                                              @"name" : @"iKane's iPhone",
                                                              },
                                                      @"c3d3a06612dfa30291cd716273fc8341" :             @{
                                                              @"create date" : @"2012-11-10T23:44:34",
                                                              @"last use date" : @"2013-02-09T01:39:00",
                                                              @"name" : @"Jason Dreisbach's iPhone",
                                                              },
                                                      },
                                              },
                                      @"groups" :     @{
                                              },
                                      @"lights" :     @{
                                              @"1" :         @{
                                                      @"modelid" : @"LCT001",
                                                      @"name" : @"Floor lamp",
                                                      @"pointsymbol" :             @{
                                                              @"1" : @"none",
                                                              @"2" : @"none",
                                                              @"3" : @"none",
                                                              @"4" : @"none",
                                                              @"5" : @"none",
                                                              @"6" : @"none",
                                                              @"7" : @"none",
                                                              @"8" : @"none",
                                                              },
                                                      @"state" :             @{
                                                              @"alert" : @"none",
                                                              @"bri" : @219,
                                                              @"colormode" : @"ct",
                                                              @"ct" : @231,
                                                              @"effect" : @"none",
                                                              @"hue" : @33863,
                                                              @"on" : @1,
                                                              @"reachable" : @1,
                                                              @"sat" : @49,
                                                              @"xy" :                 @[
                                                                      @"0.368",
                                                                      @"0.3686"
                                                                      ],
                                                              },
                                                      @"swversion" : @65003148,
                                                      @"type" : @"Extended color light",
                                                      },
                                              @"2" :         @{
                                                      @"modelid" : @"LCT001",
                                                      @"name" : @"Back fan",
                                                      @"pointsymbol" :             @{
                                                              @"1" : @"none",
                                                              @"2" : @"none",
                                                              @"3" : @"none",
                                                              @"4" : @"none",
                                                              @"5" : @"none",
                                                              @"6" : @"none",
                                                              @"7" : @"none",
                                                              @"8" : @"none",
                                                              },
                                                      @"state" :             @{
                                                              @"alert" : @"none",
                                                              @"bri" : @215,
                                                              @"colormode" : @"ct",
                                                              @"ct" : @231,
                                                              @"effect" : @"none",
                                                              @"hue" : @10863,
                                                              @"on" : @1,
                                                              @"reachable" : @1,
                                                              @"sat" : @88,
                                                              @"xy" :                 @[
                                                                      @"0.368",
                                                                      @"0.3686"
                                                                      ],
                                                              },
                                                      @"swversion" : @65003148,
                                                      @"type" : @"Extended color light",
                                                      },
                                              @"3" :         @{
                                                      @"modelid" : @"LCT001",
                                                      @"name" : @"Front fan",
                                                      @"pointsymbol" :             @{
                                                              @"1" : @"none",
                                                              @"2" : @"none",
                                                              @"3" : @"none",
                                                              @"4" : @"none",
                                                              @"5" : @"none",
                                                              @"6" : @"none",
                                                              @"7" : @"none",
                                                              @"8" : @"none",
                                                              },
                                                      @"state" :             @{
                                                              @"alert" : @"none",
                                                              @"bri" : @219,
                                                              @"colormode" : @"ct",
                                                              @"ct" : @231,
                                                              @"effect" : @"none",
                                                              @"hue" : @33863,
                                                              @"on" : @1,
                                                              @"reachable" : @1,
                                                              @"sat" : @49,
                                                              @"xy" :                 @[
                                                                      @"0.368",
                                                                      @"0.3686"
                                                                      ],
                                                              },
                                                      @"swversion" : @65003148,
                                                      @"type" : @"Extended color light",
                                                      },
                                              },
                                      @"schedules" :     @{
                                              },
                                      };
    [self readFromJSONDictionary:stateDictionary];
    block(self, nil);
}



- (void)write
{
    if (self.pendingChanges.count == 0) {
        NSLog(@"No Changes: %@", self);
    }
    else {
        NSLog(@"write: %@: %@", self.URL, self.pendingChanges);
    }
}




@end
