Upgrade notes for onlinembareport.com, a Drupal 7 => Backdrop CMS upgrade.

===============================================================================
Drupal 7 site:
===============================================================================

1) Ensure all modules are up-to-date, and that there are no features.04

2) Set the theme to Bartik.

3) Disable all cacheing.

4) Put all the views back in the datbase. (change tag to "upgraded")

5) Disable the following modules:

drush dis admin_menu admin_menu_toolbar caption_filter elements jeneration views_bulk_operations radix_layouts -y
drush dis quicktabs comment logintoboggan mollom panels jen_ads jquery_update jen_info_page jen_views page_manager -y
drush dis environment_indicator views_content wysiwyg service_links total_control -y

6) Uninstall the following modules:

drush pm-uninstall admin_menu_toolbar total_control instantfilter panels_mini jen_panels ombar_panels jen_env jeneration -y
drush pm-uninstall admin_menu elements environment_indicator radix_layouts views_bulk_operations widget_services -y
drush pm-uninstall quicktabs comment mollom jen_info_page service_links jen_views -y
drush pm-uninstall caption_filter panels jquery_update views_content wysiwyg page_manager -y

7) Export the database

drush sql-dump > ombar_ready.sql


===============================================================================
Baakdrop site:
===============================================================================

1) Import the datbase

```bash
drush sql-cli < ombar_ready.sql
```

2) Run update.php (170 pending updates)

```bash
drush updb -y
```

3) Enable the following modules:

```bash
drush en sharethis bgp_blocks bgp_views jeneration -y
```

4) Import new configuration!

```bash
drush ??
```

5) Manual Data Cleanup:

* Change the first menu link from 'Find a School' to 'Home' <front>
* Delete the view mode "sidebar"
* Delete the filter format "wysiwyg"

