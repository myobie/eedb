What is this for?
=================

Here's the problem:

You want to create a new weblog locally (maybe using MAMP or something), create the templates, and then push all those changes up to the server. Well, you can't do that easily. There are tons of paths and such that are different between your computer and the server. 

This command line program attempts to solve this.

How do I install this?
======================

On your terminal, type:

    sudo gem install eedb

If you have ruby and rubygems, that should work just fine (all Macs should have this). If not, then go get those things (I'll try to provide links when I get more time).

I use sudo to install my gems, you may not.

How to use this thing?
======================

cd to your EE project folder in the Terminal and type: eedb

If you don't already have a eedb.yml file, it will create one for you. That file needs to have all your database settings correct and you can specify any number of things to find and replace in the database during the transfer (like urls or folder paths).

There are four things eedb can do:

* export - Dump the local database on your computer and optionally push that to the remote server
* import - Dump the remote database from the server and optionally pull that into your local database
* rollback (local or remote) - use the newest .backup file for that database to restore
* init - create the yml file for you

How should I get started?
=========================

A good thing to try is to pull your server database down to your computer. To do this, you simply do:

    eedb import

As long as your eedb.yml file has the correct information, that will dump a copy of your server's database, ask if you want to import it (you can answer Y), ask if you want to backup your local database (probably should answer Y as well), then it will import it (since you typed Y the first time).

Everything eedb does is saved into the tmp folder. You can look there for sql dumps, backups, and even .cleaned files which are the results of the find and replaces.

What does this not do?
======================

Syncing.

It will overwrite one database with the contents of another. But it will not merge the differences or anything like that.

So only use this if you are sure there have been no changes on the side you are overwriting (or that you don't care about those changes).

Anything else?
==============

This program expects `mysql` and `mysqldump` to be in your path. So if your using MAMP, take note of that.

Also, I only tested this on my mac laptop running Snow Leopard. So be sure you have a backup of any database that this thing touches. You _should_ do that all the time anyway.