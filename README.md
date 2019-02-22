# sheetocan
## What for?
Sheetocan is a tool to calculate time you spent at work at current day, week and month basing on your timesheet.

## Installation
### Ubuntu
Using [Launchpad](https://launchpad.net/~nixargh/+archive/ubuntu/sheetocan):
```
sudo apt-add-repository ppa:nixargh/sheetocan
sudo apt-get update
sudo apt-get install sheetocan
```

### Other
```
Using git:
git clone https://github.com/nixargh/sheetocan.git
sudo ln -s ~/sheetocan/sheetocan /usr/local/bin/sheetocan
```

## Authentication
### Environment variables
#### Login
By default Sheetocan takes login from timesheet file name but if it doesn't suit you can export
```
SHEETOCAN_LOGIN="<LDAP login>"
```

#### Password
You can export your password
```
SHEETOCAN_PASSWORD="<LDAP password>"
```
or you'll be asked about it interactevely.

### Keyring
I'm going to add it one day but isn't ready yet.

## Usage example
### Get your timesheet from Jira (Tempo)
```
sheetocan -g ~/timesheet/myname
```

### See how much you have already spent at work
```
sheetocan -r ~/timesheet/myname
```

### See your hardest tickets and your favorite projects
```
sheetocan -l pqt ~/timesheet/myname
```
 
### Put your timesheet to Jira (Tempo)
```
sheetocan -p ~/timesheet/myname
```

## Found bug or want a new feature?
Please create new issue here and describe what do you want.
Also feel free to contact me by mail or Slack.
