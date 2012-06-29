//
//  PTPusherClient.m
//  libPusher
//
//  Created by Luke Redpath on 23/04/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "PTPusherChannel.h"
#import "PTPusher.h"
#import "PTPusherEvent.h"
#import "PTPusherEventDispatcher.h"
#import "PTTargetActionEventListener.h"
#import "PTBlockEventListener.h"
#import "PTPusherChannelAuthorizationOperation.h"
#import "PTPusherErrors.h"


@interface PTPusherChannel () 
@property (nonatomic, assign, readwrite) BOOL subscribed;
@end

#pragma mark -

@implementation PTPusherChannel

@synthesize name;
@synthesize subscribed;

+ (id)channelWithName:(NSString *)name pusher:(PTPusher *)pusher
{
  if ([name hasPrefix:@"private-"]) {
    return [[PTPusherPrivateChannel alloc] initWithName:name pusher:pusher];
  }
  if ([name hasPrefix:@"presence-"]) {
    return [[PTPusherPresenceChannel alloc] initWithName:name pusher:pusher];
  }
  return [[self alloc] initWithName:name pusher:pusher];
}

- (id)initWithName:(NSString *)channelName pusher:(PTPusher *)aPusher
{
  if (self = [super init]) {
    name = [channelName copy];
    pusher = aPusher;
    dispatcher = [[PTPusherEventDispatcher alloc] init];
    internalBindings = [[NSMutableArray alloc] init];
    
    /* Set up event handlers for pre-defined channel events */
    
    [internalBindings addObject:
     [self bindToEventNamed:@"pusher_internal:subscription_succeeded" 
                     target:self action:@selector(handleSubscribeEvent:)]];
    
    [internalBindings addObject:
     [self bindToEventNamed:@"subscription_error" 
                     target:self action:@selector(handleSubscribeErrorEvent:)]];
  }
  return self;
}

- (void)dealloc 
{
  [internalBindings enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
    [pusher removeBinding:object];
  }];
}

- (BOOL)isPrivate
{
  return NO;
}

- (BOOL)isPresence
{
  return NO;
}

#pragma mark - Subscription events

- (void)handleSubscribeEvent:(PTPusherEvent *)event
{
  self.subscribed = YES;
  
  if ([pusher.delegate respondsToSelector:@selector(pusher:didSubscribeToChannel:)]) {
    [pusher.delegate pusher:pusher didSubscribeToChannel:self];
  }
}

- (void)handleSubcribeErrorEvent:(PTPusherEvent *)event
{
  if ([pusher.delegate respondsToSelector:@selector(pusher:didFailToSubscribeToChannel:withError:)]) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:event forKey:PTPusherErrorUnderlyingEventKey];
    NSError *error = [NSError errorWithDomain:PTPusherErrorDomain code:PTPusherSubscriptionError userInfo:userInfo];
    [pusher.delegate pusher:pusher didFailToSubscribeToChannel:self withError:error];
  }
}

#pragma mark - Authorization

- (void)authorizeWithCompletionHandler:(void(^)(BOOL, NSDictionary *, NSError *))completionHandler
{
  completionHandler(YES, [NSDictionary dictionary], nil); // public channels do not require authorization
}

#pragma mark - Binding to events

- (PTPusherEventBinding *)bindToEventNamed:(NSString *)eventName target:(id)target action:(SEL)selector
{
  return [dispatcher addEventListenerForEventNamed:eventName target:target action:selector];
}

- (PTPusherEventBinding *)bindToEventNamed:(NSString *)eventName handleWithBlock:(PTPusherEventBlockHandler)block
{
  return [self bindToEventNamed:eventName handleWithBlock:block queue:dispatch_get_main_queue()];
}

- (PTPusherEventBinding *)bindToEventNamed:(NSString *)eventName handleWithBlock:(PTPusherEventBlockHandler)block queue:(dispatch_queue_t)queue
{
  return [dispatcher addEventListenerForEventNamed:eventName block:block queue:queue];
}

- (void)removeBinding:(PTPusherEventBinding *)binding
{
  [dispatcher removeBinding:binding];
}

#pragma mark - Dispatching events

- (void)dispatchEvent:(PTPusherEvent *)event
{
  [dispatcher dispatchEvent:event];
  
  [[NSNotificationCenter defaultCenter] 
       postNotificationName:PTPusherEventReceivedNotification 
                     object:self 
                   userInfo:[NSDictionary dictionaryWithObject:event forKey:PTPusherEventUserInfoKey]];
}

#pragma mark - Internal use only

- (void)subscribeWithAuthorization:(NSDictionary *)authData
{
  if (self.isSubscribed) return;
  
  [pusher sendEventNamed:@"pusher:subscribe" 
                    data:[NSDictionary dictionaryWithObject:self.name forKey:@"channel"]
                 channel:nil];
}

- (void)unsubscribe
{
  [pusher sendEventNamed:@"pusher:unsubscribe" 
                    data:[NSDictionary dictionaryWithObject:self.name forKey:@"channel"]
                 channel:nil];
  
  self.subscribed = NO;
  
  if ([pusher.delegate respondsToSelector:@selector(pusher:didUnsubscribeFromChannel:)]) {
    [pusher.delegate pusher:pusher didUnsubscribeFromChannel:self];
  }
}

