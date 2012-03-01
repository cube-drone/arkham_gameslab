#!/bin/bash

rm -rf output
mkdir output
ruby ../deck_gen/deck_generator.rb --deck "Crisis" --file crisis_deck.yaml                  > output/crisis.html
ruby ../deck_gen/deck_generator.rb --deck "Location" --file location_deck.yaml              > output/location.html
ruby ../deck_gen/deck_generator.rb --deck "Common Salvage" --file common_salvage_deck.yaml  > output/common_salvage.html
ruby ../deck_gen/deck_generator.rb --deck "Rare Salvage" --file rare_salvage_deck.yaml      > output/rare_salvage.html
ruby ../deck_gen/deck_generator.rb --deck "Survivor" --file survivor_deck.yaml              > output/survivor.html
ruby ../deck_gen/deck_generator.rb --deck "Emplacement" --file emplacement_deck.yaml        > output/emplacement.html
ruby ../deck_gen/deck_generator.rb --deck "Mutation" --file mutation_deck.yaml              > output/mutation.html