rmdir /S /Q output
mkdir output
ruby ../deck_gen/deck_generator.rb --file combat_cards.yaml,strategic_objectives.yaml > output/everything.html
copy deck_style.css output\style.css
copy assets output\assets
"C:\Program Files (x86)\wkhtmltopdf\wkhtmltopdf" output\everything.html output\master.pdf
