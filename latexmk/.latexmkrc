# Latexmk default configuration

$pdf_previewer = 'evince';

# Always generate pdfs
$pdf_mode = 1;

# Use make to generate missing dependencies
$use_make_for_missing_files = 1;

# Use xelatex for compilation
$pdflatex = "xelatex -interaction=nonstopmode -halt-on-error -synctex=1 --shell-escape %O %S";

# Specify all cleanup files
$clean_ext = "aux fdb_latexmk fls log nav  out snm %R.synctex.gz toc";
