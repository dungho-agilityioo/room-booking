
Dir.glob(File.join(File.dirname(__FILE__), "../jobs/*.rb")) do |c|
  require(c)
end
