Upgrade notes for fashion-schools.org, a Drupal 6 => Backdrop CMS upgrade.

**Upgrade accomplished: July 20th, 2020**


# PREPARE Drupal 6 Database
===============================================================================

* Export a database from the live site.
  `drush7 sql-dump > d6-start.sql`

* Import the live database.
  `drush7 sql-cli < d6-start.sql`


## Enable the custom upgrade module
------------------------------------

* Enable ADT Upgrader module
  `drush7 en fs_upgrade`


## Update the Drupal 6 database
--------------------------------

* Run the database update script (4 updates).
  `drush7 updb -y`
  - Copies Ad content into text area.
  - upgrades flaged content to be promoted on install

### What FS Upgrade D6 is doing:

- truncates database tables.
- disables / uninstalls / removes unneeded modules
- Converts Ads (ad module) to a simple node type.
- Converts Flagged content to promoted.
- Enables garland theme and sets as default
- Disables all caching


## Export the database
-----------------------

* Export the Drupal 6 database.
  `drush7 sql-dump > d6-done.sql`



# UPGRADE TO Drupal 7
===============================================================================

* Import the Drupal 6 database, generated in the previous step.
  `drush7 sql-cli < d6-done.sql`


## Run the update script
-------------------------

* Run update.php (244 pending updates)
  `drush7 updb -y`

### What FS Upgrade D7 is doing:

- Enables necessary modules (file, image, cck, content migrate, redirect, metatag)
- Enables bartik/seven themes.
- disables / uninstalls / removes unneeded modules


## Upgrade Fields
------------------

* Migrate all fields over from CCK.

```bash
drush7 content-migrate-fields -y
```


## Upgrade Metatags
--------------------

* Migrate all metatags from Page title module

```
drush7 -y metatag-convert-page-title
```

* Migrate all metatags from NodeWords module

```
drush7 -y metatag-convert-nodewords
```


## Upgrade the webform module
------------------------------

* Replace webform 3 with webform 4
* Run update.php again
  `drush7 updb -y`


## Disable / Uninstall modules
-------------------------------

* disable modules
  `drush7 dis metatag_importer -y`

* Uninstall modules
  `drush7 pm-uninstall metatag_importer -y`


## Export the database
-----------------------
* Dump the Drupal 7 database.



# UPGRADE TO BACKDROP CMS
===============================================================================

* Import the Drupal 7 database, generated in the previous step.
  `drush sql-cli < d7-done.sql`


## Run the update script
-------------------------

* Assure the config directory is empty.
* Run update.php (207 pending updates)
  `drush updb -y`


## Log In
-------------------------
* Log in.


## Enable modules
-------------------------------

* Enable modules
  `drush en bgp_api bgp_blocks bgp_views block_embed captcha menu_position sharethis -y`

* Enable more modules
  `drush en bgp_quinstret recaptcha -y`


## Config Sync
-------------------------
* Synchronize configs.
  `drush en bgp_quinstret recaptcha -y`


# @todo: Port the following custom modules to Backdrop
-------------------------------------------------------
- Jen Webform



