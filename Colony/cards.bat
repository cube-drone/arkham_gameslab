rmdir /S /Q output
mkdir output
mkdir output\assets
ruby ../deck_gen/deck_generator.rb -c 8 --file Colony.yaml > output/everything.html 
copy deck_style.css output\style.css
copy assets\*.* output\assets\*.*
"C:\Program Files (x86)\wkhtmltopdf\wkhtmltopdf" -s Letter -O Landscape -B 0 -L 0 -R 0 -T 0 --disable-smart-shrinking output\everything.html output\master.pdf
