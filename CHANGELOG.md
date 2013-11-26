## v0.3.0

release date: **2013-xx-xx**

* **feature v0.2.3.1**, `Clns::DeliveryNote` CRUD completitions
   - feature date: **2013-11-26**
   - views: `Clns::DeliveryNote` CRUD, finished
   - views `Clns::Grn` CRUD (_show,create), bugfix
   - views partials, `/shared/*.haml` Freight|FreightStock issue, cleanup
   - assets js, `grn|delivery_note.js` compiled versions
   - assets js, `Clns.desk.delivery_note` finished
   - assets js, `Clns.desk.grn` cleanup, style, validation fixed
   - assets css, `_base|_dialog.sass` fix some styling
   - i18n `clns|delivery_note|freight|grn.yml` missing translations, fixes
   - models `Clns::DeliveryNote|Grn` #freight_list, show UM
   - models `Clns::Freight|In|Out|Stock` adapt Wstm -> Clns

* **feature v0.2.3**, `Clns::DeliveryNote` CRUD and initiate stocks
   - feature date: **2013-11-21**
   - model `Clns::Stock` initiate, and related changes
   - model `Clns::DeliveryNote` skeleton
   - i18n `Clns::DeliveryNote` missing translations
   - assets js, `Clns.desk.grn` typo
   - assets js, `Clns.desk.delivery_note` skeleton
   - views `Clns::DeliveryNote` CRUD skeleton
   - hotfix `Clns::Grn` pdf, background path

* **feature v0.2.2.1**, `Clns::Grn` CRUD completitions
   - feature date: **2013-11-21**
   - bump version v0.2.2.1
   - update CHANGELOG
   - assets added compiled javascripts
   - assets js, `Clns.desk.grn` handling repair
   - assets css, `_dialog.sass` changed
   - views `/shared/_select_unit.haml` partial
   - views `Clns::Grn` CRUD completitions
   - i18n missing translations
   - model `Clns::Invoice` payments text changed
   - model `Clns::Grn` prepare prefix for 2014

* **feature v0.2.2**, `Clns::Grn` CRUD
   - feature date: **2013-11-20**
   - bump version v0.2.2
   - update CHANGELOG
   - assets `desk_grn.coffee` Clns.desk.grn skeleton
   - assets `_font_awesome|_base|_dialog.sass` bugfix, update
   - views `_doc_add|select_freight.haml` partial
   - views `Clns::Grn` CRUD initial files
   - views `Clns::Freight` CRUD update
   - model `Clns::User` hotfix, login issue
   - models `Clns::Freight|FreightIn|Grn|Invoice` new methods etc.
   - i18n `freight.yml`, `clns.yml` completitions; add `grn.yml`

* **feature v0.2.1**, `Clns::Freight` CRUD
  - feature date: **2013-10-31**
  - views CRUD
  - js `desk_freight.coffee` for `Clns.desk.freight`
  - i18n `freight,yml`
  - model `Clns::Freight`
    - `.criteria_name` show translated category/group/...
    - `#by_id_stats` for generating id_stats
    - cleanup

## v0.2.0

release date: **2013-10-29**

* `Clns::PartnerFirm` model, views, i18n cleanup

* update layout according to TrustSys (JQuery UI v.1.10.3)

* `public\javasctipts\clns` add js (compiled coffeescripts) production ready

## v0.1.0

release date: **2013-07-18**

* Started using git-flow `git flow init`

* Added **CHANGELOG**

* Add version `lib/clns/version.rb`
