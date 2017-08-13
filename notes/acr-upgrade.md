Upgrade notes for annimationcareerreview.com, a Drupal 6 => Backdrop CMS upgrade.


# Drupal 6
===============================================

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
drush7 sqlq 'TRUNCATE access; TRUNCATE accesslog; TRUNCATE ad_statistics; TRUNCATE cache; TRUNCATE cache_block; TRUNCATE cache_content; TRUNCATE cache_filter; TRUNCATE cache_form; TRUNCATE cache_menu; TRUNCATE cache_menu; TRUNCATE cache_mollom; TRUNCATE cache_page; TRUNCATE cache_views; TRUNCATE cache_views_data; TRUNCATE history; TRUNCATE search_index; TRUNCATE search_dataset; TRUNCATE search_node_links; TRUNCATE search_total; TRUNCATE watchdog;'
```

## Cleanup

* Enable the acr update module.

```bash
drush7 -y en acrupdate
drush7 -y updb
```

### What ACR Update D6 is doing:

* Converts Ads (ad module) to a simple node type.
* Deletes Ad terms & deletes Ad vocabulary
* Deletes unneeded custom blocks
* Disables / uninstalls unneeded or legacy modules
* Enables garland theme and sets as default
* Disables all caching

## Export

* Export the database, ready for import into Drupal 7.

```bash
drush7 sql-dump --gzip --result-file=../../d6.sql
```

# Drupal 7
=================================================

## Import

* Import the Drupal 6 database, generated in the previous step.

```bash
drush7 sql-drop -y
gunzip -c ../../d6.sql.gz | drush7 sqlc
```

## Upgrade

```bash
drush7 updb -y
# A second time for webform; this is not a typo.
drush7 updb -y
```

### What ACR Update D7 is doing:
* Converts emfield (d6) values to YouTube (d7) values.
	- Needs to be run before field conversion.
* Removes vocab settings from nodewords.
* Enables bartik theme and sets as default
* Removes old field related modules.


## Fields

* Migrate all fields from CCK.

```bash
drush7 en cck content_migrate -y
# Let's see what's going to change.
drush7 content-migrate-status
# Run it.
drush7 content-migrate-fields -y
# Validation.
drush7 content-migrate-status
```

## Metatags <- Page title

* Migrate all metatags from Page Title module

```
drush7 -y en metatag metatag_importer nodewords_migrate
drush7 -y metatag-convert-page-title
drush7 -y dis page_title
drush7 -y pm-uninstall page_title
```

## Metatags <- NodeWords

* Migrate all metatags from nodewords using the Drupal UI.
	* Log in  user/ogin
	* Import at admin/config/search/metatags/importer
	* Check that articles have defined metatags at admin/content
	* Check that terms have defined metatags at admin/structure/taxonomy/vocabulary_1


## Modules

* Disable / Uninstall the modules we won't be needing.

```
drush7 dis cck content_migrate emfield metatag_importer -y
drush7 pm-uninstall cck content_migrate emfield metatag_importer -y
```

## Registry Rebuild

```bash
drush7 rr
```

## Export

* Export the database, ready for import into Backdrop CMS.

```bash
drush7 sql-dump --gzip --result-file=../../d7.sql
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

* Make sure that update free access is enabled.

```php
$settings['update_free_access'] = TRUE;
```

* Run update.php (171 pending updates)

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
drush en captcha devel honeypot flexslider multifield recaptcha sharethis -y
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


