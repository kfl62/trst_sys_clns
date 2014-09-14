## v0.3.0

release date: **2014-xx-xx**


* **feature v0.2.995**, v0.3.0 preparation
   - feature date: **2014-09-14**
   - bump version v0.2.995
   - update CHANGELOG
   - views `shared/_partials` update
   - views `Clns::Stock` CRUD, issue #31
   - assets js, `Clns.desk.stock` update, rewrite
   - views `Clns::Sorting` CRUD, issue #31
   - assets js, `Clns.desk.sorting` update, rewrite
   - views `Clns::PartnerFirm` CRUD, issue #31
   - views `Clns::Invoicee` CRUD, issue #31
   - assets js, `Clns.desk.invoice` update, rewrite
   - assets, views for `Clns::DeliveryNote|Consumption` fix issue #35
   - assets js, fix issue #36
   - views `Clns::Grn` CRUD, issues #31, #35
   - assets css, temporary solution for issue #35
   - assets js, `Clns.desk.grn` update, rewrite, issue #35
   - views `Clns::Freight` CRUD, issue #31
   - assets js, `Clns.desk.freight` update, rewrite, fix #34
   - views `Clns::DeliveryNote` CRUD, issue #31
   - assets js, `Clns.desk.delivery_note` update, rewrite
   - views `Clns::Consumption` CRUD, issue #31
   - assets js, `Clns.desk.consumption` update, rewrite
   - views `Clns::CacheBook` CRUD, issue #31
   - assets js, `Clns.desk.cache_book` update, rewrite
   - views new partial for common selects, fix #33
   - views pdf templates, cleanup & fix #30, see also kfl62/trst_sys_sinatra#22
   - views cleanup (`.hidden, cellspacing`) fix #32


