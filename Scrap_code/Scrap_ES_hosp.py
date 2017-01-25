#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  5 21:12:11 2017

@author: victor
"""

##Previously I encode my txt file into UTF-
##iconv -f ISO-8859-15 -t UTF-8 sites.txt > out2.txt
##After scrapping I will need to recode my output


file_directory='/Users/victor/Documents/DataLab/Hospitales_RRSS/Scraping/sites.txt'

with open(file_directory,'r') as f_open:
      data = f_open.read()
 
#print(len(data))

list_contents=data.split(",")


def get_next_target(page):
    start_link = page.find('<a href=')
    if start_link == -1:
        return None, 0
    start_quote = page.find('"', start_link)
    end_quote = page.find('\\"', start_quote + 1)
    url = page[start_quote + 1:end_quote]
    return url, end_quote
    
def get_all_links(page):
    links = []
    while True:
        url,endpos = get_next_target(page)
        if url:
            links.append(url)
            page = page[endpos:]
        else:
            break
    return links



def sort_links(links):
    hospital={'Other':None,'twitter':None,'youtube':None,'wiki':None,'facebook':None,'instagram':None,'blog':None,'linkedin':None}
    for element in links:
        if 'twitter' in element:
            el=element.split('/')
            hospital['twitter']=el[-1]
        elif 'wiki' in element:
            hospital['wiki']=element
        elif 'instagram' in element:
            hospital['instagram']=element
        elif 'blog' in element:
            hospital['blog']=element
        elif 'linkedin' in element:
            hospital['linkedin']=element
        elif 'facebook' in element:
            el=element.split('/')
            hospital['facebook']=el[-1]
        elif 'youtube' in element:
            hospital['youtube']=element
        else:
            hospital['web']=element
    return hospital

diction={}

for i in range(0,len(list_contents)):
    links=get_all_links(list_contents[i])
    diction[i]=sort_links(links)


twitter_acc=[]

for i in range(0,len(diction)):
    if diction[i]['twitter']!=None:
        twitter_acc.append(diction[i]['twitter'])

print(len(twitter_acc))
        
import tweepy
from tweepy import OAuthHandler

consumer_key='4GX2hQ9I3CHKgfcu4bofWhngp'
consumer_secret='bcr0VKrEGdqlXYIsw3rC4WTtu9BjIPBVuKL1E38i8KuqDfoEKk'
access_token='292569063-rYg0p6CCNUQgmyHAIUuNx4HIGlWQwuKKiFXYWs30'
access_secret='urVLGh9oxSGWfhabj18VYdgvO3KxjHG0fv78CiZxp5s2l'

 
auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
 
api = tweepy.API(auth)

#timeline = api.user_timeline(screen_name=twitter_acc[87], include_rts=True, count=300)


f = open('twitter_acc_ES.txt','w')
for j in range(1,len(twitter_acc)):
    element=twitter_acc[j]
    user=api.get_user(element)
    i+=1
    if user.screen_name!=None:
        name=str(user.screen_name.encode('utf-8'))
    else:
        name='None'
    if user.url!=None:
        url=user.url
    else:
        url='None'
    if user.location!=None:
        location=str(user.location.encode('utf-8'))
    else:
        location='None'
    tweets=str(user.statuses_count)
    followers=str(user.followers_count)
    friends=str(user.friends_count)
    f.write(name+','+location+','+tweets+','+followers+','+friends+','+user.created_at.strftime('%Y-%m-%d')+','+url+'\n')
f.close()

#for tweet in timeline:
#        print ("ID:", tweet.id)
#        print ("User ID:", tweet.user.id)
#        print ("Text:", tweet.text)
#        print ("Created:", tweet.created_at)
#        print ("Geo:", tweet.geo)
#        print ("Contributors:", tweet.contributors)
#        print ("Coordinates:", tweet.coordinates) 
#        print ("Favorited:", tweet.favorited)
#        print ("In reply to screen name:", tweet.in_reply_to_screen_name)
#        print ("In reply to status ID:", tweet.in_reply_to_status_id)
#        print ("In reply to status ID str:", tweet.in_reply_to_status_id_str)
#        print ("In reply to user ID:", tweet.in_reply_to_user_id)
#        print ("In reply to user ID str:", tweet.in_reply_to_user_id_str)
#        print ("Place:", tweet.place)
#        print ("Retweeted:", tweet.retweeted)
#        print ("Retweet count:", tweet.retweet_count)
#        print ("Source:", tweet.source)
#        print ("Truncated:", tweet.truncated)

#Info:
#http://www.tweepy.org/
#https://marcobonzanini.com/2015/03/02/mining-twitter-data-with-python-part-1/
#http://stackoverflow.com/questions/15628535/how-can-i-retrieve-all-tweets-and-attributes-for-a-given-user-using-python#15696001

#Sentimental Analysis in R
#http://www.bnosac.be/index.php/blog/54-sentiment-analysis-and-parts-of-speech-tagging-in-dutch-french-english-german-spanish-italian
print(twitter_acc[87])




