# PREPARE Drupal 6 Database


Update the Drupal 6 database
-----------------------------
- Enable ADT Upgrader module
  `drush en adt_upgrade`
  * upgrades flaged content to be promoted on install
  * disables / uninstalls / removes unneeded modules


Upgrade from menutrails to menu_position
------------------------------
- enable menu position module
  `drush en menu_position -y`
- use the drush command
  `drush menu-trails-to-menu-position`
- Disable menutrails
  `drush dis menutrails -y`
- Uninstall menutrails
  `drush pm-uninstall menutrails -y`


Change the theme
-----------------
- Change the default theme to Garland
- Disable all other themes
- Change the admin theme to default


* Dump the Drupal 6 database.



# UPGRADE TO Drupal 7
=======================

## Import the Drupal 6 database


* Import the D6 daabase into D7 site.
* Run update.php (232 pending updates)
* Log in


Enable new field modules & CCK
-------------------------------
- File
- Image
- Field Group
- Content migrate


Upgrade fields
---------------
- Visit the fields migrate page at admin/structure/content_migrate
- migrate all fields (should be 18)


Upgrade metatag data:
---------------------
- Enable metatag, Metatag Importer
  `drush en metatag metatag_importer -y`
- visit admin/config/search/metatags/importer
  convert from nodewords
- use drush to convert from page title module
  `drush metatag-convert-page-title -y`
- disable the Metatag importer module
  `drush dis metatag_importer -y`
- Uninstall the Metatag importer module
  `drush pm-uninstall metatag_importer -y`


Upgrade redirect data:
-----------------------
- Enable redirect module
  `drush en redirect -y`
    * this will take care of updating from path_redirect

Update webform module
---------------------------
- Replace webform 3 with webform 4
- Run update.php again
  `drush updb -y`


Enable useful core modules
---------------------------
- Enable contextual links module.
  `drush en contextual -y'


Flush all caches
-----------------
- Rebuild registry.
  `drush rr`


Clear log messages
-------------------
- empty the watchdog table.


Change the theme
-----------------
- Change the default theme to Bartik
- Disable all other themes
- Change the admin theme to Seven

Export the database
--------------------
* Dump the Drupal 7 database.



# UPGRADE TO BACKDROP CMS
==========================

* Import the Drupal 7 database into Backdrop.
* Assure the config directory is empty.
* Run update.php (135 pending upgrades)
* Log in.


Enable the following new modules in Backdrop
---------------------------------------------
- ADT Miscalaneous (will import configs)
- Share This
- Flexslider
- Honeypot


AI Changes for the Backdrop site
-----------------------------------------
- Add an image field to taxonomy terms.


Port the following contrib modules to Backdrop
----------------------------------------------
- Ad - https://www.drupal.org/node/2787507
- Caption Filter
- Custom Breadcrumbs
- Field group
- Iframe Filter
- Image resize filter
- Nodequeue (queue)
- Paging
- Similar
- Site Map
- Site Verify
- Taxonomy menu
- Taxonomy Title
- Wysiwyg filter
- XML Sitemap


Port the following custom modules to Backdrop
----------------------------------------------
- Jen Webform



