//
//  ViewController.m
//  iOS_Socket
//
//  Created by 李小龙 on 2020/4/1.
//  Copyright © 2020 李小龙. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()
@property (nonatomic,strong) GCDAsyncSocket *clientSocket;
@property (nonatomic,assign) BOOL connected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
// 与主控建立连接
- (void)setSocketData
{
    if (self.clientSocket && self.clientSocket.isConnected) {
        [self.clientSocket disconnect];
        self.clientSocket = nil;
    }
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    self.connected =  [self.clientSocket connectToHost:@"你的地址" onPort:@"你的端口号" viaInterface:nil withTimeout:20 error:&error];
}
 
// 连接成功之后会回调GCDAsyncSocketDelegate的连接成功的方法如下。

/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
**/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功，连接主机信息 %@",sock);
    self.connected = YES;
    // 连接后,可读取服务端的数据
    [self.clientSocket readDataWithTimeout:-1 tag:1];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"tcp连接断开，%@",err);
    self.connected = NO;
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
**/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    [APPDELEGATE.clientSocket readDataWithTimeout:- 1 tag:1];
    NSLog(@"接收到的数据%@",data);
}
 
 //发送数据的方法
 - (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    
}


//发送指令
+ (void)sendData{
//    NSData *data = [SendDataOp returnSetData];
//    NSLog(@"发送数据Cmd_set%@----------", data.description);
//    [APPDELEGATE.clientSocket writeData:data withTimeout:-1 tag:0];
}

//构造data
+ (NSData *)returnSetData
{
    //方法1,创建bytes数组
//    Byte bytes[8] = {0x11,0xff,0x11,0xff,0x03,0x02,0x01,0x28};//40转为26进制为0x28
//    //想操作其中某位可以用下标找到并修改，比如想把最后一位"亮度"改为5
//    bytes[7] = 0x05;
//    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    
    
    //方法2，直接拼接data
    NSMutableData *data = [NSMutableData data];
    //表头
    char head1 = 0x11;
    [data appendBytes:&head1 length:1];
    char head2 = 0xff;
    [data appendBytes:&head2 length:1];
    char head3 = 0x11;
    [data appendBytes:&head3 length:1];
    char head4 = 0xff;
    [data appendBytes:&head4 length:1];
    
    //长度
    char length = 0x03;
    [data appendBytes:&length length:1];
    //灯泡号
    char num = 0x02;
    [data appendBytes:&num length:1];
    
    //命令字
    char cmd = 0x01;
    [data appendBytes:&cmd length:1];
    
    //灯泡的亮度
    int lightness = 40;
//    [data appendData:[mathUtil convertHexStrToData:[mathUtil ToHex:lightness]]];//这一步是把亮度40转化为16进制字符串，然后16进制字符串转化为NSData。下面粘上这一部分转换的方法

//推荐方法2,直接可以调用方法转为NSData，而方法1需要手动将40换算为28再拼上去。
    
    return data;
    //即拼成了11 ff 11 ff 03 02 01 28
}

+(NSString *)ToHex:(long long int)tmpid

{
    
    NSString *nLetterValue;
    
    NSString *str =@"";
    
    long long int ttmpig;
    
    for (int i =0; i<9; i++) {
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        
        switch (ttmpig)
        
        {
                
            case 10:
                
                nLetterValue =@"A";break;
                
            case 11:
                
                nLetterValue =@"B";break;
                
            case 12:
                
                nLetterValue =@"C";break;
                
            case 13:
                
                nLetterValue =@"D";break;
                
            case 14:
                
                nLetterValue =@"E";break;
                
            case 15:
                
                nLetterValue =@"F";break;
                
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        
        if (tmpid == 0) {
            
            break;
            
        }
    }
    return str;
}
 

+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
 
 
@end
