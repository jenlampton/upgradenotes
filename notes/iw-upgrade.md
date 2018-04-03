Upgrade notes for intowine.com, a Drupal 6 => Backdrop CMS upgrade.

Drupal 6
===============================================================================


## Export

* Export a clean database from the production site.

```bash
drush7 sql-dump --gzip --result-file=prod.sql.gz
```

## Import
### Note: The PHP version must be PHP 5.3

* Import a database, as exported from production site.

```bash
gunzip -c prod.sql.gz | drush7 sqlc
```

## Truncate unusually large tables, as well as old unused tables.

```bash
drush7 sqlq 'TRUNCATE ad_statistics; TRUNCATE access; TRUNCATE cache; TRUNCATE cache_block; TRUNCATE cache_content; TRUNCATE cache_filter; TRUNCATE cache_form; TRUNCATE cache_menu; TRUNCATE cache_page; TRUNCATE cache_views; TRUNCATE cache_views_data; TRUNCATE history; TRUNCATE node_comment_statistics; TRUNCATE search_index; TRUNCATE search_dataset; TRUNCATE search_node_links; TRUNCATE search_total; TRUNCATE watchdog;'
drush7 sqlq 'TRUNCATE buddylist; TRUNCATE buddylist_buddy_group; TRUNCATE buddylist_groups; TRUNCATE buddylist_pending_requests; TRUNCATE gsitemap; TRUNCATE gsitemap_additional; TRUNCATE moxie_role; TRUNCATE moxie_settings; TRUNCATE old_spam_custom; TRUNCATE old_spam_reported; TRUNCATE old_spam_tokens; TRUNCATE simplenews_newsletters; TRUNCATE simplenews_scheduler; TRUNCATE simplenews_scheduler_editions; TRUNCATE simplenews_snid_tid; TRUNCATE simplenews_subscriptions; TRUNCATE taxonomy_context_term; TRUNCATE taxonomy_context_vocabulary; TRUNCATE top_searches; TRUNCATE user_relationship_type_roles; TRUNCATE user_relationship_type_roles_receive; TRUNCATE user_relationship_types; TRUNCATE user_relationships; TRUNCATE usernode; TRUNCATE workflow_ng_cfgs;'
```

## Convert all tables to innodb
```bash
 drush7 sqlq "SELECT CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME,' ENGINE=MyISAM;') FROM Information_schema.TABLES WHERE TABLE_SCHEMA = 'bgp_iw_d6' AND ENGINE = 'InnoDB' AND TABLE_TYPE = 'BASE TABLE';"
```

* Make a backup.
```bash
drush7 sql-dump --gzip --result-file=../../d6-clean1.sql
```

## Disable old modules, in a specific order.

```bash
drush7 -y dis captcha varnish memcache faceted_search_views imce_wysiwyg panels_ipe
drush7 -y pm-uninstall captcha varnish memcache faceted_search_views imce_wysiwyg panels_ipe

drush7 -y dis ad_statistics_kill companyinfo_page intowine_cc intowine_cellar intowine_crossword intowine_menus intowine_node_context intowine_pairing intowine_panels intowine_profile intowine_promos intowine_signup_promo intowine_views jen_redirects jen_wysiwyg jeneration signup_promo
drush7 -y pm-uninstall ad_statistics_kill intowine_cellar intowine_crossword intowine_menus intowine_node_context intowine_pairing intowine_panels intowine_profile intowine_promos intowine_signup_promo intowine_views jen_redirects jen_wysiwyg jeneration

drush7 -y dis better_formats bulk_export colorbox content_profile db_maintenance expire faceted_search_ui fieldgroup forward_services author_facet content_type_facet
drush7 -y pm-uninstall better_formats bulk_export colorbox content_profile db_maintenance expire faceted_search_ui fieldgroup forward_services author_facet content_type_facet

drush7 -y dis general_services gmap_location gmap_macro_builder imagecache_profiles imagecache_ui improved_admin jquery_ui views_ui widget_services
drush7 -y pm-uninstall general_services gmap_location gmap_macro_builder imagecache_profiles imagecache_ui  improved_admin jquery_ui views_ui widget_services

drush7 -y dis jquery_update logintoboggan memcache_admin mollom nice_menus panels_mini prepopulate privatemsg site_verify forward views_bulk_operations
drush7 -y pm-uninstall jquery_update logintoboggan memcache_admin mollom nice_menus panels_mini prepopulate privatemsg site_verify forward views_bulk_operations

drush7 -y dis taxonomy_facets taxonomy_menu_hierarchy user_relationships_api vertical_tabs wysiwyg_filter views_bonus_export views_content
drush7 -y pm-uninstall taxonomy_facets taxonomy_menu_hierarchy user_relationships_api vertical_tabs wysiwyg_filter views_bonus_export views_content

drush7 -y dis custom_breadcrumbs faceted_search globalredirect gmap service_links panels wysiwyg imce page_manager xmlsitemap_menu
drush7 -y pm-uninstall custom_breadcrumbs faceted_search globalredirect gmap service_links panels wysiwyg imce page_manager xmlsitemap_menu

drush7 cc all
```

