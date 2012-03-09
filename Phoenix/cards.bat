rmdir /S /Q output
mkdir output
mkdir output\assets
ruby ../deck_gen/deck_generator.rb -c 9 --file combat_cards.yaml,strategic_objectives.yaml > output/everything.html 
copy deck_style.css output\style.css
copy assets\*.* output\assets\*.*
"C:\Program Files (x86)\wkhtmltopdf\wkhtmltopdf" output\everything.html output\master.pdf
