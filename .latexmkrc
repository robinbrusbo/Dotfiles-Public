$clean_ext = 'rip nav snm synctex.gz(busy) acn acr alg aux bbl bcf blg brf
              fdb_latexmk glg glo gls idx ilg ind ist lof log lot out run.xml
              toc dvi';
$pdf_mode = 1;
# Requires all .tex files to be in same directory
$pdflatex="pdflatex -synctex=1 -interaction=nonstopmode main.tex";

# Continuous update
# $pdf_update_method = 0;
# $preview_continuous_mode = 1;
