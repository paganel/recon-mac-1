//
//  TcpTsSeqValue.h
//  recon
//
//  Created by Sumanth Peddamatham on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Host;

@interface TcpTsSeqValue :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * value;
@property (nonatomic, strong) Host * host;

@end



