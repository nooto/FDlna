//
//  ItunesMusicDMSDelegate.h
//  DLNA_iOS
//
//  Created by wangshuaidavid on 12-8-21.
//
//

#import <UIKit/UIKit.h>
#import <Platinum/Platinum.h>
#import "PltMediaServerObject.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ItunesMusicDMSDelegate : NSObject <PLT_MediaServerDelegateObject> {
	
}

@property (nonatomic, copy) void(^didBorwseFiles)(PLT_MediaObject *item);
@property(nonatomic, retain)NSArray *albumsArray;

-(void)saveItuneMusicToServerDic;
@end