* Make a backup.
```bash
drush7 sql-dump --gzip --result-file=../../d6-clean2.sql
```

## Cleanup
* Enable the update module, and update.

```bash
drush7 -y en iw_update
drush7 -y updb
```

### What IW Update D6 is doing:

* Copies Ad content into text area.
* Deletes ad vocabularies and terms.
* Removes old data from system, block, and variable tables.
* Deletes old tables. Sets theme & cache settings.
* Sets theme and cache settings.

## Export

* Export the database, ready for import into Drupal 7.

```bash
drush7 sql-dump --gzip --result-file=../../d6-done.sql
```

# Drupal 7
===============================================================================

### Note: Switch the PHP version to PHP 5.6

## Import

* Import the Drupal 6 database, generated in the previous step.

```bash
drush7 sql-drop -y
gunzip -c ../../d6-done.sql.gz | drush7 sqlc
```

## Upgrade to Drupal 7

* Run update.php (279 pending updates - including IW's)

```bash
drush7 updb -y
```

### What IW Update D7 is doing:

* General DB cleanup, inc: Removes old modules from sytem table.
* Enables new modules.
* Creates an address field and phone field for Wineries.
  - Needs to be run before field conversion.
* Copies Phone data into Telephone field.
  - Needs to be run before field conversion.
* Moves Location data into new address field.
* Removes legacy Phone & Location fields and data.
* Disables & uninstall the location modules
* Enables bartik/seven themes.


## Upgrade Redirects

* Enable Redirect Separately

```bash
drush7 en redirect -y
```

* Run updates again so path_redirects get converted to redirects.

```bash
drush7 -y updb
```

## Fields

* Migrate all fields over from CCK.

```bash
drush7 content-migrate-fields -y
```

## Upgrade Metatags

* Migrate all metatags from Page title module

```
drush7 -y metatag-convert-page-title
```

* Migrate all metatags from NodeWords module

```
drush7 -y metatag-convert-nodewords
```

## Modules

* Disable / Uninstall the modules we won't be needing anymore.

```
drush7 dis cck content_migrate page_title nodewords_migrate metatag_importer  -y
drush7 pm-uninstall cck content_migrate page_title metatag_importer -y
```

## Export the database for import to Backdrop CMS.

* Rebuild the registry (and clear all caches).

```bash
drush7 rr
```

* Export the database. (no gzip here)

```bash
drush7 sql-dump --result-file=../../d7-done.sql
```


# Backdrop
===============================================================================

## Clean up Config

* Delete all files in active directory (ready for upgrade)
   - Ensure the latest config files have been copied into the staging directory.

## Import

* Import the Drupal 7 database, generated in the step previous.

```bash
drush sql-drop -y
drush sql-cli < ../../d7-done.sql
```

## Upgrade to Backdrop

* Run update.php (213 pending updates)

```bash
drush updb -y
```

### What IW Update Backdrop is doing:

* 1000: Sets file directory. Fixes metatag laguage. Enables modules.
* 1001: Updates embedded images to use data attributes.
* 1002: Moves "Food & Wine" terms into text field values.
* 1003: Deletes Terms and vocabulary for "Food type".
* 1004: Moves "Winery Feature" terms into text field values.
* 1005: Deletes "Winery Features" Vocabulary and terms.
* 1006: Adds taxonomy field instances to Wine Reviews.
* 1007: Moves "Wine Regions" terms into separate vocabulary.
* 1008: Moves "Wine Regions" field values to new fields.
* 1009: Moves "Varietals" terms into separate vocabulary.
* 1010: Moves "Varietals" field values to new fields.
* 1011: Add Taxonomy Menu settings.
* 1012: Deletes empty taxonomy terms and rebuilds menu.


## Enable new modules

* Enable the modules we'll need in Backdrop only.

```bash
drush -y en sharethis smtp views_ui
```

## Log In

* Log into the site as the root user Admin.


## Configuration Sync

* Navigate to admin/config/development/configuration
* Sync with "completed" config already in /staging/ directory

## Clear all caches

* This should be done with a config sync, but for some reason is not.

```bash
drush cc all
```

## Emoji support

* Visit the status report (admin/reports/status)
* Run the conversion for emoji support


## Cleanup

* Disable and uninstall the IW Update module

```bash
drush dis iw_update -y
drush pm-uninstall iw_update -y
```


