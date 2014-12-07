Mercury
=======

Mercury is an admin mod for Garrysmod. It is designed to be more lightweight, and easier to operate than other systems like it. It started off as a two day project, then escalated into an ongoing work.

SUI_SCOREBOARD comes recomended to use alongside this admin mod.

https://github.com/ZionDevelopers/sui-scoreboard/

How to set it up
=======

First, install Mercury into your addons folder, then proceed to start / restart your server. You should see a few messages in console indicating that Mercury has loaded. The initialzied modules will be listed.

After the server has started, you need to join it; when you spawn in, use either RCON or type directly in the server's console to run this


hg rankadd owner Owner 1,1,1


After executing the above, you need to give the rank all privileges, this can be accomplished by running the following in RCON or in the server console.

hg rankmodpriv owner add @allcmds@


Finally, you can set yourself to the rank by using the following command, executed with one of the methods mentioned previously.


hg setrank "your name" owner



After this is done, you can now use your game client to configure more ranks and groups. 

To open the menu, type !menu in chat, you should see a window pop up with the Mercury logo on it. By default, there will be three tabs in the menu. "Commands","Ranks", and "Bans"

Take a moment to firmiliarize yourself with the menu.


![alt tag](https://dl.dropboxusercontent.com/u/40443211/Share/2014-11/2014-11-30_06-37-41.png)

On the left is the rank list, it will list an index and titie, click one of these to see the properties for a rank.

Below is a description of what all of the properties of a rank does.


* Index -  The internal name for a rank, this is how you set groups and perform tasks on the rank.
* Title - If you have the scoreboard enabled, then this will set the title for that rank's teams.
* Order - If you have the scoreboard enabled, this will define the order the rank appears relative to other ranks.
* Current Commands -  The commands this rank has, note that if a rank has the @allcmds@ privlage, then it has all privileges, regardless of what is in its rank.
* Availible commands - The commands this rank does not have.
* Color - If you have the scoreboard enabled, this will be the color of that rank's team.





