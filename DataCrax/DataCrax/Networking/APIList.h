//
//  APIList.h
//  rewardifypro
//
//  Created by Gaurav on 06/04/16.
//  Copyright © 2016 Rewardify. All rights reserved.
//

#define BASE_URL                    @"http://54.68.192.125:5000"

#define API_PRICE_PREDICT           @"predict"
#define API_BRAND_LIST              @"brandList"

/**
 *  @abstract API Client fires this notification when server is not reachable.
 */
static NSString * const RPAPIClientNotReachableErrorNotification        = @"RP_APICLIENT_NOT_REACHABLE_ERROR";

/**
 *  @abstract API Client fires this notification when there is an internal server error.
 */
static NSString * const RPAPIClientInternalServerErrorNotification      = @"RP_APICLIENT_INTERNAL_SERVER_ERROR";

/**
 *  @abtract API Client fires this notification when there is a server timout error.
 */
static NSString * const RPAPIClientServerTimeoutErrorNotification       = @"RP_APICLIENT_SERVER_TIMEOUT_ERROR";

/**
 *  @abstract API Client fires this notification when user is unauthorized.
 */
static NSString * const RPAPIClientUserUnauthorizedErrorNotification    = @"RP_APICLIENT_USER_UNAUTHORIZED_ERROR";

/**
 *  @abstract API Client fires this notificaiton for the set of errors which are defined well known.
 */
static NSString * const RPAPIClientWellKnownErrorNotification           = @"RP_APICLIENT_WELL_KNOWN_ERROR";


/**
 * @abstract RPSDKDelegate fires this notification whenever device receives any Remote (RPSH) Notification.
 */
static NSString * const RPSDKDelegateReceivedRemoteNotification         = @"RP_SDKDELEGATE_RECEIVE_REMOTE_NOTIFICATION";

/**
 *  @abstract This notification is fired by BeaconManager when the device comes in range of RPnchh Beacon.
 */
static NSString * const RPBeaconManagerRangeEnterNotification           = @"RP_BEACONMANAGER_RANGE_ENTERED";

/**
 *  @abstract This notification is fired by BeaconManager when the device exists range of RPnchh Beacon.
 */
static NSString * const RPBeaconManagerRangeExitNotification            = @"RP_BEACONMANAGER_RANGE_EXITED";

/**
 *  @abstract This notificaiton is fired when a redeemable is found to be expired at the time of redemption.
 */
static NSString * const RPUserManagerRedeemableExpiredNotification      = @"RP_USERMANAGER_REDEEMABLE_EXPIRED";

/**
 *  @abstract This notification is fired by User Manager when a user Logs In.
 */
static NSString * const RPUserManagerUserLogInNotification              = @"RP_USERMANAGER_USER_LOGIN";

/**
 *  @abstract This notification is fired by User Manager when a user Logs Out.
 */
static NSString * const RPUserManagerUserLogOutNotification             = @"RP_USERMANAGER_USER_LOGOUT";