- (void)markAsUnsubscribed
{
  self.subscribed = NO;
}

@end

#pragma mark -

@implementation PTPusherPrivateChannel

- (void)handleSubscribeEvent:(PTPusherEvent *)event
{
  [super handleSubscribeEvent:event];
  
  for (NSDictionary *bufferedClientEvent in clientEventBuffer) {
    NSString *eventName = [bufferedClientEvent objectForKey:@"eventName"];
    id eventData = [bufferedClientEvent objectForKey:@"eventData"];
    [self triggerEventNamed:eventName data:eventData];
  }
  
  clientEventBuffer = nil;
}

- (BOOL)isPrivate
{
  return YES;
}

- (void)authorizeWithCompletionHandler:(void(^)(BOOL, NSDictionary *, NSError *))completionHandler
{
  PTPusherChannelAuthorizationOperation *authOperation = [PTPusherChannelAuthorizationOperation operationWithAuthorizationURL:pusher.authorizationURL channelName:self.name socketID:pusher.connection.socketID];
  
  [authOperation setCompletionHandler:^(PTPusherChannelAuthorizationOperation *operation) {
    completionHandler(operation.isAuthorized, operation.authorizationData, operation.connectionError);
  }];
  
  if ([pusher.delegate respondsToSelector:@selector(pusher:willAuthorizeChannelWithRequest:)]) {
    [pusher.delegate pusher:pusher willAuthorizeChannelWithRequest:authOperation.mutableURLRequest];
  }
  
  [[NSOperationQueue mainQueue] addOperation:authOperation];
}

- (void)subscribeWithAuthorization:(NSDictionary *)authData
{
  if (self.isSubscribed) return;
  
  NSMutableDictionary *eventData = [authData mutableCopy];
  [eventData setObject:self.name forKey:@"channel"];
  [pusher sendEventNamed:@"pusher:subscribe" 
                    data:eventData
                 channel:nil];
}

#pragma mark - Triggering events

- (void)triggerEventNamed:(NSString *)eventName data:(id)eventData
{
  /** Because subscribing to a private (or presence) channel happens asynchronously
    and can be delayed by the authorization process, we should buffer any client events
    that have been triggered if subscription hasn't completed, so we can send them when
    we do finish subscribing.
   */
  if (self.subscribed == NO) {
    if (clientEventBuffer == nil) {
      clientEventBuffer = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *clientEvent = [NSDictionary dictionaryWithObjectsAndKeys:eventName, @"eventName", eventData, @"eventData", nil];
    [clientEventBuffer addObject:clientEvent];

    return;
  }
  
  if (![eventName hasPrefix:@"client-"]) {
    eventName = [@"client-" stringByAppendingString:eventName];
  }
  [pusher sendEventNamed:eventName data:eventData channel:self.name];
}

@end

#pragma mark -

@implementation PTPusherPresenceChannel

@synthesize presenceDelegate;
@synthesize members;

- (id)initWithName:(NSString *)channelName pusher:(PTPusher *)aPusher
{
  if ((self = [super initWithName:channelName pusher:aPusher])) {
    members = [[NSMutableDictionary alloc] init];
    memberIDs = [[NSMutableArray alloc] init];
    
    /* Set up event handlers for pre-defined channel events */

    [internalBindings addObject:
     [self bindToEventNamed:@"pusher_internal:member_added" 
                     target:self action:@selector(handleMemberAddedEvent:)]];
    
    [internalBindings addObject:
     [self bindToEventNamed:@"pusher_internal:member_removed" 
                     target:self action:@selector(handleMemberRemovedEvent:)]];
    
  }
  return self;
}

- (void)handleSubscribeEvent:(PTPusherEvent *)event
{
  NSDictionary *presenceData = [event.data objectForKey:@"presence"];
  [super handleSubscribeEvent:event];
  [members setDictionary:[presenceData objectForKey:@"hash"]];
  [memberIDs setArray:[presenceData objectForKey:@"ids"]];
  [self.presenceDelegate presenceChannel:self didSubscribeWithMemberList:memberIDs];
}

- (BOOL)isPresence
{
  return YES;
}

- (NSDictionary *)infoForMemberWithID:(NSString *)memberID
{
  return [members objectForKey:memberID];
}

- (NSArray *)memberIDs
{
  return [memberIDs copy];
}

- (NSInteger)memberCount
{
  return [memberIDs count];
}


- (void)handleMemberAddedEvent:(PTPusherEvent *)event
{
  NSString *memberID = [event.data objectForKey:@"user_id"];
  NSDictionary *memberInfo = [event.data objectForKey:@"user_info"];
  if (memberInfo == nil) {
    memberInfo = [NSDictionary dictionary];
  }
  [memberIDs addObject:memberID];
  [members setObject:memberInfo forKey:memberID];
  [self.presenceDelegate presenceChannel:self memberAddedWithID:memberID memberInfo:memberInfo];
}

- (void)handleMemberRemovedEvent:(PTPusherEvent *)event
{
  NSString *memberID = [event.data valueForKey:@"user_id"];
  NSInteger memberIndex = [memberIDs indexOfObject:memberID];
  [memberIDs removeObject:memberID];
  [members removeObjectForKey:memberID]; 
  [self.presenceDelegate presenceChannel:self memberRemovedWithID:memberID atIndex:memberIndex];
}

@end

