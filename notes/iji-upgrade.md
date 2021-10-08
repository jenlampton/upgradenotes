Upgrade notes for https://www.ivarjacobson.com/, a Drupal 7 => Backdrop CMS upgrade.

**Upgrade accomplished: Sept 26th, 2021**

===============================================================================
Drupal 7 site:
===============================================================================

1) Ensure all modules are up-to-date.
1) Put all the views back in the database. (change tag to "upgraded")
1) Put all the image styles back in the database.
1) Convert all view modes to entity_view_modes (todo)

1) Disable the following modules:

```
drush dis iji_contexts -y
drush dis admin_menu_toolbar backdrop_upgrade_status blazy_ui context_ui entityqueue module_filter rdf -y
drush dis blazy context -y
```

1) Uninstall the following modules:

```
drush pm-uninstall iji_contexts -y
drush pm-uninstall admin_menu_toolbar backdrop_upgrade_status blazy_ui context_ui entityqueue module_filter rdf -y
drush pm-uninstall blazy context -y
```

1) Set the theme back to bartik (1st run only)

```
drush vset
```

1) Export the database

```
drush sql-dump > iji_ready.sql
```

===============================================================================
Baakdrop site:
===============================================================================

1) Import the datbase

```bash
drush sql-cli < iji_ready.sql
```

2) Run update.php (250 pending updates)

```bash
drush updb -y
```

3) Enable the following modules:

```bash
drush en ckeditor dashboard entity_plus nodequeue reference reference_upgrade telemetry  -y
```

4) Import new configuration!

```bash
drush bcim -y
```

5) Manual Data Cleanup:

* Adjust permissions

