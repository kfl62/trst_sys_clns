## v0.3.0

release date: **2013-xx-xx**

* **feature v0.2.14**, bugfix
   - feature date: **2014-04-30**
   - bump version v0.2.14
   - update CHANGELOG
   - rename `/lib/version.rb` :(
   - i18n `freight.yml` add new sort
   - i18n `sorting.yml` bugfix, typo

* **feature v0.2.13**, `Clns::Sorting` skeletin, CRUD
   - feature date: **2014-04-29**
   - bump version v0.2.13
   - update CHANGELOG
   - assets js, `Clns.desk.sorting` skeleton
   - views `Clns::Freght` query `_data_freight` partial add sorting
   - views `pdf.rb` Prawn skeleton, templte
   - views `Clns::Sorting` CRUD skeleton, for testing
   - i18n `clns.yml` add/modify sorting
   - i18n `sorting.yml` initial translation
   - models `Clns::PartnerFirm|FreightIn|FreightOut` cleanup, add sorting
   - models `Clns::Sorting` skeleton

* **feature v0.2.12**, `Clns::CacheBook` skeletin, CRUD
   - feature date: **2014-04-26**
   - bump version v0.2.12
   - update CHANGELOG
   - assets js, `Clns.desk.cache_book` skeleton
   - assets js, `Clns.desk.scrollHeader` reset functionality
   - assets css, base completions
   - views `pdf.rb` Prawn skeleton, templte
   - views `Clns::CacheBook` CRUD skeleton, for testing
   - i18n `cache_book.yml` initial translation
   - model `Clns::CacheBook` and embedded model, skeleton

* **feature v0.2.12**, `Clns::CacheBook` skeletin, CRUD
   - feature date: **2014-04-26**
   - bump version v0.2.12
   - update CHANGELOG
   - assets js, `Clns.desk.cache_book` skeleton
   - assets js, `Clns.desk.scrollHeader` reset functionality
   - assets css, base completions
   - views `pdf.rb` Prawn skeleton, templte
   - views `Clns::CacheBook` CRUD skeleton, for testing
   - i18n `cache_book.yml` initial translation
   - model `Clns::CacheBook` and embedded model, skeleton

* **feature v0.2.11**, bugfix, pdf templates cleanup, rewrite
   - feature date: **2014-03-02**
   - bump version v0.2.11
   - update CHANGELOG
   - assets `Clns.desk.freight`, generate id_stats on create, bugfix
   - views, assets: `Clns::DeliveryNote`, freight more then once on invoice, bugfix
   - models `Clns::Invoice` freight_list, um bugfix
   - pdf templates cleanup, rewrite

* **feature v0.2.10**, bugfix, `Clns::PartnerFirm` query client, supplier
   - feature date: **2014-02-17**
   - bump version v0.2.10
   - update CHANGELOG
   - views `Clns::PartnerFirm` query functionality
   - assets `Clns.desk.partner_firm` query functionality
   - i18n `partner_firm.yml` add table headers for queries
   - views, i18n `Clns::Freight` missing translations, bugfix
   - `Clns::Invoice` um bug, adapt views and model for query freights

* **feature v0.2.9.2**, bugfix, prepare query `Clns::Freights*`
   - feature date: **2014-02-16**
   - bump version v0.2.9.2
   - update CHANGELOG
   - views `Clns::Freight` query and related partials...
   - views `Clns::Invoice` filter, bugfix, (select year)
   - i18n `freight.yml` reorder, missing translations
   - models `Clns::Freight|In|Out|Stock` query freight related ...

* **feature v0.2.9.1**, bugfix, prepare query `Clns::Freights*`
   - feature date: **2014-02-06**
   - bump version v0.2.9.1
   - update CHANGELOG
   - views `Clns::Stock` bugfix
   - views `Clns::Freight` bugfix, query skeleton
   - i18n `freights.yml` reorder categories
   - models `Clns::Stock#keys` use inherited
   - models `Clns::Freight|In|Out|Stock` bugfix, typo etc.
   - models `Clns::PartnerFirm::Unit#stock_create`, related freights `id_date`

* **feature v0.2.8.2**, some work on models
   - feature date: **2014-01-01**
   - bump version v0.2.8.2
   - update CHANGELOG
   - models improve `increment_name` method, where appropriate
   - models `Clns::PartnerFirm::Unit` add `stock_create` method

* **feature v0.2.8.1**, `Clns::Consumption|Invoice|DeliveryNote` Clns::Grn id_intern == true, bugfix
   - feature date: **2013-12-31**
   - bump version v0.2.8.1
   - update CHANGELOG
   - views `Clns::Grn` CRUD `id_intern == true`, missing UM, bugfix
   - models `Clns::DeliveryNote.sum_freight_grn` missing `um`, bugfix
   - i18n `freights.yml` reorder, missing translations

* **feature v0.2.8**, `Clns::Consumption|Invoice|DeliveryNote` pdf template or placeholder
   - feature date: **2013-12-19**
   - bump version v0.2.8
   - update CHANGELOG
   - `Clns::Consumption|Invoice|DeliveryNote` pdf template or placeholder

* **feature v0.2.7.1**, `Clns::Stock` CRUD, bugfixec
   - feature date: **2013-12-18**
   - bump version v0.2.7.1
   - update CHANGELOG
   - views `Clns::Stock` haml files
   - assets js, `Clns.desk.stock` coffee script, and compiled js
   - views `Clns::Grn|DeliveryNote|Invoice` repair, allow users to see whole month, and some typo
   - assets js, `Clns.desk.grn|delivery_note` repair, focus on date, bugfix
   - i18n `clns.yml` missing translations
   - models `Clns::Consumption` freight_list improved
   - models `Clns::FreightOut` handle_stock, um, bugfix

* **feature v0.2.7**, `Clns::Stock` skeleton, bugfixes
   - feature date: **2013-12-13**
   - bump version v0.2.7
   - update CHANGELOG
   - views `Clns::Stock` CRUD, skeleton
   - i18n `stock.yml` skeleton
   - assets js, `Clns.desk.stock` skeleton
   - models `Clns::Stock` skeleton, relations in other models
   - views `Clns::Grn` pdf template, missing payments, bugfix
   - views `Clns::Consumption` filter, add title to options, bugfix
   - models `Clns::Consumption` add #freights_list method, bugfix
   - models `Clns::FreightOut` doc_con_id, bugfix
   - i18n `freights.yml` reorder, missing translations

* **feature v0.2.6.1**, `Clns::Consumptio` CRUD
   - feature date: **2013-12-08**
   - bump version v0.2.6.1
   - update CHANGELOG
   - views `Clns::Consumption` haml files
   - assets js, `Clns.desk.consumption` coffee script, and compiled js
   - i18n `clns|Consumption.yml` missing translations
   - i18n `freights.yml` reorder categories
   - models `Clns::FreightIn|Out` class method `by_id_stats(id_stats)` bugfix

* **feature v0.2.6**, `Clns::Consumptio` skeleton, js bugfix
   - feature date: **2013-12-03**
   - bump version v0.2.6
   - update CHANGELOG
   - views `Clns::Consumption` CRUD, skeleton
   - i18n `consumption.yml` skeleton
   - assets js, `Clns.desk.consumption` skeleton
   - models `Clns::Consumption` skeleton, relations in other models
   - assets js, `Clns.desk.grn` Save button bugfix, recompiled

* **feature v0.2.5**, `Clns::Grn` transfer storage
   - feature date: **2013-11-29**
   - bump version v0.2.5
   - update CHANGELOG
   - assets: js, `Clns.desk.grn` transfer storage, and recompiled js
   - views `Clns::Grn` CRUD adapt for transfer storage
   - views `Clns::Grn` pdf template, tva|out bug
   - views partial, `_doc_add_freights_stock.haml` unit_id bug
   - models `Clns::DeliveryNote` adapt `sum_freights_grn`

* **feature v0.2.4**, `Clns::Invoice` CRUD
   - feature date: **2013-11-29**
   - bump version v0.2.4
   - update CHANGELOG
   - views `Clns::Invoice` CRUD
   - views partial, `_doc_add_freights_stock.haml` add qu to option title
   - assets js, `desk_invoice.js` compiled versions
   - assets js, `Clns.desk.invoice` skeleton
   - i18n `clna,freight,invoice` missing translations, fixes
   - models `Clns::Invoice|DeliveryNote` adapt Clns -> Clns

* **feature v0.2.3.1**, `Clns::DeliveryNote` CRUD completitions
   - feature date: **2013-11-26**
   - bump version v0.2.3.1
   - update CHANGELOG
   - views: `Clns::DeliveryNote` CRUD, finished
   - views `Clns::Grn` CRUD (_show,create), bugfix
   - views partials, `/shared/*.haml` Freight|FreightStock issue, cleanup
   - assets js, `desk_grn|delivery_note.js` compiled versions
   - assets js, `Clns.desk.delivery_note` finished
   - assets js, `Clns.desk.grn` cleanup, style, validation fixed
   - assets css, `_base|_dialog.sass` fix some styling
   - i18n `clns|delivery_note|freight|grn.yml` missing translations, fixes
   - models `Clns::DeliveryNote|Grn` #freight_list, show UM
   - models `Clns::Freight|In|Out|Stock` adapt Clns -> Clns

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
