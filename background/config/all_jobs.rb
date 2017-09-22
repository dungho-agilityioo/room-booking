Dir.glob(File.join(File.dirname(__FILE__), "../app/jobs/*.rb")) do |c|
  require(c)
end
