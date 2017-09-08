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
	- Backdrop 1 .install file

- bollier.org (Drupal 6 to Backdrop Upgrade)
	- [Notes](notes/bollier-upgrade.md)
  - Drupal 6 module
	- Drupal 7 module
	- Backdrop 1 module

- animationcareerreview.com (Drupal 6 to Backdrop Upgrade)
	- [Notes](notes/acr-upgrade.md)
	- Drupal 6 module
	- Drupal 7 module
	- Backdrop 1 module

## To do

I am fully intending to turn each markdown file into an actual script to be run from the command line. But first things first: documentation!
