Upgrade notes for bollier.org, a Drupal 6 => Backdrop CMS upgrade.

===============================================================================
Drupal 6
===============================================================================

Start in the Drupal 6 site location.

Import
------
* Import a database, as exported from production site.


Log In
------
* Log into the site as user 1.


Cleanup
-------
* From the user interface, uninstall the D6 botcha module (it breaks drush).
* Enable the jeneration update module, on update it will:
  - Removes old unused modules and themes from system table
  - Updates data from ImageLinkField field to Link field.
  - Sets a default value for all book_type fields on book nodes.
  - Converts nodes of type "books I like" to "books" and sets book_type value.
  - Deleted the "books I like" content type.


```bash
drush7 en jeneration -y
```

Update
------
* Run database updates

```bash
drush updb -y
```

Audio to Audiofield
--------------------

* Cross-Grade from Audio to Audiofield

```bash
drush7 en audiofield audio_audiofield features -y
drush updb -y
```

* QA: visit admin/content/node
  - filter for type = podcast
  - there should be nodes

* IMPORTANT: Restore the podcast content type to the database

```bash
drush7 features-consolidate audio_audiofield
```

Modules
--------
* Disable / Uninstall the modules we won't need in Backdrop

```bash
drush dis audio audio_audiofield botcha image_captcha devel devel_generate fieldgroup moopapi views_ui -y
drush pm-uninstall audio audio_audiofield botcha image_captcha devel devel_generate fieldgroup moopapi views_ui -y

drush dis autoload captcha dbtng features image_caption_filter image_resize_filter imce_wysiwyg  -y
drush pm-uninstall autoload captcha dbtng features image_caption_filter image_resize_filter imce_wysiwyg  -y

drush dis globalredirect help imce libraries nice_menus path_redirect pingback poormanscron views wysiwyg -y
drush pm-uninstall globalredirect help imce libraries nice_menus path_redirect pingback poormanscron views wysiwyg -y
```

Themes
-------
* Set to Garland, prepare for upgrade.

```bash
drush7 en garland -y
drush vset theme_default garland
```

Caching
------
* Disable all caching: page cache, block cache, css & js aggregation.

```bash
drush vset cache 0
drush vset block_cache 0
drush vset preprocess_css 0
drush vset preprocess_js 0
```

Filesystem
-----------
* Update filesystem temp dir to /tmp

```bash
drush vset file_directory_temp /tmp
```

Export
--------
* Export the database, ready for import into Drupal 7.

```bash
drush sql-dump > drupal-7-ready.sql
```

===============================================================================
Drupal 7
===============================================================================

Change to the Drupal 7 site location.

Import
--------
* Import the Drupal 6 database, generated in the step previous.

```bash
drush sql-cli < drupal-7-ready.sql
```

Upgrade
--------
* Use the User Interface at update.php to run 222 pending updates.
  - $udpate_free_access must be set to TRUE in settings.local.php
* or Run database updates:

```bash
drush updb -y
```

* In this step the Jeneration module will perform the following updates:
  - Update field formatter for image fields
  - Update field formatter for file fields
  - Remove Drupal 6 modules with no upgrade path from system table.

Fields
-------
* Enable field modules and content_migrate

```bash
drush7 en cck content_migrate file image -y
```

* Migrade all fields from CCK to core.

```bash
drush content-migrate-fields -y
```

Modules
--------
* Disable / Uninstall the modules we won't be needing anymore.

```bash
drush dis audiofield cck content_migrate -y
drush pm-uninstall audiofield cck content_migrate -y
```

Theme
------
* Set theme to Bartik, Admin theme to Seven, disable Garland.

```bash
drush7 en bartik -y
drush vset theme_default bartik -y
drush vset admin_theme seven -y
drush vset node_admin_theme 1 -y
drush dis garland -y
```

Filesystem
-----------
* Update filesystem dir to /files

```bash
drush vset file_public_path files
```

Export
--------
* Export the database, ready for import into Backdrop CMS.

```bash
drush sql-dump > backdrop-ready.sql
```


===============================================================================
Backdrop
===============================================================================

Change to the Drupal 7 site location.

Import
--------
* Copy all config files from /dev-active to /live-active.
* Delete all config files from /dev-active directory
* Import the Drupal 7 database, generated previously.

```bash
drush sql-cli < backdrop-ready.sql
```

Upgrade
--------
* Use the User Interface at update.php to run 147 pending updates.
  - $udpate_free_access must be set to TRUE in settings.local.php
* or Run database updates

```bash
drush updb -y
```

* In this step the Jeneration module will perform the following updates:
  - Update all body content to use Standard text format instead of PHP or unfiltered.
  - Updates all embedded image captions to use data attributes in addition to title.
  - Splits content at teaserbreak into separate summary field.

Log In
-------
* Log into the site as the root user Admin.


Modules - core / custom
------------------------
* Use the User Interface at admin/modules to Enable modules manually that can't be enabled with drush
  - badmin
  - bblocks
  - ckeditor
  - contextual
  - redirect
  - views_ui


Modules - contrib
------------------
* Enable new contrib modules

```bash
drush en captcha devel honeypot field_group jplayer on_the_web recaptcha -y
```

Configuration
--------------
* Sync with "completed" config already in /live-active/ directory

```bash
drush bcim -y
drush cc all
```


