# PREPARE Drupal 6 Database
=============================

Update the Drupal 6 database
-----------------------------
- Convert all tables to innodb
  ```bash
   drush7 sqlq "SELECT CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME,' ENGINE=MyISAM;') FROM Information_schema.TABLES WHERE TABLE_SCHEMA = 'fashion_d6' AND ENGINE = 'InnoDB' AND TABLE_TYPE = 'BASE TABLE';"
  ```
  
- Enable ADT Upgrader module
  `drush7 en adt_upgrade`
  * truncates database tables.
  * disables / uninstalls / removes unneeded modules
  * Copies Ad content into text area.
  * upgrades flaged content to be promoted on install


Upgrade from menutrails to menu_position
------------------------------
- enable menu position module
  `drush7 en menu_position -y`
	- make sure your version of menu_position has the drush7 command from https://gist.github.com/ajsalminen/2719944

- use the drush7 command
  `drush7 menu-trails-to-menu-position`
- Disable menutrails
  `drush7 dis menutrails -y`
- Uninstall menutrails
  `drush7 pm-uninstall menutrails -y`


* Dump the Drupal 6 database.



# UPGRADE TO Drupal 7
=======================

## Import the Drupal 6 database


* Import the D6 daabase into D7 site.
* Run update.php (266 pending updates)
* Log in


Enable new field modules & CCK
-------------------------------
- File
- Image
- CCK
- Content migrate


Upgrade fields
---------------

- Migrate all fields over from CCK.

```bash
drush7 content-migrate-fields -y
```


Upgrade metatag data:
---------------------

- visit admin/config/search/metatags/importer
  convert from nodewords
- use drush7 to convert from page title module
  `drush7 metatag-convert-page-title -y`
- disable the Metatag importer module
  `drush7 dis metatag_importer -y`
- Uninstall the Metatag importer module
  `drush7 pm-uninstall metatag_importer -y`


Upgrade redirect data:
-----------------------
- Enable redirect module
  `drush7 en redirect -y`
    * this will take care of updating from path_redirect

Update webform module
---------------------------
- Replace webform 3 with webform 4
- Run update.php again
  `drush7 updb -y`

Export the database
--------------------
* Dump the Drupal 7 database.



# UPGRADE TO BACKDROP CMS
==========================

* Import the Drupal 7 database into Backdrop.
* Assure the config directory is empty.
* Run update.php (171 pending upgrades)
* Log in.


Enable the following new modules in Backdrop
---------------------------------------------
- ADT Miscalaneous (will import configs)
- Share This
- Honeypot


AI Changes for the Backdrop site
-----------------------------------------
- Add an image field to taxonomy terms.
- 


Port the following contrib modules to Backdrop
----------------------------------------------
- Views Field View


Port the following custom modules to Backdrop
----------------------------------------------
- Jen Webform



