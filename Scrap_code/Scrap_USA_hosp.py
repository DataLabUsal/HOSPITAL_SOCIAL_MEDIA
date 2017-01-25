#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 15:48:04 2017

@author: victor
"""

import tweepy
from tweepy import OAuthHandler

consumer_key='4GX2hQ9I3CHKgfcu4bofWhngp'
consumer_secret='bcr0VKrEGdqlXYIsw3rC4WTtu9BjIPBVuKL1E38i8KuqDfoEKk'
access_token='292569063-rYg0p6CCNUQgmyHAIUuNx4HIGlWQwuKKiFXYWs30'
access_secret='urVLGh9oxSGWfhabj18VYdgvO3KxjHG0fv78CiZxp5s2l'

 
auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
 
api = tweepy.API(auth)

follows_AHA = api.friends_ids('ahahospitals')

#print(len(follows_AHA))
#print(len(follows_AHA))

#user=api.get_user(follows_AHA[1300])

#print(user.screen_name)
#print('Hospital' in user.description or 'hospital' in user.description)
#print(user.followers_count)
#print(user.friends_count)
#print(user.created_at.strftime('%Y-%m-%d'))
#print(user.url)
#print(user.statuses_count)
#print(user.lang)
print(len(follows_AHA))

#print(api.rate_limit_status())

i=1
f = open('twitter_acc_USA_1800.txt','w')
for j in range(1800,len(follows_AHA)):
    element=follows_AHA[j]
    user=api.get_user(element)
    i+=1
    if ('Hospital' or 'hospital' or 'Medical Center') in user.description:
        if user.screen_name!=None:
            name=user.screen_name
        else:
            name='None'
        if user.url!=None:
            url=user.url
        else:
            url='None'
        if user.location!=None:
            location=user.location
        else:
            location='None'
        tweets=str(user.statuses_count)
        followers=str(user.followers_count)
        friends=str(user.friends_count)
        f.write(name+','+location+','+tweets+','+followers+','+friends+','+user.created_at.strftime('%Y-%m-%d')+','+url+'\n')
f.close()

print(i)