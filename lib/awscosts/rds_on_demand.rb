require 'awscosts/rds'

class AWSCosts::RDSOnDemand


  TYPE_URL = {
    new: {
      mysql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      postgresql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      oracle: {
        standard: 'pricing-li-standard-deployments',
        multi_az: 'pricing-li-multiAZ-deployments'
      }
    },
    old: {
      mysql: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'
      },
      postgres: {
        standard: 'pricing-standard-deployments',
        multi_az: 'pricing-multiAZ-deployments'

      },
      oracle: {
        standard: 'pricing-li-standard-deployments',
        multi_az: 'pricing-li-multiAZ-deployments'
      }
    }
  }

  def initialize data
    @data = data
  end

  def data
    @data
  end

  def self.fetch engine, version, type, region
    result = {}
    if version == "new"
      uri_type = "/pricing/1/rds/#{engine}/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    else
      uri_type = "/pricing/1/rds/#{engine}/previous-generation/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    end
    AWSCosts::Cache.get_jsonp(uri_type) do |data|
      data['config']['regions'].each do |r|
        result[r['region']] ||= {}
        r['types'].each do |type|
          type['tiers'].each do |tier|
            price_name_map = {tier['name'] => tier['prices']['USD'].to_f}
            result[r['region']].merge!(price_name_map)
          end
        end
      end
    end
    self.new(result[region])
  end
end

