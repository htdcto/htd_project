//
//  DB.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/9.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject
{
    sqlite3 *db;
}
+(instancetype)shareInit;
-(void)openOrCreateDB;
-(void)updateDBAfterLoginSuccess:(NSString *)Uname;
-(void)execSql:(NSString *)sql;
-(NSMutableArray *)upTimestamp:(int)key;
-(NSMutableArray *)caculateTheCountOfTimestampFromServer:(int)k;
@end
