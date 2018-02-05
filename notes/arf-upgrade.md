Upgrade notes for arf.berkeley.edu, a Drupal 6 => Backdrop CMS upgrade.


Drupal 6
==========


## Export

* Export a clean database from the production site.

```bash
drush7 sql-dump --gzip --result-file=prod.sql.gz
```

## Import

* Import a database, as exported from production site.

```bash
gunzip -c prod.sql.gz | drush7 sqlc
```

## Clear caches

```bash
drush7 sqlq 'TRUNCATE access; TRUNCATE cache; TRUNCATE cache_block; TRUNCATE cache_content; TRUNCATE cache_filter; TRUNCATE cache_form; TRUNCATE cache_menu; TRUNCATE cache_page; TRUNCATE cache_views; TRUNCATE cache_views_data; TRUNCATE history; TRUNCATE node_comment_statistics; TRUNCATE search_index; TRUNCATE search_dataset; TRUNCATE search_node_links; TRUNCATE search_total; TRUNCATE watchdog;'
```

## Cleanup

* Enable the acr update module, and update.

```bash
drush7 -y en arf_upgrade
drush7 -y updb
```

### What ARF Upgrade D6 is doing:

* Disables / uninstalls unneeded or legacy modules
* Deletes unneeded custom blocks
* Enables garland theme and sets as default
* Disables all caching

## Export

* Export the database, ready for import into Drupal 7.

```bash
drush7 sql-dump > d6.sql
```

# Drupal 7
=================================================

## Import

* Import the Drupal 6 database, generated in the previous step.

```bash
drush7 sql-drop -y
gunzip -c d6.sql.gz | drush7 sqlc
```

## Upgrade

```bash
drush7 updb -y
```

### What ARF Upgrade D7 is doing:
* Removes old unused modules from the system table.
* Converts emfield (d6) values to YouTube (d7) values.
	- Needs to be run before field conversion.
* Enables bartik/seven themes.


## Enable modules
```bash
drush7 en contextual file field_group image update cck content_migrate references node_reference bartik -y
```

## Fields

* Migrate all fields from CCK.

```bash
# Let's see what's going to change.
drush7 content-migrate-status
# Run it.
drush7 content-migrate-fields -y
# Validation.
drush7 content-migrate-status
```

## Modules

* Disable / Uninstall the modules we won't be needing.

```
drush7 dis cck content_migrate -y
drush7 pm-uninstall cck content_migrate -y
```

## Registry Rebuild

```bash
drush7 rr
```

## Export

* Export the database, ready for import into Backdrop CMS.

```bash
drush7 sql-dump > d7.sql
```


# Backdrop
=================================================

## Clean up Config

* Delete all files in active directory (ready for upgrade)
   - Ensure files have been copied and committed to staging directory.

## Import

* Import the Drupal 7 database, generated in the step previous.

```bash
drush sql-drop -y
gunzip -c ../../d7.sql.gz | drush sqlc
```

## Upgrade

* Make sure that update free access is enabled in settings.local.php

```php
$settings['update_free_access'] = TRUE;
```

* Run update.php (171 pending updates)
  * This update works when run from the UI even if it fails from drush.

```bash
drush updb -y
```


### What ACR Update Backdrop is doing:

  * custom: caption filter markup (d6) => data attributes (backdrop core)
  * custom: profile nodes => user account (fields)
  	 - It's easier to add these fields in Backdrop than D7, cause config sync.


## Modules - contrib

* Enable new contrib modules

```bash
drush en  -y
```

## Log In

* Log into the site as the root user Admin.


## Modules - core / custom

* Enable custom, core, and submodules (manually - until they will enable with drush)
  - ckeditor
  - contextual
  - redirect
  - update
  - views_ui
  - bgp_blocks
  - bgp_views
  - bgp_api
  - bgp_quinstreet
  - jeneration
  - flexslider_views
  - metatag_verify
  - smtp

```bash
drush en ckeditor contextual redirect update views_ui bgp_blocks bgp_views bgp_api bgp_quinstreet jeneration -y
```

## Configuration Sync

* Navigate to admin/config/development/configuration
* Sync with "completed" config already in /staging/ directory

## Set New Metatags

* Navigate to admin/config/metadata/metatags/config
* Enable Global
* Enable Content
* Enable Taxonomy term
* Enable Home page
* Edit Home page:
  - Set Bing: 08D15ABFD61ED9A98F41F3C0FC5078D0
  - Set google: WVe5slAvly494IKHI1lFCW-RauN1xlOG2Opbb7E-svY


## Cleanup

* disable and uninstall the ACR Update module

```bash
drush dis acrupdate -y
drush pm-uninstall acrupdate -y
```


