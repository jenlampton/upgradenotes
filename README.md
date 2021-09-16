Upgrade Notes
==============

A collection of upgrade "scripts" for upgrading websites from Drupal 6 and/or
Drupal 7 to Backdrop CMS.

Each "script" is a markdown file for a single site, containing notes and a set
of Drush commands that should be run in sequence to complete an upgrade.

Almost all scripts have a matching custom module that performs cleanup tasks
and various system updates as needed. Though the cleanup tasks may vary from
one site to the next, the updates often correlate to specific contrib modules,
and can likely be reused.. Most of the custom modules are included here too, i
n the "code" directory.

## In this repository:

- "notes" directory: contains detailed notes on the upgrade process.
- "code" directory: contains custom module used to run updates.
- "scripts" directory: contains shell scrpts to run through the whole upgrade.

## Sites upgraded to Backdrop

- fashion-schools.org (Drupal 7 to Backdrop Upgrade)- July 20th, 2020
	- [Notes](notes/fs-upgrade.md)

- arf.berkley.edu (Drupal 6 to Backdrop Upgrade) - Dec 7th, 2018**
	- [Notes](notes/arf-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/arf_upgrade)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/arf_upgrade)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/arf_upgrade)

- noreciperequired.com (Drupal 7 to Backdrop Upgrade) - April 8th, 2018
	- [Notes](notes/nrr-upgrade.md)

- intowine.com (Drupal 6 to Backdrop Upgrade) - March 26th, 2018
	- [Notes](notes/iw-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/iw_update)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/iw_update)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/iw_update)
	- [Script](scripts/iw-upgrade.sh)

- animationcareerreview.com (Drupal 6 to Backdrop Upgrade) - August 30th, 2017
	- [Notes](notes/acr-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/acrupdate)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/acrupdate)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/acrupdate)

- bollier.org (Drupal 6 to Backdrop Upgrade) - May 5th, 2017
	- [Notes](notes/bollier-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/bupdate)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/bupdate)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/bupdate)

- onlinembareport.com (Drupal 7 to Backdrop Upgrade) - March 25th, 2017
	- [Notes](notes/ombar-upgrade.md)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/ombarupdate)

- bootfitters.com (Drupal 6 to Backdrop Upgrade) - Aug 25th, 2015
	- Notes (missing?)



## To do

I intend to turn information from these markdown files into an actual script to
be run from the command line. But first things first: documentation!
