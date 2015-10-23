require 'awscosts/rds_on_demand'

class AWSCosts::Rds
  attr_reader :region

  ENGINES = { postgres: 'postgresql', mysql: 'mysql', oracle: 'oracle'}


  def initialize region
    @region = region
  end

  def on_demand(engine, version, type)
    mapped_engine = ENGINES[engine.to_sym]
    puts "--------arta----engine---#{mapped_engine}-------version ----#{version}--type-----#{type}---"
    raise ArgumentError.new("Unknown platform: #{engine}") if mapped_engine.nil?
    AWSCosts::RDSOnDemand.fetch(engine, version, type, @region)
  end

  # class << self
  #   def fetch region
  #     transformed = AWSCosts::Cache.get_jsonp("pricing/1/rds/mysql/pricing-standard-deployments.min.js") do |data|

  #     end
  #   end
  # end
end

# [{"port"=>5432, "engine"=>"postgres"}, {"port"=>3306, "engine"=>"mysql"}, {"port"=>1433, "engine"=>"sqlserver-ee"}, {"port"=>1521, "engine"=>"oracle-se1"}, {"port"=>1521, "engine"=>"oracle-se"}, {"port"=>1521, "engine"=>"oracle-ee"}]