# JUNO

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Juno is an online dating app that displays user compatibility based on their sun sign(astrology). Users are then able to swipe and like/dislike the suggested profiles based on their photos and a small bio. Users are able to exchange messages after they match.

### App Evaluation
- **Category:** Lifestyle/Social
- **Mobile:** Maps, camera, location, push, real-time
- **Story:** In this digital age of dating, we take back control and focus on those prefrences that suit us when looking for partners, by adding additonals filters like race as to find  partner that we have more in common with, or learn a new culture from or Birth month so as to find that match made in heavean we ar able to find the person right for you.
- **Market:** Anyone 18 and over that is interested in online dating and astrology.
- **Habit:** Endless swiping through profiles, talking to new people, and the simplicity of the app makes it very addictive.
- **Scope:** Will be focused on implementing the in-app messaging and compatbility matching features. These will be relatively easy to complete and can be done within the expected time frame.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create an account.
* User can log in.
* User can update their profile with their location or add a picture.
* User can view their profile with their age and number of matches.
* User can view a feed of profiles.
* User can tap yes/no to a profile.
* User can send messages to matched profiles.
* User can view their compatibility score with other users.
* User can filter feed based on age, location, etc.
* User can receive notifications.

**Optional Nice-to-have Stories**

* User can upload more than one photo.
* User can view their compatibility with other users based on their birth chart.
* User can swipe to say yes/no to a profile.
* User can filter the results.

### 2. Screen Archetypes

* Login
   * User can log in.
* Registration
   * User can create an account.
* Stream
   * User can view a feed of profiles.
   * User can tap yes/no to a profile.
   * User can view their compatibility score with other users.
* Messaging
   * User can send messages to matched profiles.
* Profile
   * User can view their profile with their age and number of matches.
* Settings
   * User can update their profile with their location or add a picture.
   *  User can filter feed based on age, location, etc.
   * User can receive notifications.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Feed
* Profile
* Chat

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Home Feed
* Registraton Screen
   * Home Feed
* Stream Screen
   *  Profile
   *  Chat
* Messaging Screen
   *  Profile
   *  Stream
* Profile Screen
   *  Stream
   *  Chat
* Settings Screen
   *  Profile

## Wireframes
* Login Screen
<img src="https://i.imgur.com/mXLjbUj.png" width=300 height=500>

* Registraton Screen 

<img src="https://i.imgur.com/3rZqkaK.png"  width=300 height=500><img src="https://i.imgur.com/ncQTXBO.png"  width=300 height=500>

* Stream Screen
<img src="https://imgur.com/t0nEcTh.png"  width=300 height=500>

* Profile Screen
<img src="https://i.imgur.com/Vldn56x.png"  width=300 height=500>

* Settings Screen
<img src="https://imgur.com/7hlLfRE.png"  width=300 height=500>

* Messaging Screen

<img src="https://imgur.com/RRYmfg6.png"  width=300 height=500><img src="https://imgur.com/zmFsVjU.png"  width=300 height=500>

## Schema 
### Models

#### User

| Property      | Type     | Description                                              |
|---------------|----------|----------------------------------------------------------|
| userId        | String   | unique id for users                                      |
| fname         | String   | the user's first name                                    |
| lname         | String   | the user's last name                                     |
| username      | String   | the unique name the user logs in with                    |
| password      | String   | the string the user will use to verify their identity    |
| location      | String   | where the user is located                                |
| dob           | DateTime | the user's date of birth                                 |
| birthLocation | String   | where the user was born                                  |
| profilePhoto  | File     | the image that the user chooses for their profile        |
| likes         | Array    | an array of user profiles that the user has liked        |
| matches       | Array    | an array of user profiles that the user has matched with |
| jobTitle      | String   | the user's occupation                                    |
| companySchool | String   | the user's company/school                                |
| sign          | String   | the user's star sign                                     |


#### Compatibility

| Property | Type  | Description                                                 |
|----------|-------|-------------------------------------------------------------|
| sign     | Array | map used to store the compatibility value between each sign |

### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
