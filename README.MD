Boogert-lab Features of emacs 27.1 for Smallworld

==
General handsome features:
==

=1. enable desktop
This built-in function enables the feature 'desktop' that saves and restores buffers and points.
It saves:
 - some global variables
 - the list of buffers with associated files.  For each buffer also
  - the major mode
  - the default directory
  - the point
  - the mark & mark-active
  - buffer-read-only
  - some local variables
 - frame and window configuration

Implementation
(custom-set-variables
 '(desktop-save-mode t)
 '(desktop-save 'ask)
 '(desktop-path '("E:/boogert-lab/emacs-desktop" "~/.emacs.d/")))

Info: (share/emacs/[27.1]/lisp/desktop.el
Clear: either delete or rename file .emacs.desktop

2. Customisations in Realworld group
Offers customisation group 'rw-custom-group below Smallworld for realworld customisations
Definition file sitelisp/realworld/rw-custom-group.el

3. Emacs Icon & Title
The title of the emacs frame is based on the global variable (setq default-frame-title (getenv "ETITLE"))
The ETITLE variable can be set anywhere in the emacs/smallworld invocation, e.g. in the gis_aliases
See variable (gis-version-frame-title-format) which inserts the current Smallworld version


==
Specific smallworld environment features
==

3. Visit the file under point
If the point is in a delimited file path, open it. Works in every window.
Function (rw-find-file-under-point) in rw-extras.el
Bind to F2 j

4. Toggle auto-insert deprecated pragma comments
The rw-auto-deprecated-pragma-insert variable in 'rw-custom-group enables/disables automatic insert of the deprecated template is automatically inserted and removed when the classify_level
is changed
File: sitelisp/realworld/rw-pragma-changes.el
Boolean variable in 'rw-custom-group

5. Move handig to emacs
(rw-load-shortcuts)
File site-lisp/realworld/magik/shortcuts.magik
Filename can be changed in customisation group 'rw-custom-group
Bind to F2 H (define-key sw-f2-map "H" 'rw-load-shortcuts)
The function will also execute every proc with 'setvars' in its name, enabling specific application settings
It also loads magik files with name matching session debug string in home directory
Offers list of the created (method) shortcuts/globals

Magik> !lv!()
$
_global g<<!current_package![:gis_program_manager]
_global sp<<!current_package![:smallworld_product]
_global smm<<!current_package![:sw_module_manager]
_global mh<<!current_package![:message_handler]
_global p<<!current_package![:print]
_global w<<!current_package![:write]
_global dp<<!current_package![:debug_print]
_global pa<<!current_package![:print_ancestry]
_global ph<<!current_package![:print_hierarchy]
_global ap<<!current_package![:apropos]
_global red<<colour.new_rgb(1,0,0)
_global green<<colour.new_rgb(0,1,0)
_global blue<<colour.new_rgb(0,0,1)
_global white<<colour.new_rgb(1,1,1)
_global black<<colour.new_rgb(0,0,0)
_global red_line<<line_style.new(colour.new_rgb(1,0,0),3)
_global green_line<<line_style.new(colour.new_rgb(0,1,0),3)
_global blue_line<<line_style.new(colour.new_rgb(0,0,1),3)
_global !sv! :proc setvars( optional verbose?)
_global !losv! :proc load_other_setvars( optional verbose?)
_global !lsh! :proc load_session_handig
_global !lv! :proc listvars
_global writer :proc performs_iter_and_writes_elements(a_col, optional an_iter,a_method, gather args)
_global priter :proc iters_and_prints_elements(a_col)
_global wrel :proc loops_over_elements_and_writes_them(a_col, optional a_method)
_global wrkel :proc loops_over_keys_and_elements_and_writes_them(a_col, optional a_method)
_global prel :proc loops_over_elements_and_prints_them(a_col)
_global smd :proc start_module_dialog
_global appl :proc get_application( optional app_name)
_global cur :proc get_selected_geometry( optional app_name)
_global cr :proc get_selected_rwos( optional app_name)
_global ct :proc map_trail( optional app_name)
_global oe :proc current_object_editor( optional app_name)
_global mm :proc current_map_view( optional app_name)
_global cmv :proc current_map_view( optional app_name,view_name)
_global css :proc current_map_view_style_system( optional app_name,tag)
_global cs :proc current_style( optional tag,type,app_name)
_global view :proc returns_view(name)
_global col :proc returns_ds_collection(name, optional view)
_global colat :proc returns_ds_collection_at(name,keys, optional view_or_view_name)
_global field :proc returns_field_descriptor_for_object_fieldname(object_name,field_name, optional view)
_global cols :proc returns_ds_collection_table(name)
_global descr :proc returns_descriptor(name, optional view)
_global cae :proc returns_an_element_from_col(name, optional view)
_global recex :proc gets_record_exemplar(name, optional view)
_global colex :proc gets_collection_record_exemplar(name, optional view)
_global colap :proc returns_writes_ds_collections_matching_string(string, optional view_or_view_name)
_global find_conflicts :proc find_conflict_records(p_version, optional p_verbose?,p_filename)
_global scw :proc show_current_writers
_global soc :proc spatial_object_controller(p_name)
_global dsv :proc all_views
_global raise :proc subsitute_raise_to_show_tracebacks(p_show?)
_method component_framework.cap()
_method condition.cap()
_method object.dp
_method dd_record_and_collection_mixin.fap()
_method object.ae
_method sw_module_manager.map()
_method object.ap()
_method dd_field_type.where_used()
_method object.pa
_method message_handler.map()
_method dd_record_and_collection_mixin.df()
_method smallworld_product.session_string_debug
_method object.ph
_method message_handler.mph
_method object.p
_method ds_version_view.apn()
_method message_handler.mpa
_global gv<<gis_program_manager.cached_dataset(:gis)
_global cv<<gis_program_manager.cached_dataset(:case)
_global acv<<gis_program_manager.ace_view
_global sv<<gis_program_manager.style_view
_global auv<<gis_program_manager.authorisation_view
_global mv<<message_handler.view
_global ws<<gis_program_manager.cached_dataset(:water_supply)
_global dr<<gis_program_manager.cached_dataset(:drainage)
_global csc<<gis_program_manager.cached_dataset(:cs_config)
_global ev<<gis_program_manager.cached_dataset(:electric)

6. (re)enable F2 x to explore an object
This implementation uses the development applications function and start a GUI with the object
(dev-tools-object-inspector)
File: site-lisp/realworld/rw-dev-tools-enhancements.el
Bind to F2 x in three maps:
(sw-multi-define-key
 (list sw-f2-map gis-f2-map magik-f2-map) "x" 'dev-tools-object-inspector)

7. Find string in files
(rw-findstring)
Bind to M-f
File: site-lisp/realworld/rw-findstr.el
Find files with contents matching a pattern and write the result in an interactive buffer *rw-findstr* with a special mode 'Findstr

8. Folder driven magik file templates
This function enhances the smallworld 'magik-template feature by adding a hook to 'magik-template-file-type-hook as defined in file site-lisp/smallworld/magik-template.el.
Matches templates in site-lisp/realworld/templates/ which can be customized in magik-template-dir in rw-custom-group 
based on the patterns defined in (rw-magik-template-file-type)
The code need to be improvided.

9. HTMLIZE: added this feature for pre formatting Magik code into html
Modification of function htmlize-css-insert-head that now inserts css <style> link tag with link to file magik.css
The file magik.css is maintained in repo h-and-m-resources\trunk\rwsp\skins\ge-skin\ge-like.hmskin

