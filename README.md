# sheetocan
## What for?
Sheetocan is a tool to calculate time you spent at work at current day, week and month basing on your timesheet.

## Installation
### Keyring Requirements
*You can skip this if you don't want to or can't use Gnome keyring.*
To make keyring library work you need some libraries installed.
#### Ubuntu
```
sudo apt install libgirepository1.0-dev libgnome-keyring-dev ruby-dev
```
#### Others
I don't know, will figure it out.

### GitHub
#### Basic
```
git clone https://github.com/nixargh/sheetocan.git
cd ./sheetocan
sudo gem install bundler
sudo bundle install
sudo ln -s "$(realpath ./sheetocan)" /usr/local/bin/sheetocan
```
#### Add Keyring
```
sudo bundle install gir_ffi-gnome_keyring
```

## Authentication
### Environment variables
#### Login
By default Sheetocan takes login from timesheet file name but if it doesn't suit you can export
```
export SHEETOCAN_LOGIN="<LDAP login>"
```

Or set login from command line
```
sheetocan -g ~/timesheet/mjakson -o -L jsmith
```

#### Password
Default is entering password interactively. After that sheetocan will try to store it into keyring.
If you don't have Gnome keyring or Ruby library isn't functional **sheetocan** asks password interactively.

Or you could export your password
```
export SHEETOCAN_PASSWORD="<LDAP password>"
```

And also you can set login and password from command line
```
sheetocan -g ~/timesheet/jsmith -o -P 'super_secret'
```

## Usage example
### Get your timesheet from Jira (Tempo)
```
sheetocan -g ~/timesheet/myname
```

Want it *oldschool*? Just add **-o**.
```
sheetocan -g ~/timesheet/myname -o
```

Seems comments are already allowed. But anyway if want to have a pet
```
sheetocan -g ~/timesheet/myname -o -f ./footer
```
Footer content maybe like that
```
# I'm GoingHome Dog. Paw-Wow!
#
#         / |   |\
#  _____/ @ |   | \
# |> . .    |   |   \
#  \  .     |||||     \________________________
#   |||||||\                                    )
#            \                                 |
#             \                                |
#               \                             /
#                |   ____________------\     |
#                |  | |                ||    /
#                |  | |                ||  |
#                |  | |                ||  |
#                |  | |                ||  |  Glo Pearl
#               (__/_/                ((__/
#

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

## Plans
* **Done** ~~Add transformation to *old school* format (with quotes and blank lines).~~
* **Done** *Haven't been tested under Mac* ~~Support keyring applications (Linux, Mac).~~
* Maybe some .sheetocanrc file for those who don't mind keep they secrets openly.

## Found bug or want a new feature?
Please create new issue here and describe what do you want.
Also feel free to contact me by mail or Slack.
