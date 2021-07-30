#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/wikidata_query'

query = <<SPARQL
  SELECT (STRAFTER(STR(?member), STR(wd:)) AS ?item)
     ?name ?enLabel ?gender ?dob ?dobPrecision
     ?source (STRAFTER(STR(?ps), '/statement/') AS ?psid)
  WHERE {
    ?member p:P39 ?ps .
    ?ps ps:P39 wd:Q21295149 ; pq:P2937 wd:Q107486380 .

    OPTIONAL {
      ?ps prov:wasDerivedFrom ?ref .
      ?ref pr:P854 ?source .
      FILTER CONTAINS(STR(?source), 'govt.lc') .
      OPTIONAL { ?ref pr:P1810 ?sourceName }
    }
    OPTIONAL { ?member rdfs:label ?enLabel FILTER(LANG(?enLabel) = "en") }
    BIND(COALESCE(?sourceName, ?enLabel) AS ?name)

    OPTIONAL { ?member wdt:P21 ?genderItem }
    OPTIONAL {
      ?member p:P569/psv:P569 [wikibase:timeValue ?dob ; wikibase:timePrecision ?dobPrecision]
    }

    SERVICE wikibase:label {
      bd:serviceParam wikibase:language "en".
      ?genderItem rdfs:label ?gender .
    }
  }
  ORDER BY STR(?name)
SPARQL

agent = 'every-politican-scrapers/st-lucia-senate'
puts EveryPoliticianScraper::WikidataQuery.new(query, agent).csv
