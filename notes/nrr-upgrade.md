Upgrade notes for noreciperequired.com, a Drupal 7 => Backdrop CMS upgrade.

**Upgrade accomplished: April 8th, 2018**

===============================================================================

This is a central repo for the upgrade of noreciperequired.com. It will contain
both the current Drupal 7 codebase, as well as the new Backdrop codebase.

## Doing the Update

The generic procedure for doing the update from D7 to Backdrop is:

1. Export the database and sites/default/files from the live site.

2. Import to local D7 site with modified codebase (from Bitbucket).
   Be sure the sites/default/files directory and its files and subdirectories
   are read/writeable by your web process!

3. Enable the nrr_bd_update module (NRR BUpdates in the UI).
     drush -y en nrr_bd_update

4. Set the default theme to Bartik.
     drush -y en bartik
     drush -y vset theme_default bartik
     drush -y dis community

5. Run updates (should mostly be from the nrr_bd_update module).
   Note: the Drush command should show OK on all updates, but then
   afterwards it will have some undefined function errors. That is OK.
     drush -y updb

6. Export the database and sites/default/files from the local D7 site.

7. Import into Backdrop. Some notes:
   a. The files should go into the files directory at the
      root level in the Backdrop docroot, but make a symbolic link to
      sites/default/files. You can also remove some directories from files:
        cd files
        rm -rf advagg_css advagg_js css ctools custom_search fontyourface \
          honeypot iframe_filter imagecache \
          js media-icons media-youtube minify \
          styles xmlsitemap css
        cd ..
        mkdir sites/default
        cd sites/default
        ln -s ../../files .
   b. Be sure the files directory and its files and subdirectories are
      read/writeable by your web and/or Drush processes!
   c. Read the note in backdrop/config/README.md about how to set up your
      Backdrop site settings.php to use the config directories in this repo.
   d. Read note below about Drush if you haven't used it in Backdrop before.

8. Run updates.
     drush -y updb -y

9. Log in and enable the following modules on admin/modules
    ckeditor, metatag, nrr_blocks, on_the_web, and reference
   (doesn't currently work to enable these modules in Drush apparently).

10. Run updates again. There should be 2 updates from the Reference module.
     drush -y updb

11. Go to admin/config/people/permissions. Give Administrator all permissions
    and save.

12. Sync config (to get layouts, views, etc. that were stored there). This is
    at admin/config/development/configuration/sync
    Note: You will get an error about devel.settings, but that is OK.

13. Clear all caches.

14. Make config changes, and commit them to bitbucket in directory
    backdrop/config/staging.


### Drush

To use Drush with Backdrop, you need the 8.x branch of Drush, plus this
addition:
https://github.com/backdrop-contrib/drush


### Taxonomies

(JH): I don't think the Culinary Schools vocabulary is being used. It looks like
they were thinking of using this, but then they used something else to make the
culinary programs menu?


### Entity Reference

(JH): I did a bit of digging in the database. There is only one field defined
that uses this module: field_related_categories.

This field has been added to all of the taxonomy vocabularies, and also one node
type: Landing Page.

However, none of the landing pages on the site actually has any data for this
field, so I think we can probably just delete this field from that content type
before migrating.

I do not know why entityreference was used for the fields on the taxonomy
vocabularies, and not a regular Taxonomy field. I think the sensible thing to do
would be to migrate these fields to be regular Taxonomy fields instead.

As an example of where this is used, look at the Main Ingredients field and edit
the Filet Mignon field. It has this field filled in. The field help says
"If left blank, "Top Categories" will be used instead.".

However, if you actually go to the Filet Mignon taxonomy term page, you will
still see Top Categories on the right sidebar. So I don't actually think the
related categories are being used on the site.

Also this field is not used in any views according to the Fields Used In Views
report. admin/reports/fields/views-fields

So...

Option 1: Remove the Related Category fields and their data.

Option 2: Migrate them to Taxonomy fields, and possibly consider actually using
the data somewhere on the site.

Option 3: Migrate them to be references or something else... not sure why we
would want to do that though since Taxonomy is in Core and probably just as
good?

### Media/YouTube

There is currently one field, field_video, which is a File field using
media_youtube. It is attached to node types panel (which can be deleted),
recipe, and technique. There are a number of files in the file_managed
table that correspond to this field (mime type video/youtube).

These fields are not using the emfield widget, so I don't think we need the
emfield module. We can just remove it.

Migrating to Youtube module in BD

field_data table:

SELECT fdfv.entity_type, fdfv.bundle, fdfv.deleted, fdfv.entity_id, fdfv.revision_id, fdfv.language, fdfv.delta, CONCAT('https://www.youtube.com/watch?v=', SUBSTRING(fm.uri, 13)) AS field_video_video_input, SUBSTRING(fm.uri, 13) AS field_video_video_id FROM field_data_field_video fdfv left join file_managed fm on fdfv.field_video_fid = fm.fid WHERE 1

field_revision table:

SELECT fdfv.entity_type, fdfv.bundle, fdfv.deleted, fdfv.entity_id, fdfv.revision_id, fdfv.language, fdfv.delta, CONCAT('https://www.youtube.com/watch?v=', SUBSTRING(fm.uri, 13)) AS field_video_video_input, SUBSTRING(fm.uri, 13) AS field_video_video_id FROM field_revision_field_video fdfv left join file_managed fm on fdfv.field_video_fid = fm.fid WHERE 1

NOTE: This has been incorporated into the NRR BUpdates module.

### taxonomy_menu_block:

(JH) I didn't make an upgrade path for this module. What we need to do:

1. Disable/uninstall module on D7 site.
2. Migrate to Backdrop.
3. When we get to the step where we create the layout for the Taxonomy term
   pages, create a taxonomy menu block for each one:
   * Go to admin/structure/block/taxonomy_menu_block.
   * Click the Add new link.
   * Configuration: Select the desired vocabulary, and use "Dynamic parent"
   * All the other options are default values.
   * Save the block.
4. The Taxonomy page has all these blocks in the sidebar currently.

That will reproduce the current structure. However, note that only hierarchical
vocabularies will actually have anything in their Taxonomy Menu Block. So, it
probably only makes sense to make a block for the Main Ingredient and Location
blocks, and maybe Culinary Schools. The others are flat.

NOTE: Uninstall has been incorporated into the NRR BUpdates module. Layouts
and views will be created in Backdrop and stored in config directory to sync.

### field_collection

We are going to use multifield instead. We've already replicated the data that
was in the one field using field_collection. So, to migrate to Backdrop:

1. Go to Manage Fields for the List Article content type on D7 site.
2. Delete the "List items" (field_list, Field collection) field.
3. Disable/uninstall the field_collection module on the D7 site.

NOTE: This has been incorporated into the NRR BUpdates module.