* **feature v0.2.994**, v0.3.0 preparation
   - feature date: **2014-08-26**
   - bump version v0.2.994
   - update CHANGELOG
   - assets js, `main.js` update, fix [issue #29][#29]


* **feature v0.2.993**, v0.3.0 preparation
   - feature date: **2014-08-21**
   - bump version v0.2.993
   - update CHANGELOG
   - views `Clns::PartnerFirm#_queryclient_dln` typo
   - assets js, fix [issue #28][#28]
   - config `firm.yml` update
   - assets css,  use unique style in modules [kfl62/trst_sys_sinatra#12][trst_main#12]
   - views `layout`, use unique layout in `public` controller [kfl62/trst_sys_sinatra#15][trst_main#15]


* **feature v0.2.992**, v0.3.0 preparation
   - feature date: **2014-06-16**
   - bump version v0.2.992
   - update CHANGELOG
   - models bugfix, mostly typo


* **feature v0.2.991**, v0.3.0 preparation
   - feature date: **2014-06-11**
   - bump version v0.2.991
   - update CHANGELOG
   - views `Clns::PartnerFirm` query partials update
   - models `Clns::Stock` inherit from `Trst`, only overwrite
   - models `Clns::Payment` inherit from `Trst`, only overwrite
   - views `Clns::Sorting` renamed field
   - i18n `Clns::Sorting` renamed field
   - models `Clns::Sorting` inherit from `Trst`, only overwrite
   - views `Clns::Invoice` renamed field
   - i18n `Clns::Invoice` renamed field
   - models `Clns::Invoice` inherit from `Trst`, only overwrite
   - views `Clns::Grn` renamed field
   - i18n `Clns::Grn` renamed field
   - models `Clns::Grn` inherit from `Trst`, only overwrite
   - models `Clns::Freight|In|Out|Stock` update to current version from `Trst`
   - views `Clns::DeliveryNote` renamed field
   - i18n `Clns::DeliveryNote` renamed field
   - models `Clns::DeliveryNote` inherit from `Trst`, only overwrite
   - views `Clns::Consumption` renamed field
   - i18n `Clns::Consumption` renamed field
   - models `Clns::Consumption` inherit from `Trst`, only overwrite
   - models `Clns::Cassation` inherit from `Trst`, only overwrite
   - models `Clns::CacheBook` inherit from `Trst`, only overwrite
   - models `Clns::Cache` inherit from `Trst`, only overwrite

* **feature v0.2.990**, v0.3.0 preparation
   - feature date: **2014-06-06**
   - bump version v0.2.990
   - update CHANGELOG
   - models `Clns::Freight|In|Out|Stock` cleanup, inherit from `Trst`
   - models `Clns::PartnerFirm` cleanup, inherit from `Trst`


* **feature v0.2.29**,
   - feature date: **2014-06-01**
   - bump version v0.2.29
   - update CHANGELOG
   - models fix [issue #27][#27], cleanup, optimize


* **feature v0.2.28**, feature [issue #26][#26]
   - feature date: **2014-05-31**
   - bump version v0.2.28
   - update CHANGELOG
   - models fix [issue #26][#26], cleanup, optimize

* **feature v0.2.27**, bugfix [issue #24][#24], feature [issue #23][#23]
   - feature date: **2014-05-27**
   - bump version v0.2.27
   - update CHANGELOG
   - views `Clns::Invoice` pdf template [issue #23][#23]
   - views `Clns::DeliveryNote` pdf template [issue #23][#23]
   - models `Clns::DeliveryNote::sum_freights_inv` add `for_partner` parameter, default false
   - assets js, `Clns.desk.delivery_note` fix [issue #24][#24]


* **feature v0.2.26**, bugfix [issue #22][#22], feature [issue #12][#12]
   - feature date: **2014-05-23**
   - bump version v0.2.26
   - update CHANGELOG
   - views `Clns::Freight` CRUD, updates related to [issue #12][#12]
   - assets js, `Clns.desk.freight` add functionality for [issue #12][#12]
   - i18n `freight.yml` new translations related to [issue #12][#12]
   - models `Clns::Freight`, add field, handle sorting ... [issue #12][#12]
   - views report `stock_monthly` fix [issue #22][#22]


* **feature v0.2.25**, bugfix [issue #21][#21]
   - feature date: **2014-05-15**
   - bump version v0.2.25
   - update CHANGELOG
   - views `report.haml` unit_id bug, fix [issue #21][#21]


* **feature v0.2.24**, `Clns::Stock` print [issue #19][#19]
   - feature date: **2014-05-15**
   - bump version v0.2.24
   - update CHANGELOG
   - i18n `clns.yaml` related to [issue #19][#19] translations
   - views `report.haml` handle `stock_monthly.rb`
   - views report, `stock_monthly.rb` prawn, pdf template


* **feature v0.2.23**, bugfix [issue #16][#16], [issue #17][#17], [issue #18][#18], [issue #17][#17], [issue #20][#20]
   - feature date: **2014-05-14**
   - bump version v0.2.23
   - update CHANGELOG
   - assets js, `Clns.desk.grn` fix [issue #18][#18]
   - assets css, `_dialog.sass` style for `input.val`
   - views: shared partial `_doc_add_freight.haml`, change `val` from span to input, [issue #18][#18]
   - assets js, `Clns.desk.grn` modified, [issue #17][#17]
   - views `Clns::Grn` CRUD `create` modified, fix [issue #17][#17]
   - models all relevant, fix [issue #16][#16]
   - i18n `freights.yml` 05010700 - Geam, fix [issue #20][#20]


* **feature v0.2.22**, `Clns::DeliveryNote|Grn|Consumption|Sorting`, [issue #11][#11]
   - feature date: **2014-05-10**
   - bump version v0.2.22
   - update CHANGELOG
   - views `Clns::Invoice` pdf template, bank info [issue #9][#9]
   - views `Clns::DeliveryNote` pdf template, bank info [issue #9][#9]
   - views `Clns::Grn` CRUD rearrange, edit `doc_name|doc_text` fields, [issue #11][#11]
   - views `Clns::DeliveryNote` CRUD rearrange, edit `doc_name|doc_text` fields, [issue #11][#11]
   - views `Clns::Sorting` CRUD edit `name|text` fields, [issue #11][#11]
   - views `Clns::Consumption` CRUD edit `name|text` fields, [issue #11][#11]


* **feature v0.2.21**, `Clns::PartnerFirm::Bank`,  [issue #9][#9],  [issue #14][#14]
   - feature date: **2014-05-09**
   - bump version v0.2.21
   - update CHANGELOG
   - views `Clns::PartnerFirm::Bank` CRUD, [issue #9][#9]
   - views `Clns::PartnerFirm` partial `_show.haml` add tab for banks
   - i18n `partner_firm.yml` translationa related to [issue #9][#9]
   - models `Clns::PartnerFirm` embed `Clns::PartnerFirm::Bank`, [issue #9][#9]


* **feature v0.2.20**,`Clns::Grn`, issues [issue #7][#7], [issue #10][#10]
   - feature date: **2014-05-09**
   - bump version v0.2.20
   - update CHANGELOG
   - views `Clns::DeliveryNote` show `doc_text` before freight table
   - views `Clns::Grn` pdf template improve and [issue #10][#10]
   - views `Clns::Grn` CRUD updates regarding [issue #7][#7]
   - i18n `grn.yml` add translation, related to [issue #7][#7]
   - models `Clns::Grn` add field `doc_text`, [issue #7][#7]


* **feature v0.2.19**, issues [issue #3][#3], [issue #5][#5], [issue #6][#6], [issue #8][#8]
   - feature date: **2014-05-08**
   - bump version v0.2.19
   - update CHANGELOG
   - i18n `clns.yml` typo and competition
   - views `Clns::Invoice` pdf template fix [issue #8][#8]
   - views `Clns::DeliveryNote` pdf template improve and [issue #5][#5]
   - views `Clns::DeliveryNote` CRUD updates regarding [issue #3][#3]
   - assets js, `Clns.desk.delivery_note`, update `doc_name`, [issue #6][#6]
   - i18n `delivery_note.yml` add translation, related to [issue #3][#3]
   - models `Clns::DeliveryNote` add field `doc_text`, [issue #3][#3]


* **feature v0.2.18**, `Clns::Invoice` pdf template, [issue #4][#4]
   - feature date: **2014-05-07**
   - bump version v0.2.18
   - update CHANGELOG
   - views `Clns::Invoice` pdf template, [issue #4][#4]


* **feature v0.2.17**, `Clns::DeliveryNote` pdf template, [issue #2][#2]
   - feature date: **2014-05-05**
   - bump version v0.2.17
   - update CHANGELOG
   - views `Clns::DeliveryNote` pdf template, closes [issue #2][#2]


* **feature v0.2.16**, `Clns::Invoice` pdf template, [issue #1][#1]
   - feature date: **2014-05-04**
   - bump version v0.2.16
   - update CHANGELOG
   - views `Clns::Invoice` pdf template, closes [issue #1][#1]


* **feature v0.2.15**, `Clns::CacheBook` monthly report
   - feature date: **2014-04-30**
   - bump version v0.2.15
   - update CHANGELOG
   - assets js, `Clns.desk.report` skeleton
   - views `report/cb_monthly.rb` skeleton
   - views `report.haml` for handling tasks which generates reports
   - views `Clns::Cache::Book` pdf template, typo
   - i18n `clns.yml` add translation


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

[trst_main#15]: https://github.com/kfl62/trst_sys_sinatra/issues/15
[trst_main#12]: https://github.com/kfl62/trst_sys_sinatra/issues/12
[#1]: https://github.com/kfl62/trst_sys_clns/issues/1
[#2]: https://github.com/kfl62/trst_sys_clns/issues/2
[#3]: https://github.com/kfl62/trst_sys_clns/issues/3
[#4]: https://github.com/kfl62/trst_sys_clns/issues/4
[#5]: https://github.com/kfl62/trst_sys_clns/issues/5
[#6]: https://github.com/kfl62/trst_sys_clns/issues/6
[#7]: https://github.com/kfl62/trst_sys_clns/issues/7
[#8]: https://github.com/kfl62/trst_sys_clns/issues/8
[#9]: https://github.com/kfl62/trst_sys_clns/issues/9
[#10]: https://github.com/kfl62/trst_sys_clns/issues/10
[#11]: https://github.com/kfl62/trst_sys_clns/issues/11
[#12]: https://github.com/kfl62/trst_sys_clns/issues/12
[#13]: https://github.com/kfl62/trst_sys_clns/issues/13
[#14]: https://github.com/kfl62/trst_sys_clns/issues/14
[#15]: https://github.com/kfl62/trst_sys_clns/issues/15
[#16]: https://github.com/kfl62/trst_sys_clns/issues/16
[#17]: https://github.com/kfl62/trst_sys_clns/issues/17
[#18]: https://github.com/kfl62/trst_sys_clns/issues/18
[#19]: https://github.com/kfl62/trst_sys_clns/issues/19
[#20]: https://github.com/kfl62/trst_sys_clns/issues/20
[#21]: https://github.com/kfl62/trst_sys_clns/issues/21
[#22]: https://github.com/kfl62/trst_sys_clns/issues/22
[#23]: https://github.com/kfl62/trst_sys_clns/issues/23
[#24]: https://github.com/kfl62/trst_sys_clns/issues/24
[#25]: https://github.com/kfl62/trst_sys_clns/issues/25
[#26]: https://github.com/kfl62/trst_sys_clns/issues/26
[#27]: https://github.com/kfl62/trst_sys_clns/issues/27
[#28]: https://github.com/kfl62/trst_sys_clns/issues/28
[#29]: https://github.com/kfl62/trst_sys_clns/issues/29
[#30]: https://github.com/kfl62/trst_sys_clns/issues/30
[#31]: https://github.com/kfl62/trst_sys_clns/issues/31
[#32]: https://github.com/kfl62/trst_sys_clns/issues/32
[#33]: https://github.com/kfl62/trst_sys_clns/issues/33
[#34]: https://github.com/kfl62/trst_sys_clns/issues/34
[#35]: https://github.com/kfl62/trst_sys_clns/issues/35
[#36]: https://github.com/kfl62/trst_sys_clns/issues/36
[#37]: https://github.com/kfl62/trst_sys_clns/issues/37
[#38]: https://github.com/kfl62/trst_sys_clns/issues/38
[#39]: https://github.com/kfl62/trst_sys_clns/issues/39
[#40]: https://github.com/kfl62/trst_sys_clns/issues/40
