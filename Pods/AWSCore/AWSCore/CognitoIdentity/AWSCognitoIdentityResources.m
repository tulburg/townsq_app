//
// Copyright 2010-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
// http://aws.amazon.com/apache2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "AWSCognitoIdentityResources.h"
#import "AWSCocoaLumberjack.h"

@interface AWSCognitoIdentityResources ()

@property (nonatomic, strong) NSDictionary *definitionDictionary;

@end

@implementation AWSCognitoIdentityResources

+ (instancetype)sharedInstance {
    static AWSCognitoIdentityResources *_sharedResources = nil;
    static dispatch_once_t once_token;

    dispatch_once(&once_token, ^{
        _sharedResources = [AWSCognitoIdentityResources new];
    });

    return _sharedResources;
}

- (NSDictionary *)JSONObject {
    return self.definitionDictionary;
}

- (instancetype)init {
    if (self = [super init]) {
        //init method
        NSError *error = nil;
        _definitionDictionary = [NSJSONSerialization JSONObjectWithData:[[self definitionString] dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:kNilOptions
                                                                  error:&error];
        if (_definitionDictionary == nil) {
            if (error) {
                AWSDDLogError(@"Failed to parse JSON service definition: %@",error);
            }
        }
    }
    return self;
}

- (NSString *)definitionString {
    return @"{\
  \"version\":\"2.0\",\
  \"metadata\":{\
    \"apiVersion\":\"2014-06-30\",\
    \"endpointPrefix\":\"cognito-identity\",\
    \"jsonVersion\":\"1.1\",\
    \"protocol\":\"json\",\
    \"serviceFullName\":\"Amazon Cognito Identity\",\
    \"serviceId\":\"Cognito Identity\",\
    \"signatureVersion\":\"v4\",\
    \"targetPrefix\":\"AWSCognitoIdentityService\",\
    \"uid\":\"cognito-identity-2014-06-30\"\
  },\
  \"operations\":{\
    \"CreateIdentityPool\":{\
      \"name\":\"CreateIdentityPool\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"CreateIdentityPoolInput\"},\
      \"output\":{\"shape\":\"IdentityPool\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"LimitExceededException\"}\
      ],\
      \"documentation\":\"<p>Creates a new identity pool. The identity pool is a store of user identity information that is specific to your AWS account. The keys for <code>SupportedLoginProviders</code> are as follows:</p> <ul> <li> <p>Facebook: <code>graph.facebook.com</code> </p> </li> <li> <p>Google: <code>accounts.google.com</code> </p> </li> <li> <p>Amazon: <code>www.amazon.com</code> </p> </li> <li> <p>Twitter: <code>api.twitter.com</code> </p> </li> <li> <p>Digits: <code>www.digits.com</code> </p> </li> </ul> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"DeleteIdentities\":{\
      \"name\":\"DeleteIdentities\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"DeleteIdentitiesInput\"},\
      \"output\":{\"shape\":\"DeleteIdentitiesResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Deletes identities from an identity pool. You can specify a list of 1-60 identities that you want to delete.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"DeleteIdentityPool\":{\
      \"name\":\"DeleteIdentityPool\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"DeleteIdentityPoolInput\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Deletes an identity pool. Once a pool is deleted, users will not be able to authenticate with the pool.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"DescribeIdentity\":{\
      \"name\":\"DescribeIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"DescribeIdentityInput\"},\
      \"output\":{\"shape\":\"IdentityDescription\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Returns metadata related to the given identity, including when the identity was created and any associated linked logins.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"DescribeIdentityPool\":{\
      \"name\":\"DescribeIdentityPool\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"DescribeIdentityPoolInput\"},\
      \"output\":{\"shape\":\"IdentityPool\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Gets details about a particular identity pool, including the pool name, ID description, creation date, and current number of users.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"GetCredentialsForIdentity\":{\
      \"name\":\"GetCredentialsForIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetCredentialsForIdentityInput\"},\
      \"output\":{\"shape\":\"GetCredentialsForIdentityResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InvalidIdentityPoolConfigurationException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"ExternalServiceException\"}\
      ],\
      \"documentation\":\"<p>Returns credentials for the provided identity ID. Any provided logins will be validated against supported login providers. If the token is for cognito-identity.amazonaws.com, it will be passed through to AWS Security Token Service with the appropriate role for the token.</p> <p>This is a public API. You do not need any credentials to call this API.</p>\",\
      \"authtype\":\"none\"\
    },\
    \"GetId\":{\
      \"name\":\"GetId\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetIdInput\"},\
      \"output\":{\"shape\":\"GetIdResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"LimitExceededException\"},\
        {\"shape\":\"ExternalServiceException\"}\
      ],\
      \"documentation\":\"<p>Generates (or retrieves) a Cognito ID. Supplying multiple logins will create an implicit linked account.</p> <p>This is a public API. You do not need any credentials to call this API.</p>\",\
      \"authtype\":\"none\"\
    },\
    \"GetIdentityPoolRoles\":{\
      \"name\":\"GetIdentityPoolRoles\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetIdentityPoolRolesInput\"},\
      \"output\":{\"shape\":\"GetIdentityPoolRolesResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Gets the roles for an identity pool.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"GetOpenIdToken\":{\
      \"name\":\"GetOpenIdToken\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetOpenIdTokenInput\"},\
      \"output\":{\"shape\":\"GetOpenIdTokenResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"ExternalServiceException\"}\
      ],\
      \"documentation\":\"<p>Gets an OpenID token, using a known Cognito ID. This known Cognito ID is returned by <a>GetId</a>. You can optionally add additional logins for the identity. Supplying multiple logins creates an implicit link.</p> <p>The OpenID token is valid for 10 minutes.</p> <p>This is a public API. You do not need any credentials to call this API.</p>\",\
      \"authtype\":\"none\"\
    },\
    \"GetOpenIdTokenForDeveloperIdentity\":{\
      \"name\":\"GetOpenIdTokenForDeveloperIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetOpenIdTokenForDeveloperIdentityInput\"},\
      \"output\":{\"shape\":\"GetOpenIdTokenForDeveloperIdentityResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"DeveloperUserAlreadyRegisteredException\"}\
      ],\
      \"documentation\":\"<p>Registers (or retrieves) a Cognito <code>IdentityId</code> and an OpenID Connect token for a user authenticated by your backend authentication process. Supplying multiple logins will create an implicit linked account. You can only specify one developer provider as part of the <code>Logins</code> map, which is linked to the identity pool. The developer provider is the \\\"domain\\\" by which Cognito will refer to your users.</p> <p>You can use <code>GetOpenIdTokenForDeveloperIdentity</code> to create a new identity and to link new logins (that is, user credentials issued by a public provider or developer provider) to an existing identity. When you want to create a new identity, the <code>IdentityId</code> should be null. When you want to associate a new login with an existing authenticated/unauthenticated identity, you can do so by providing the existing <code>IdentityId</code>. This API will create the identity in the specified <code>IdentityPoolId</code>.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"GetPrincipalTagAttributeMap\":{\
      \"name\":\"GetPrincipalTagAttributeMap\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"GetPrincipalTagAttributeMapInput\"},\
      \"output\":{\"shape\":\"GetPrincipalTagAttributeMapResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Use <code>GetPrincipalTagAttributeMap</code> to list all mappings between <code>PrincipalTags</code> and user attributes.</p>\"\
    },\
    \"ListIdentities\":{\
      \"name\":\"ListIdentities\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"ListIdentitiesInput\"},\
      \"output\":{\"shape\":\"ListIdentitiesResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Lists the identities in an identity pool.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"ListIdentityPools\":{\
      \"name\":\"ListIdentityPools\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"ListIdentityPoolsInput\"},\
      \"output\":{\"shape\":\"ListIdentityPoolsResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Lists all of the Cognito identity pools registered for your account.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"ListTagsForResource\":{\
      \"name\":\"ListTagsForResource\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"ListTagsForResourceInput\"},\
      \"output\":{\"shape\":\"ListTagsForResourceResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Lists the tags that are assigned to an Amazon Cognito identity pool.</p> <p>A tag is a label that you can apply to identity pools to categorize and manage them in different ways, such as by purpose, owner, environment, or other criteria.</p> <p>You can use this action up to 10 times per second, per account.</p>\"\
    },\
    \"LookupDeveloperIdentity\":{\
      \"name\":\"LookupDeveloperIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"LookupDeveloperIdentityInput\"},\
      \"output\":{\"shape\":\"LookupDeveloperIdentityResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Retrieves the <code>IdentityID</code> associated with a <code>DeveloperUserIdentifier</code> or the list of <code>DeveloperUserIdentifier</code> values associated with an <code>IdentityId</code> for an existing identity. Either <code>IdentityID</code> or <code>DeveloperUserIdentifier</code> must not be null. If you supply only one of these values, the other value will be searched in the database and returned as a part of the response. If you supply both, <code>DeveloperUserIdentifier</code> will be matched against <code>IdentityID</code>. If the values are verified against the database, the response returns both values and is the same as the request. Otherwise a <code>ResourceConflictException</code> is thrown.</p> <p> <code>LookupDeveloperIdentity</code> is intended for low-throughput control plane operations: for example, to enable customer service to locate an identity ID by username. If you are using it for higher-volume operations such as user authentication, your requests are likely to be throttled. <a>GetOpenIdTokenForDeveloperIdentity</a> is a better option for higher-volume operations for user authentication.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"MergeDeveloperIdentities\":{\
      \"name\":\"MergeDeveloperIdentities\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"MergeDeveloperIdentitiesInput\"},\
      \"output\":{\"shape\":\"MergeDeveloperIdentitiesResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Merges two users having different <code>IdentityId</code>s, existing in the same identity pool, and identified by the same developer provider. You can use this action to request that discrete users be merged and identified as a single user in the Cognito environment. Cognito associates the given source user (<code>SourceUserIdentifier</code>) with the <code>IdentityId</code> of the <code>DestinationUserIdentifier</code>. Only developer-authenticated users can be merged. If the users to be merged are associated with the same public provider, but as two different users, an exception will be thrown.</p> <p>The number of linked logins is limited to 20. So, the number of linked logins for the source user, <code>SourceUserIdentifier</code>, and the destination user, <code>DestinationUserIdentifier</code>, together should not be larger than 20. Otherwise, an exception will be thrown.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"SetIdentityPoolRoles\":{\
      \"name\":\"SetIdentityPoolRoles\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"SetIdentityPoolRolesInput\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"ConcurrentModificationException\"}\
      ],\
      \"documentation\":\"<p>Sets the roles for an identity pool. These roles are used when making calls to <a>GetCredentialsForIdentity</a> action.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"SetPrincipalTagAttributeMap\":{\
      \"name\":\"SetPrincipalTagAttributeMap\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"SetPrincipalTagAttributeMapInput\"},\
      \"output\":{\"shape\":\"SetPrincipalTagAttributeMapResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>You can use this operation to use default (username and clientID) attribute or custom attribute mappings.</p>\"\
    },\
    \"TagResource\":{\
      \"name\":\"TagResource\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"TagResourceInput\"},\
      \"output\":{\"shape\":\"TagResourceResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Assigns a set of tags to the specified Amazon Cognito identity pool. A tag is a label that you can use to categorize and manage identity pools in different ways, such as by purpose, owner, environment, or other criteria.</p> <p>Each tag consists of a key and value, both of which you define. A key is a general category for more specific values. For example, if you have two versions of an identity pool, one for testing and another for production, you might assign an <code>Environment</code> tag key to both identity pools. The value of this key might be <code>Test</code> for one identity pool and <code>Production</code> for the other.</p> <p>Tags are useful for cost tracking and access control. You can activate your tags so that they appear on the Billing and Cost Management console, where you can track the costs associated with your identity pools. In an IAM policy, you can constrain permissions for identity pools based on specific tags or tag values.</p> <p>You can use this action up to 5 times per second, per account. An identity pool can have as many as 50 tags.</p>\"\
    },\
    \"UnlinkDeveloperIdentity\":{\
      \"name\":\"UnlinkDeveloperIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"UnlinkDeveloperIdentityInput\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Unlinks a <code>DeveloperUserIdentifier</code> from an existing identity. Unlinked developer users will be considered new identities next time they are seen. If, for a given Cognito identity, you remove all federated identities as well as the developer user identifier, the Cognito identity becomes inaccessible.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    },\
    \"UnlinkIdentity\":{\
      \"name\":\"UnlinkIdentity\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"UnlinkIdentityInput\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"ExternalServiceException\"}\
      ],\
      \"documentation\":\"<p>Unlinks a federated identity from an existing account. Unlinked logins will be considered new identities next time they are seen. Removing the last linked login will make this identity inaccessible.</p> <p>This is a public API. You do not need any credentials to call this API.</p>\",\
      \"authtype\":\"none\"\
    },\
    \"UntagResource\":{\
      \"name\":\"UntagResource\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"UntagResourceInput\"},\
      \"output\":{\"shape\":\"UntagResourceResponse\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"}\
      ],\
      \"documentation\":\"<p>Removes the specified tags from the specified Amazon Cognito identity pool. You can use this action up to 5 times per second, per account</p>\"\
    },\
    \"UpdateIdentityPool\":{\
      \"name\":\"UpdateIdentityPool\",\
      \"http\":{\
        \"method\":\"POST\",\
        \"requestUri\":\"/\"\
      },\
      \"input\":{\"shape\":\"IdentityPool\"},\
      \"output\":{\"shape\":\"IdentityPool\"},\
      \"errors\":[\
        {\"shape\":\"InvalidParameterException\"},\
        {\"shape\":\"ResourceNotFoundException\"},\
        {\"shape\":\"NotAuthorizedException\"},\
        {\"shape\":\"ResourceConflictException\"},\
        {\"shape\":\"TooManyRequestsException\"},\
        {\"shape\":\"InternalErrorException\"},\
        {\"shape\":\"ConcurrentModificationException\"},\
        {\"shape\":\"LimitExceededException\"}\
      ],\
      \"documentation\":\"<p>Updates an identity pool.</p> <p>You must use AWS Developer credentials to call this API.</p>\"\
    }\
  },\
  \"shapes\":{\
    \"ARNString\":{\
      \"type\":\"string\",\
      \"max\":2048,\
      \"min\":20\
    },\
    \"AccessKeyString\":{\"type\":\"string\"},\
    \"AccountId\":{\
      \"type\":\"string\",\
      \"max\":15,\
      \"min\":1,\
      \"pattern\":\"\\\\d+\"\
    },\
    \"AmbiguousRoleResolutionType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"AuthenticatedRole\",\
        \"Deny\"\
      ]\
    },\
    \"ClaimName\":{\
      \"type\":\"string\",\
      \"max\":64,\
      \"min\":1,\
      \"pattern\":\"[\\\\p{L}\\\\p{M}\\\\p{S}\\\\p{N}\\\\p{P}]+\"\
    },\
    \"ClaimValue\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1\
    },\
    \"ClassicFlow\":{\"type\":\"boolean\"},\
    \"CognitoIdentityProvider\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"ProviderName\":{\
          \"shape\":\"CognitoIdentityProviderName\",\
          \"documentation\":\"<p>The provider name for an Amazon Cognito user pool. For example, <code>cognito-idp.us-east-1.amazonaws.com/us-east-1_123456789</code>.</p>\"\
        },\
        \"ClientId\":{\
          \"shape\":\"CognitoIdentityProviderClientId\",\
          \"documentation\":\"<p>The client ID for the Amazon Cognito user pool.</p>\"\
        },\
        \"ServerSideTokenCheck\":{\
          \"shape\":\"CognitoIdentityProviderTokenCheck\",\
          \"documentation\":\"<p>TRUE if server-side token validation is enabled for the identity providerâs token.</p> <p>Once you set <code>ServerSideTokenCheck</code> to TRUE for an identity pool, that identity pool will check with the integrated user pools to make sure that the user has not been globally signed out or deleted before the identity pool provides an OIDC token or AWS credentials for the user.</p> <p>If the user is signed out or deleted, the identity pool will return a 400 Not Authorized error.</p>\",\
          \"box\":true\
        }\
      },\
      \"documentation\":\"<p>A provider representing an Amazon Cognito user pool and its client ID.</p>\"\
    },\
    \"CognitoIdentityProviderClientId\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\w_]+\"\
    },\
    \"CognitoIdentityProviderList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"CognitoIdentityProvider\"}\
    },\
    \"CognitoIdentityProviderName\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\w._:/-]+\"\
    },\
    \"CognitoIdentityProviderTokenCheck\":{\"type\":\"boolean\"},\
    \"ConcurrentModificationException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by a ConcurrentModificationException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown if there are parallel requests to modify a resource.</p>\",\
      \"exception\":true\
    },\
    \"CreateIdentityPoolInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolName\",\
        \"AllowUnauthenticatedIdentities\"\
      ],\
      \"members\":{\
        \"IdentityPoolName\":{\
          \"shape\":\"IdentityPoolName\",\
          \"documentation\":\"<p>A string that you provide.</p>\"\
        },\
        \"AllowUnauthenticatedIdentities\":{\
          \"shape\":\"IdentityPoolUnauthenticated\",\
          \"documentation\":\"<p>TRUE if the identity pool supports unauthenticated logins.</p>\"\
        },\
        \"AllowClassicFlow\":{\
          \"shape\":\"ClassicFlow\",\
          \"documentation\":\"<p>Enables or disables the Basic (Classic) authentication flow. For more information, see <a href=\\\"https://docs.aws.amazon.com/cognito/latest/developerguide/authentication-flow.html\\\">Identity Pools (Federated Identities) Authentication Flow</a> in the <i>Amazon Cognito Developer Guide</i>.</p>\"\
        },\
        \"SupportedLoginProviders\":{\
          \"shape\":\"IdentityProviders\",\
          \"documentation\":\"<p>Optional key:value pairs mapping provider names to provider app IDs.</p>\"\
        },\
        \"DeveloperProviderName\":{\
          \"shape\":\"DeveloperProviderName\",\
          \"documentation\":\"<p>The \\\"domain\\\" by which Cognito will refer to your users. This name acts as a placeholder that allows your backend and the Cognito service to communicate about the developer provider. For the <code>DeveloperProviderName</code>, you can use letters as well as period (<code>.</code>), underscore (<code>_</code>), and dash (<code>-</code>).</p> <p>Once you have set a developer provider name, you cannot change it. Please take care in setting this parameter.</p>\"\
        },\
        \"OpenIdConnectProviderARNs\":{\
          \"shape\":\"OIDCProviderList\",\
          \"documentation\":\"<p>The Amazon Resource Names (ARN) of the OpenID Connect providers.</p>\"\
        },\
        \"CognitoIdentityProviders\":{\
          \"shape\":\"CognitoIdentityProviderList\",\
          \"documentation\":\"<p>An array of Amazon Cognito user pools and their client IDs.</p>\"\
        },\
        \"SamlProviderARNs\":{\
          \"shape\":\"SAMLProviderList\",\
          \"documentation\":\"<p>An array of Amazon Resource Names (ARNs) of the SAML provider for your identity pool.</p>\"\
        },\
        \"IdentityPoolTags\":{\
          \"shape\":\"IdentityPoolTagsType\",\
          \"documentation\":\"<p>Tags to assign to the identity pool. A tag is a label that you can apply to identity pools to categorize and manage them in different ways, such as by purpose, owner, environment, or other criteria.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the CreateIdentityPool action.</p>\"\
    },\
    \"Credentials\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"AccessKeyId\":{\
          \"shape\":\"AccessKeyString\",\
          \"documentation\":\"<p>The Access Key portion of the credentials.</p>\"\
        },\
        \"SecretKey\":{\
          \"shape\":\"SecretKeyString\",\
          \"documentation\":\"<p>The Secret Access Key portion of the credentials</p>\"\
        },\
        \"SessionToken\":{\
          \"shape\":\"SessionTokenString\",\
          \"documentation\":\"<p>The Session Token portion of the credentials</p>\"\
        },\
        \"Expiration\":{\
          \"shape\":\"DateType\",\
          \"documentation\":\"<p>The date at which these credentials will expire.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Credentials for the provided identity ID.</p>\"\
    },\
    \"DateType\":{\"type\":\"timestamp\"},\
    \"DeleteIdentitiesInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityIdsToDelete\"],\
      \"members\":{\
        \"IdentityIdsToDelete\":{\
          \"shape\":\"IdentityIdList\",\
          \"documentation\":\"<p>A list of 1-60 identities that you want to delete.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>DeleteIdentities</code> action.</p>\"\
    },\
    \"DeleteIdentitiesResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"UnprocessedIdentityIds\":{\
          \"shape\":\"UnprocessedIdentityIdList\",\
          \"documentation\":\"<p>An array of UnprocessedIdentityId objects, each of which contains an ErrorCode and IdentityId.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>DeleteIdentities</code> operation.</p>\"\
    },\
    \"DeleteIdentityPoolInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityPoolId\"],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the DeleteIdentityPool action.</p>\"\
    },\
    \"DescribeIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityId\"],\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>DescribeIdentity</code> action.</p>\"\
    },\
    \"DescribeIdentityPoolInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityPoolId\"],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the DescribeIdentityPool action.</p>\"\
    },\
    \"DeveloperProviderName\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\w._-]+\"\
    },\
    \"DeveloperUserAlreadyRegisteredException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>This developer user identifier is already registered with Cognito.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The provided developer user identifier is already registered with Cognito under a different identity ID.</p>\",\
      \"exception\":true\
    },\
    \"DeveloperUserIdentifier\":{\
      \"type\":\"string\",\
      \"max\":1024,\
      \"min\":1\
    },\
    \"DeveloperUserIdentifierList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"DeveloperUserIdentifier\"}\
    },\
    \"ErrorCode\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"AccessDenied\",\
        \"InternalServerError\"\
      ]\
    },\
    \"ExternalServiceException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by an ExternalServiceException</p>\"\
        }\
      },\
      \"documentation\":\"<p>An exception thrown when a dependent service such as Facebook or Twitter is not responding</p>\",\
      \"exception\":true\
    },\
    \"GetCredentialsForIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityId\"],\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsMap\",\
          \"documentation\":\"<p>A set of optional name-value pairs that map provider names to provider tokens. The name-value pair will follow the syntax \\\"provider_name\\\": \\\"provider_user_identifier\\\".</p> <p>Logins should not be specified when trying to get credentials for an unauthenticated identity.</p> <p>The Logins parameter is required when using identities associated with external identity providers such as Facebook. For examples of <code>Logins</code> maps, see the code examples in the <a href=\\\"https://docs.aws.amazon.com/cognito/latest/developerguide/external-identity-providers.html\\\">External Identity Providers</a> section of the Amazon Cognito Developer Guide.</p>\"\
        },\
        \"CustomRoleArn\":{\
          \"shape\":\"ARNString\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the role to be assumed when multiple roles were received in the token from the identity provider. For example, a SAML-based identity provider. This parameter is optional for identity providers that do not support role customization.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>GetCredentialsForIdentity</code> action.</p>\"\
    },\
    \"GetCredentialsForIdentityResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Credentials\":{\
          \"shape\":\"Credentials\",\
          \"documentation\":\"<p>Credentials for the provided identity ID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>GetCredentialsForIdentity</code> operation.</p>\"\
    },\
    \"GetIdInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityPoolId\"],\
      \"members\":{\
        \"AccountId\":{\
          \"shape\":\"AccountId\",\
          \"documentation\":\"<p>A standard AWS account ID (9+ digits).</p>\"\
        },\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsMap\",\
          \"documentation\":\"<p>A set of optional name-value pairs that map provider names to provider tokens. The available provider names for <code>Logins</code> are as follows:</p> <ul> <li> <p>Facebook: <code>graph.facebook.com</code> </p> </li> <li> <p>Amazon Cognito user pool: <code>cognito-idp.&lt;region&gt;.amazonaws.com/&lt;YOUR_USER_POOL_ID&gt;</code>, for example, <code>cognito-idp.us-east-1.amazonaws.com/us-east-1_123456789</code>. </p> </li> <li> <p>Google: <code>accounts.google.com</code> </p> </li> <li> <p>Amazon: <code>www.amazon.com</code> </p> </li> <li> <p>Twitter: <code>api.twitter.com</code> </p> </li> <li> <p>Digits: <code>www.digits.com</code> </p> </li> </ul>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the GetId action.</p>\"\
    },\
    \"GetIdResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a GetId request.</p>\"\
    },\
    \"GetIdentityPoolRolesInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityPoolId\"],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>GetIdentityPoolRoles</code> action.</p>\"\
    },\
    \"GetIdentityPoolRolesResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"Roles\":{\
          \"shape\":\"RolesMap\",\
          \"documentation\":\"<p>The map of roles associated with this pool. Currently only authenticated and unauthenticated roles are supported.</p>\"\
        },\
        \"RoleMappings\":{\
          \"shape\":\"RoleMappingMap\",\
          \"documentation\":\"<p>How users for a specific identity provider are to mapped to roles. This is a String-to-<a>RoleMapping</a> object map. The string identifies the identity provider, for example, \\\"graph.facebook.com\\\" or \\\"cognito-idp.us-east-1.amazonaws.com/us-east-1_abcdefghi:app_client_id\\\".</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>GetIdentityPoolRoles</code> operation.</p>\"\
    },\
    \"GetOpenIdTokenForDeveloperIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"Logins\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsMap\",\
          \"documentation\":\"<p>A set of optional name-value pairs that map provider names to provider tokens. Each name-value pair represents a user from a public provider or developer provider. If the user is from a developer provider, the name-value pair will follow the syntax <code>\\\"developer_provider_name\\\": \\\"developer_user_identifier\\\"</code>. The developer provider is the \\\"domain\\\" by which Cognito will refer to your users; you provided this domain while creating/updating the identity pool. The developer user identifier is an identifier from your backend that uniquely identifies a user. When you create an identity pool, you can specify the supported logins.</p>\"\
        },\
        \"PrincipalTags\":{\
          \"shape\":\"PrincipalTags\",\
          \"documentation\":\"<p>Use this operation to configure attribute mappings for custom providers. </p>\"\
        },\
        \"TokenDuration\":{\
          \"shape\":\"TokenDuration\",\
          \"documentation\":\"<p>The expiration time of the token, in seconds. You can specify a custom expiration time for the token so that you can cache it. If you don't provide an expiration time, the token is valid for 15 minutes. You can exchange the token with Amazon STS for temporary AWS credentials, which are valid for a maximum of one hour. The maximum token duration you can set is 24 hours. You should take care in setting the expiration time for a token, as there are significant security implications: an attacker could use a leaked token to access your AWS resources for the token's duration.</p> <note> <p>Please provide for a small grace period, usually no more than 5 minutes, to account for clock skew.</p> </note>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>GetOpenIdTokenForDeveloperIdentity</code> action.</p>\"\
    },\
    \"GetOpenIdTokenForDeveloperIdentityResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Token\":{\
          \"shape\":\"OIDCToken\",\
          \"documentation\":\"<p>An OpenID token.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>GetOpenIdTokenForDeveloperIdentity</code> request.</p>\"\
    },\
    \"GetOpenIdTokenInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityId\"],\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsMap\",\
          \"documentation\":\"<p>A set of optional name-value pairs that map provider names to provider tokens. When using graph.facebook.com and www.amazon.com, supply the access_token returned from the provider's authflow. For accounts.google.com, an Amazon Cognito user pool provider, or any other OpenID Connect provider, always include the <code>id_token</code>.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the GetOpenIdToken action.</p>\"\
    },\
    \"GetOpenIdTokenResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID. Note that the IdentityId returned may not match the one passed on input.</p>\"\
        },\
        \"Token\":{\
          \"shape\":\"OIDCToken\",\
          \"documentation\":\"<p>An OpenID token, valid for 10 minutes.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful GetOpenIdToken request.</p>\"\
    },\
    \"GetPrincipalTagAttributeMapInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"IdentityProviderName\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>You can use this operation to get the ID of the Identity Pool you setup attribute mappings for.</p>\"\
        },\
        \"IdentityProviderName\":{\
          \"shape\":\"IdentityProviderName\",\
          \"documentation\":\"<p>You can use this operation to get the provider name.</p>\"\
        }\
      }\
    },\
    \"GetPrincipalTagAttributeMapResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>You can use this operation to get the ID of the Identity Pool you setup attribute mappings for.</p>\"\
        },\
        \"IdentityProviderName\":{\
          \"shape\":\"IdentityProviderName\",\
          \"documentation\":\"<p>You can use this operation to get the provider name.</p>\"\
        },\
        \"UseDefaults\":{\
          \"shape\":\"UseDefaults\",\
          \"documentation\":\"<p>You can use this operation to list </p>\"\
        },\
        \"PrincipalTags\":{\
          \"shape\":\"PrincipalTags\",\
          \"documentation\":\"<p>You can use this operation to add principal tags. The <code>PrincipalTags</code>operation enables you to reference user attributes in your IAM permissions policy.</p>\"\
        }\
      }\
    },\
    \"HideDisabled\":{\"type\":\"boolean\"},\
    \"IdentitiesList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"IdentityDescription\"}\
    },\
    \"IdentityDescription\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsList\",\
          \"documentation\":\"<p>The provider names.</p>\"\
        },\
        \"CreationDate\":{\
          \"shape\":\"DateType\",\
          \"documentation\":\"<p>Date on which the identity was created.</p>\"\
        },\
        \"LastModifiedDate\":{\
          \"shape\":\"DateType\",\
          \"documentation\":\"<p>Date on which the identity was last modified.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A description of the identity.</p>\"\
    },\
    \"IdentityId\":{\
      \"type\":\"string\",\
      \"max\":55,\
      \"min\":1,\
      \"pattern\":\"[\\\\w-]+:[0-9a-f-]+\"\
    },\
    \"IdentityIdList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"IdentityId\"},\
      \"max\":60,\
      \"min\":1\
    },\
    \"IdentityPool\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"IdentityPoolName\",\
        \"AllowUnauthenticatedIdentities\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"IdentityPoolName\":{\
          \"shape\":\"IdentityPoolName\",\
          \"documentation\":\"<p>A string that you provide.</p>\"\
        },\
        \"AllowUnauthenticatedIdentities\":{\
          \"shape\":\"IdentityPoolUnauthenticated\",\
          \"documentation\":\"<p>TRUE if the identity pool supports unauthenticated logins.</p>\"\
        },\
        \"AllowClassicFlow\":{\
          \"shape\":\"ClassicFlow\",\
          \"documentation\":\"<p>Enables or disables the Basic (Classic) authentication flow. For more information, see <a href=\\\"https://docs.aws.amazon.com/cognito/latest/developerguide/authentication-flow.html\\\">Identity Pools (Federated Identities) Authentication Flow</a> in the <i>Amazon Cognito Developer Guide</i>.</p>\"\
        },\
        \"SupportedLoginProviders\":{\
          \"shape\":\"IdentityProviders\",\
          \"documentation\":\"<p>Optional key:value pairs mapping provider names to provider app IDs.</p>\"\
        },\
        \"DeveloperProviderName\":{\
          \"shape\":\"DeveloperProviderName\",\
          \"documentation\":\"<p>The \\\"domain\\\" by which Cognito will refer to your users.</p>\"\
        },\
        \"OpenIdConnectProviderARNs\":{\
          \"shape\":\"OIDCProviderList\",\
          \"documentation\":\"<p>The ARNs of the OpenID Connect providers.</p>\"\
        },\
        \"CognitoIdentityProviders\":{\
          \"shape\":\"CognitoIdentityProviderList\",\
          \"documentation\":\"<p>A list representing an Amazon Cognito user pool and its client ID.</p>\"\
        },\
        \"SamlProviderARNs\":{\
          \"shape\":\"SAMLProviderList\",\
          \"documentation\":\"<p>An array of Amazon Resource Names (ARNs) of the SAML provider for your identity pool.</p>\"\
        },\
        \"IdentityPoolTags\":{\
          \"shape\":\"IdentityPoolTagsType\",\
          \"documentation\":\"<p>The tags that are assigned to the identity pool. A tag is a label that you can apply to identity pools to categorize and manage them in different ways, such as by purpose, owner, environment, or other criteria.</p>\"\
        }\
      },\
      \"documentation\":\"<p>An object representing an Amazon Cognito identity pool.</p>\"\
    },\
    \"IdentityPoolId\":{\
      \"type\":\"string\",\
      \"max\":55,\
      \"min\":1,\
      \"pattern\":\"[\\\\w-]+:[0-9a-f-]+\"\
    },\
    \"IdentityPoolName\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\w\\\\s+=,.@-]+\"\
    },\
    \"IdentityPoolShortDescription\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"IdentityPoolName\":{\
          \"shape\":\"IdentityPoolName\",\
          \"documentation\":\"<p>A string that you provide.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A description of the identity pool.</p>\"\
    },\
    \"IdentityPoolTagsListType\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"TagKeysType\"}\
    },\
    \"IdentityPoolTagsType\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"TagKeysType\"},\
      \"value\":{\"shape\":\"TagValueType\"}\
    },\
    \"IdentityPoolUnauthenticated\":{\"type\":\"boolean\"},\
    \"IdentityPoolsList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"IdentityPoolShortDescription\"}\
    },\
    \"IdentityProviderId\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"[\\\\w.;_/-]+\"\
    },\
    \"IdentityProviderName\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1\
    },\
    \"IdentityProviderToken\":{\
      \"type\":\"string\",\
      \"max\":50000,\
      \"min\":1\
    },\
    \"IdentityProviders\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"IdentityProviderName\"},\
      \"value\":{\"shape\":\"IdentityProviderId\"},\
      \"max\":10\
    },\
    \"InternalErrorException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by an InternalErrorException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when the service encounters an error during processing the request.</p>\",\
      \"exception\":true,\
      \"fault\":true\
    },\
    \"InvalidIdentityPoolConfigurationException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned for an <code>InvalidIdentityPoolConfigurationException</code> </p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown if the identity pool has no role associated for the given auth type (auth/unauth) or if the AssumeRole fails.</p>\",\
      \"exception\":true\
    },\
    \"InvalidParameterException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by an InvalidParameterException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown for missing or bad input parameter(s).</p>\",\
      \"exception\":true\
    },\
    \"LimitExceededException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by a LimitExceededException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when the total number of user pools has exceeded a preset limit.</p>\",\
      \"exception\":true\
    },\
    \"ListIdentitiesInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"MaxResults\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"MaxResults\":{\
          \"shape\":\"QueryLimit\",\
          \"documentation\":\"<p>The maximum number of identities to return.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token.</p>\"\
        },\
        \"HideDisabled\":{\
          \"shape\":\"HideDisabled\",\
          \"documentation\":\"<p>An optional boolean parameter that allows you to hide disabled identities. If omitted, the ListIdentities API will include disabled identities in the response.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the ListIdentities action.</p>\"\
    },\
    \"ListIdentitiesResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"Identities\":{\
          \"shape\":\"IdentitiesList\",\
          \"documentation\":\"<p>An object containing a set of identities and associated mappings.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The response to a ListIdentities request.</p>\"\
    },\
    \"ListIdentityPoolsInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"MaxResults\"],\
      \"members\":{\
        \"MaxResults\":{\
          \"shape\":\"QueryLimit\",\
          \"documentation\":\"<p>The maximum number of identities to return.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the ListIdentityPools action.</p>\"\
    },\
    \"ListIdentityPoolsResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPools\":{\
          \"shape\":\"IdentityPoolsList\",\
          \"documentation\":\"<p>The identity pools returned by the ListIdentityPools action.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token.</p>\"\
        }\
      },\
      \"documentation\":\"<p>The result of a successful ListIdentityPools action.</p>\"\
    },\
    \"ListTagsForResourceInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"ResourceArn\"],\
      \"members\":{\
        \"ResourceArn\":{\
          \"shape\":\"ARNString\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the identity pool that the tags are assigned to.</p>\"\
        }\
      }\
    },\
    \"ListTagsForResourceResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"Tags\":{\
          \"shape\":\"IdentityPoolTagsType\",\
          \"documentation\":\"<p>The tags that are assigned to the identity pool.</p>\"\
        }\
      }\
    },\
    \"LoginsList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"IdentityProviderName\"}\
    },\
    \"LoginsMap\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"IdentityProviderName\"},\
      \"value\":{\"shape\":\"IdentityProviderToken\"},\
      \"max\":10\
    },\
    \"LookupDeveloperIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\"IdentityPoolId\"],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"DeveloperUserIdentifier\":{\
          \"shape\":\"DeveloperUserIdentifier\",\
          \"documentation\":\"<p>A unique ID used by your backend authentication process to identify a user. Typically, a developer identity provider would issue many developer user identifiers, in keeping with the number of users.</p>\"\
        },\
        \"MaxResults\":{\
          \"shape\":\"QueryLimit\",\
          \"documentation\":\"<p>The maximum number of identities to return.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token. The first call you make will have <code>NextToken</code> set to null. After that the service will return <code>NextToken</code> values as needed. For example, let's say you make a request with <code>MaxResults</code> set to 10, and there are 20 matches in the database. The service will return a pagination token as a part of the response. This token can be used to call the API again and get results starting from the 11th match.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>LookupDeveloperIdentityInput</code> action.</p>\"\
    },\
    \"LookupDeveloperIdentityResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"DeveloperUserIdentifierList\":{\
          \"shape\":\"DeveloperUserIdentifierList\",\
          \"documentation\":\"<p>This is the list of developer user identifiers associated with an identity ID. Cognito supports the association of multiple developer user identifiers with an identity ID.</p>\"\
        },\
        \"NextToken\":{\
          \"shape\":\"PaginationKey\",\
          \"documentation\":\"<p>A pagination token. The first call you make will have <code>NextToken</code> set to null. After that the service will return <code>NextToken</code> values as needed. For example, let's say you make a request with <code>MaxResults</code> set to 10, and there are 20 matches in the database. The service will return a pagination token as a part of the response. This token can be used to call the API again and get results starting from the 11th match.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>LookupDeveloperIdentity</code> action.</p>\"\
    },\
    \"MappingRule\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"Claim\",\
        \"MatchType\",\
        \"Value\",\
        \"RoleARN\"\
      ],\
      \"members\":{\
        \"Claim\":{\
          \"shape\":\"ClaimName\",\
          \"documentation\":\"<p>The claim name that must be present in the token, for example, \\\"isAdmin\\\" or \\\"paid\\\".</p>\"\
        },\
        \"MatchType\":{\
          \"shape\":\"MappingRuleMatchType\",\
          \"documentation\":\"<p>The match condition that specifies how closely the claim value in the IdP token must match <code>Value</code>.</p>\"\
        },\
        \"Value\":{\
          \"shape\":\"ClaimValue\",\
          \"documentation\":\"<p>A brief string that the claim must match, for example, \\\"paid\\\" or \\\"yes\\\".</p>\"\
        },\
        \"RoleARN\":{\
          \"shape\":\"ARNString\",\
          \"documentation\":\"<p>The role ARN.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A rule that maps a claim name, a claim value, and a match type to a role ARN.</p>\"\
    },\
    \"MappingRuleMatchType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Equals\",\
        \"Contains\",\
        \"StartsWith\",\
        \"NotEqual\"\
      ]\
    },\
    \"MappingRulesList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"MappingRule\"},\
      \"max\":400,\
      \"min\":1\
    },\
    \"MergeDeveloperIdentitiesInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"SourceUserIdentifier\",\
        \"DestinationUserIdentifier\",\
        \"DeveloperProviderName\",\
        \"IdentityPoolId\"\
      ],\
      \"members\":{\
        \"SourceUserIdentifier\":{\
          \"shape\":\"DeveloperUserIdentifier\",\
          \"documentation\":\"<p>User identifier for the source user. The value should be a <code>DeveloperUserIdentifier</code>.</p>\"\
        },\
        \"DestinationUserIdentifier\":{\
          \"shape\":\"DeveloperUserIdentifier\",\
          \"documentation\":\"<p>User identifier for the destination user. The value should be a <code>DeveloperUserIdentifier</code>.</p>\"\
        },\
        \"DeveloperProviderName\":{\
          \"shape\":\"DeveloperProviderName\",\
          \"documentation\":\"<p>The \\\"domain\\\" by which Cognito will refer to your users. This is a (pseudo) domain name that you provide while creating an identity pool. This name acts as a placeholder that allows your backend and the Cognito service to communicate about the developer provider. For the <code>DeveloperProviderName</code>, you can use letters as well as period (.), underscore (_), and dash (-).</p>\"\
        },\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>MergeDeveloperIdentities</code> action.</p>\"\
    },\
    \"MergeDeveloperIdentitiesResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Returned in response to a successful <code>MergeDeveloperIdentities</code> action.</p>\"\
    },\
    \"NotAuthorizedException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by a NotAuthorizedException</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when a user is not authorized to access the requested resource.</p>\",\
      \"exception\":true\
    },\
    \"OIDCProviderList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ARNString\"}\
    },\
    \"OIDCToken\":{\"type\":\"string\"},\
    \"PaginationKey\":{\
      \"type\":\"string\",\
      \"max\":65535,\
      \"min\":1,\
      \"pattern\":\"[\\\\S]+\"\
    },\
    \"PrincipalTagID\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1\
    },\
    \"PrincipalTagValue\":{\
      \"type\":\"string\",\
      \"max\":256,\
      \"min\":1\
    },\
    \"PrincipalTags\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"PrincipalTagID\"},\
      \"value\":{\"shape\":\"PrincipalTagValue\"},\
      \"max\":50\
    },\
    \"QueryLimit\":{\
      \"type\":\"integer\",\
      \"max\":60,\
      \"min\":1\
    },\
    \"ResourceConflictException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by a ResourceConflictException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when a user tries to use a login which is already linked to another account.</p>\",\
      \"exception\":true\
    },\
    \"ResourceNotFoundException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>The message returned by a ResourceNotFoundException.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when the requested resource (for example, a dataset or record) does not exist.</p>\",\
      \"exception\":true\
    },\
    \"RoleMapping\":{\
      \"type\":\"structure\",\
      \"required\":[\"Type\"],\
      \"members\":{\
        \"Type\":{\
          \"shape\":\"RoleMappingType\",\
          \"documentation\":\"<p>The role mapping type. Token will use <code>cognito:roles</code> and <code>cognito:preferred_role</code> claims from the Cognito identity provider token to map groups to roles. Rules will attempt to match claims from the token to map to a role.</p>\"\
        },\
        \"AmbiguousRoleResolution\":{\
          \"shape\":\"AmbiguousRoleResolutionType\",\
          \"documentation\":\"<p>If you specify Token or Rules as the <code>Type</code>, <code>AmbiguousRoleResolution</code> is required.</p> <p>Specifies the action to be taken if either no rules match the claim value for the <code>Rules</code> type, or there is no <code>cognito:preferred_role</code> claim and there are multiple <code>cognito:roles</code> matches for the <code>Token</code> type.</p>\"\
        },\
        \"RulesConfiguration\":{\
          \"shape\":\"RulesConfigurationType\",\
          \"documentation\":\"<p>The rules to be used for mapping users to roles.</p> <p>If you specify Rules as the role mapping type, <code>RulesConfiguration</code> is required.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A role mapping.</p>\"\
    },\
    \"RoleMappingMap\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"IdentityProviderName\"},\
      \"value\":{\"shape\":\"RoleMapping\"},\
      \"max\":10\
    },\
    \"RoleMappingType\":{\
      \"type\":\"string\",\
      \"enum\":[\
        \"Token\",\
        \"Rules\"\
      ]\
    },\
    \"RoleType\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1,\
      \"pattern\":\"(un)?authenticated\"\
    },\
    \"RolesMap\":{\
      \"type\":\"map\",\
      \"key\":{\"shape\":\"RoleType\"},\
      \"value\":{\"shape\":\"ARNString\"},\
      \"max\":2\
    },\
    \"RulesConfigurationType\":{\
      \"type\":\"structure\",\
      \"required\":[\"Rules\"],\
      \"members\":{\
        \"Rules\":{\
          \"shape\":\"MappingRulesList\",\
          \"documentation\":\"<p>An array of rules. You can specify up to 25 rules per identity provider.</p> <p>Rules are evaluated in order. The first one to match specifies the role.</p>\"\
        }\
      },\
      \"documentation\":\"<p>A container for rules.</p>\"\
    },\
    \"SAMLProviderList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"ARNString\"}\
    },\
    \"SecretKeyString\":{\"type\":\"string\"},\
    \"SessionTokenString\":{\"type\":\"string\"},\
    \"SetIdentityPoolRolesInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"Roles\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"Roles\":{\
          \"shape\":\"RolesMap\",\
          \"documentation\":\"<p>The map of roles associated with this pool. For a given role, the key will be either \\\"authenticated\\\" or \\\"unauthenticated\\\" and the value will be the Role ARN.</p>\"\
        },\
        \"RoleMappings\":{\
          \"shape\":\"RoleMappingMap\",\
          \"documentation\":\"<p>How users for a specific identity provider are to mapped to roles. This is a string to <a>RoleMapping</a> object map. The string identifies the identity provider, for example, \\\"graph.facebook.com\\\" or \\\"cognito-idp.us-east-1.amazonaws.com/us-east-1_abcdefghi:app_client_id\\\".</p> <p>Up to 25 rules can be specified per identity provider.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>SetIdentityPoolRoles</code> action.</p>\"\
    },\
    \"SetPrincipalTagAttributeMapInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityPoolId\",\
        \"IdentityProviderName\"\
      ],\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>The ID of the Identity Pool you want to set attribute mappings for.</p>\"\
        },\
        \"IdentityProviderName\":{\
          \"shape\":\"IdentityProviderName\",\
          \"documentation\":\"<p>The provider name you want to use for attribute mappings.</p>\"\
        },\
        \"UseDefaults\":{\
          \"shape\":\"UseDefaults\",\
          \"documentation\":\"<p>You can use this operation to use default (username and clientID) attribute mappings.</p>\"\
        },\
        \"PrincipalTags\":{\
          \"shape\":\"PrincipalTags\",\
          \"documentation\":\"<p>You can use this operation to add principal tags.</p>\"\
        }\
      }\
    },\
    \"SetPrincipalTagAttributeMapResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>The ID of the Identity Pool you want to set attribute mappings for.</p>\"\
        },\
        \"IdentityProviderName\":{\
          \"shape\":\"IdentityProviderName\",\
          \"documentation\":\"<p>The provider name you want to use for attribute mappings.</p>\"\
        },\
        \"UseDefaults\":{\
          \"shape\":\"UseDefaults\",\
          \"documentation\":\"<p>You can use this operation to select default (username and clientID) attribute mappings.</p>\"\
        },\
        \"PrincipalTags\":{\
          \"shape\":\"PrincipalTags\",\
          \"documentation\":\"<p>You can use this operation to add principal tags. The <code>PrincipalTags</code>operation enables you to reference user attributes in your IAM permissions policy.</p>\"\
        }\
      }\
    },\
    \"String\":{\"type\":\"string\"},\
    \"TagKeysType\":{\
      \"type\":\"string\",\
      \"max\":128,\
      \"min\":1\
    },\
    \"TagResourceInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"ResourceArn\",\
        \"Tags\"\
      ],\
      \"members\":{\
        \"ResourceArn\":{\
          \"shape\":\"ARNString\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the identity pool.</p>\"\
        },\
        \"Tags\":{\
          \"shape\":\"IdentityPoolTagsType\",\
          \"documentation\":\"<p>The tags to assign to the identity pool.</p>\"\
        }\
      }\
    },\
    \"TagResourceResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
      }\
    },\
    \"TagValueType\":{\
      \"type\":\"string\",\
      \"max\":256,\
      \"min\":0\
    },\
    \"TokenDuration\":{\
      \"type\":\"long\",\
      \"max\":86400,\
      \"min\":1\
    },\
    \"TooManyRequestsException\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"message\":{\
          \"shape\":\"String\",\
          \"documentation\":\"<p>Message returned by a TooManyRequestsException</p>\"\
        }\
      },\
      \"documentation\":\"<p>Thrown when a request is throttled.</p>\",\
      \"exception\":true\
    },\
    \"UnlinkDeveloperIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityId\",\
        \"IdentityPoolId\",\
        \"DeveloperProviderName\",\
        \"DeveloperUserIdentifier\"\
      ],\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"IdentityPoolId\":{\
          \"shape\":\"IdentityPoolId\",\
          \"documentation\":\"<p>An identity pool ID in the format REGION:GUID.</p>\"\
        },\
        \"DeveloperProviderName\":{\
          \"shape\":\"DeveloperProviderName\",\
          \"documentation\":\"<p>The \\\"domain\\\" by which Cognito will refer to your users.</p>\"\
        },\
        \"DeveloperUserIdentifier\":{\
          \"shape\":\"DeveloperUserIdentifier\",\
          \"documentation\":\"<p>A unique ID used by your backend authentication process to identify a user.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the <code>UnlinkDeveloperIdentity</code> action.</p>\"\
    },\
    \"UnlinkIdentityInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"IdentityId\",\
        \"Logins\",\
        \"LoginsToRemove\"\
      ],\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"Logins\":{\
          \"shape\":\"LoginsMap\",\
          \"documentation\":\"<p>A set of optional name-value pairs that map provider names to provider tokens.</p>\"\
        },\
        \"LoginsToRemove\":{\
          \"shape\":\"LoginsList\",\
          \"documentation\":\"<p>Provider names to unlink from this identity.</p>\"\
        }\
      },\
      \"documentation\":\"<p>Input to the UnlinkIdentity action.</p>\"\
    },\
    \"UnprocessedIdentityId\":{\
      \"type\":\"structure\",\
      \"members\":{\
        \"IdentityId\":{\
          \"shape\":\"IdentityId\",\
          \"documentation\":\"<p>A unique identifier in the format REGION:GUID.</p>\"\
        },\
        \"ErrorCode\":{\
          \"shape\":\"ErrorCode\",\
          \"documentation\":\"<p>The error code indicating the type of error that occurred.</p>\"\
        }\
      },\
      \"documentation\":\"<p>An array of UnprocessedIdentityId objects, each of which contains an ErrorCode and IdentityId.</p>\"\
    },\
    \"UnprocessedIdentityIdList\":{\
      \"type\":\"list\",\
      \"member\":{\"shape\":\"UnprocessedIdentityId\"},\
      \"max\":60\
    },\
    \"UntagResourceInput\":{\
      \"type\":\"structure\",\
      \"required\":[\
        \"ResourceArn\",\
        \"TagKeys\"\
      ],\
      \"members\":{\
        \"ResourceArn\":{\
          \"shape\":\"ARNString\",\
          \"documentation\":\"<p>The Amazon Resource Name (ARN) of the identity pool.</p>\"\
        },\
        \"TagKeys\":{\
          \"shape\":\"IdentityPoolTagsListType\",\
          \"documentation\":\"<p>The keys of the tags to remove from the user pool.</p>\"\
        }\
      }\
    },\
    \"UntagResourceResponse\":{\
      \"type\":\"structure\",\
      \"members\":{\
      }\
    },\
    \"UseDefaults\":{\"type\":\"boolean\"}\
  },\
  \"documentation\":\"<fullname>Amazon Cognito Federated Identities</fullname> <p>Amazon Cognito Federated Identities is a web service that delivers scoped temporary credentials to mobile devices and other untrusted environments. It uniquely identifies a device and supplies the user with a consistent identity over the lifetime of an application.</p> <p>Using Amazon Cognito Federated Identities, you can enable authentication with one or more third-party identity providers (Facebook, Google, or Login with Amazon) or an Amazon Cognito user pool, and you can also choose to support unauthenticated access from your app. Cognito delivers a unique identifier for each user and acts as an OpenID token provider trusted by AWS Security Token Service (STS) to access temporary, limited-privilege AWS credentials.</p> <p>For a description of the authentication flow from the Amazon Cognito Developer Guide see <a href=\\\"https://docs.aws.amazon.com/cognito/latest/developerguide/authentication-flow.html\\\">Authentication Flow</a>.</p> <p>For more information see <a href=\\\"https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-identity.html\\\">Amazon Cognito Federated Identities</a>.</p>\"\
}\
";
}

@end
