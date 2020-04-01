//
//  ListenServerData.m
//  iOS_Socket
//
//  Created by 李小龙 on 2020/4/1.
//  Copyright © 2020 李小龙. All rights reserved.
//

#import "ListenServerData.h"
#import "GCDAsyncUdpSocket.h"

@interface ListenServerData ()
@property (strong, nonatomic) GCDAsyncUdpSocket *gcdUdpSocket;
@end

@implementation ListenServerData

- (id)initWithData;

{

    if (self = [super init]) {

        

        self.gcdUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

        

        NSError *error;

        [_gcdUdpSocket bindToPort:88898 error:&error];

        if (nil != error) {

            NSLog(@"failed.:%@",[error description]);

        }

        

        [_gcdUdpSocket enableBroadcast:YES error:&error];

        if (nil != error) {

            NSLog(@"failed.:%@",[error description]);

        }

        //组播224.0.0.2地址，如果地址大于224的话，就要设置GCDAsyncUdpSocket的TTL （默认TTL为1）

        [_gcdUdpSocket joinMulticastGroup:@"224.0.0.2" error:&error];

        if (nil != error) {

            NSLog(@"failed.:%@",[error description]);

        }

        

        [_gcdUdpSocket beginReceiving:&error];

        if (nil != error) {

            NSLog(@"failed.:%@",[error description]);

        }

    }

    return self;

}



- (void)dealloc

{

    if (_gcdUdpSocket) {

        [_gcdUdpSocket close];
}

}

#pragma mark -GCDAsyncUdpsocket Delegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext

{
NSLog(@"Reciv Data len:%d",[data length]);

}



- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error

{
NSLog(@"udpSocketDidClose Error:%@",[error description]);

}


 

@end
