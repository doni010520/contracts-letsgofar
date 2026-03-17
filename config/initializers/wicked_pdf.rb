WickedPdf.config = {
  exe_path: ENV.fetch('WKHTMLTOPDF_PATH') { WickedPdf::DEFAULT_BINARY_VERSION::EXE_PATH rescue '/usr/local/bin/wkhtmltopdf' }
}
