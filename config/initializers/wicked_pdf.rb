WickedPdf.configure do |config|
  config.exe_path = ENV.fetch('WKHTMLTOPDF_PATH', '/usr/bin/wkhtmltopdf')
end
