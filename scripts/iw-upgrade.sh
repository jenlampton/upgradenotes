#!/bin/bash


# to run script `. iw-upgrade.sh` from the /upgrade directory.
#
# Directory should contain all drupal6, drupal7, and backdrop codebases.
# Drupal 6 database must contain starting content. All others should be empty.
# Backdrop active config must be empty, and staging must be up to date.
#
# Databases will be saved in /upgrade.
#
# GRANT ALL ON bgp_iw_b.* TO 'backdrop'@'localhost' IDENTIFIED BY 'backdrop01';
#
# Some useful queries:
# - Show MySQL tables by size
# SELECT TABLE_NAME, table_rows, data_length, index_length,  round(((data_length + index_length) / 1024 / 1024),2) "Size in MB" FROM information_schema.TABLES WHERE table_schema = "schema_name" ORDER BY (data_length + index_length) DESC;
# - Convert all tables to myisam
# SELECT CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME,' ENGINE=MyISAM;') FROM Information_schema.TABLES WHERE TABLE_SCHEMA = 'bgp_iw_d6' AND ENGINE = 'InnoDB' AND TABLE_TYPE = 'BASE TABLE'

echo -n "Proceed with upgrade? y/n"
read choice

if echo "$choice" | grep -iq "^y" ;then

  cd drupal6/docroot
  echo -n "--- Cleaning up Drupal 6 database ---"
  drush7 -y dis varnish memcache faceted_search_views imce_wysiwyg panels_ipe
  drush7 -y pm-uninstall varnish memcache faceted_search_views imce_wysiwyg panels_ipe
  drush7 -y dis ad_statistics_kill companyinfo_page intowine_cc intowine_cellar intowine_crossword intowine_menus intowine_node_context intowine_pairing intowine_panels intowine_profile intowine_promos intowine_signup_promo intowine_views jen_redirects jen_wysiwyg jeneration signup_promo
  drush7 -y pm-uninstall ad_statistics_kill intowine_cellar intowine_crossword intowine_menus intowine_node_context intowine_pairing intowine_panels intowine_profile intowine_promos intowine_signup_promo intowine_views jen_redirects jen_wysiwyg jeneration
  drush7 -y dis better_formats bulk_export colorbox content_profile db_maintenance expire faceted_search_ui fieldgroup forward_services author_facet content_type_facet
  drush7 -y pm-uninstall better_formats bulk_export colorbox content_profile db_maintenance expire faceted_search_ui fieldgroup forward_services author_facet content_type_facet
  drush7 -y dis general_services gmap_location gmap_macro_builder imagecache_profiles imagecache_ui improved_admin jquery_ui views_ui widget_services
  drush7 -y pm-uninstall general_services gmap_location gmap_macro_builder imagecache_profiles imagecache_ui  improved_admin jquery_ui views_ui widget_services
  drush7 -y dis jquery_update logintoboggan memcache_admin mollom nice_menus panels_mini prepopulate privatemsg site_verify forward views_bulk_operations
  drush7 -y pm-uninstall jquery_update logintoboggan memcache_admin mollom nice_menus panels_mini prepopulate privatemsg site_verify forward views_bulk_operations
  drush7 -y dis taxonomy_facets taxonomy_menu_hierarchy user_relationships user_relationships_api vertical_tabs wysiwyg_filter views_bonus_export views_content
  drush7 -y pm-uninstall taxonomy_facets taxonomy_menu_hierarchy user_relationships user_relationships_api vertical_tabs wysiwyg_filter views_bonus_export views_content
  drush7 -y dis custom_breadcrumbs faceted_search globalredirect gmap service_links panels wysiwyg imce
  drush7 -y pm-uninstall custom_breadcrumbs faceted_search globalredirect gmap service_links panels wysiwyg imce
  drush7 cc all
  drush7 sqlq 'TRUNCATE access; TRUNCATE cache; TRUNCATE cache_block; TRUNCATE cache_content; TRUNCATE cache_filter; TRUNCATE cache_form; TRUNCATE cache_menu; TRUNCATE cache_page; TRUNCATE cache_views; TRUNCATE cache_views_data; TRUNCATE history; TRUNCATE node_comment_statistics; TRUNCATE search_index; TRUNCATE search_dataset; TRUNCATE search_node_links; TRUNCATE search_total; TRUNCATE watchdog;'
  drush7 -y en iw_update
  drush7 -y updb
  echo -n "--- Dumping Drupal 6 database ---"
  drush7 cc all
  drush7 sql-dump > ../../d6.sql

  #cd ../../drupal7/docroot
  cd drupal7/docroot
  echo -n "--- Importing Drupal 6 database into Drupal 7 site ---"
  drush7 sql-cli < ../../d6.sql
  echo -n "--- Upgrading to Drupal 7 ---"
  drush7 updb -y
  echo -n "--- Converting Redirects ---"
  drush7 en redirect -y
  drush7 -y updb
  echo -n "--- Migrating Fields ---"
  drush7 content-migrate-fields -y
  echo -n "--- Converting Metatags ---"
  drush7 -y metatag-convert-page-title
  drush7 -y metatag-convert-nodewords
  echo -n "--- Removing conversion modules ---"
  drush7 dis cck content_migrate page_title nodewords_migrate metatag_importer  -y
  drush7 pm-uninstall cck content_migrate page_title metatag_importer -y
  echo -n "--- Dumping Drupal 7 database ---"
  drush7 rr
  drush7 sql-dump > ../../d7.sql

  cd ../../backdrop/docroot
  echo -n "--- Importing Drupal 7 database into Backdrop site ---"
  drush sql-cli < ../../d7.sql
  echo -n "--- Upgrading to Backdrop CMS ---"
  drush updb -y
  echo -n "--- Configuration Sync ---"
  drush -y bcim
  drush cc all
  echo -n "--- Dumping Backdrop database ---"
  drush sql-dump > ../../b.sql
  echo -n "--- Upgrade complete ---"

fi
