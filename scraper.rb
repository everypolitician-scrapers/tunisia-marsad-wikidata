#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

fr_names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: "https://fr.wikipedia.org/wiki/Liste_des_députés_de_la_Ire_législature_de_l'Assemblée_des_représentants_du_peuple",
  after: '//span[@id="Composition_par_circonscription"]',
  xpath: '//table[.//th[.="Nom"]]//td[2]//a[not(@class="new")]/@title',
)

ar_col = 'الحزب'
ar_names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: "https://ar.wikipedia.org/wiki/قائمة_أعضاء_مجلس_نواب_الشعب_التونسي_الأول",
  after: '//span[@id=".D8.A7.D9.84.D8.A3.D8.B9.D8.B6.D8.A7.D8.A1_.D8.AD.D8.B3.D8.A8_.D8.A7.D9.84.D8.AF.D8.A7.D8.A6.D8.B1.D8.A9_.D8.A7.D9.84.D8.A7.D9.86.D8.AA.D8.AE.D8.A7.D8.A8.D9.8A.D8.A9"]',
  xpath: '//table[.//th[.="%s"]]//td[3]//a[not(@class="new")]/@title' % ar_col,
)

# Find all P39s of the 1st Term
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    VALUES ?membership { wd:Q29169698 }
    VALUES ?term { wd:Q18600849 }

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { fr: fr_names, ar: ar_names })


