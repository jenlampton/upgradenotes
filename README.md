Upgrade Notes
==============

A collection of upgrade "scripts" for moving from Drupal 6 and Drupal 7 to Backdrop CMS.

Each "script" is a markdown file for a single site, containing notes and Drush commands that should be run in sequence to complete an upgrade to Backdrop CMS.

Almost all scripts have a matching custom module that performs cleanup tasks and various system updates as needed. Though the cleanup tasks may vary from one site to the next, the updates often correlate to one contrib module or another. Most of the custom modules are included here too, in the "code" directory.

## In this repository:

- "notes" directory: contains detailed notes on the upgrade process.
- "code" directory: contains custom module used to run updates.

## Sites upgraded to Backdrop

- onlinembareport.com (Drupal 7 to Backdrop Upgrade)
	- [Notes](notes/ombar-upgrade.md)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/ombarupdate)

- bollier.org (Drupal 6 to Backdrop Upgrade)
	- [Notes](notes/bollier-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/bupdate)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/bupdate)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/bupdate)

- animationcareerreview.com (Drupal 6 to Backdrop Upgrade)
	- [Notes](notes/acr-upgrade.md)
	- [Drupal 6 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal6/acrupdate)
	- [Drupal 7 module](https://github.com/jenlampton/upgradenotes/tree/master/code/drupal7/acrupdate)
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/acrupdate)

- intowine.com (Drupal 6 to Backdrop Upgrade)
	- Notes? TBD.
	- [Backdrop module](https://github.com/jenlampton/upgradenotes/tree/master/code/backdrop/iw_update)

- arf.berkley.edu (Drupal 6 to Backdrop Upgrade)
	- [Notes](notes/arf-upgrade.md)
	- Drupal 6 module
	- Drupal 7 module
	- Backdrop 1 module


## To do

I am fully intending to turn each markdown file into an actual script to be run from the command line. But first things first: documentation!
