require 'awscosts/rds'

class AWSCosts::RDSOnDemand


  TYPE_URL = {
    new: {
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
    puts "-1---------------engine------#{engine}-----#{version}---#{type}"
    result = {}
    if version == "new"
      uri_type = "/pricing/1/rds/#{engine}/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    else
      uri_type = "/pricing/1/rds/#{engine}/previous-generation/#{TYPE_URL[version.to_sym][engine.to_sym][type.to_sym]}.min.js"
    end
    puts "----------uriyy------#{uri_type}"
    transformed = AWSCosts::Cache.get_jsonp(uri_type) do |data|
      puts "=======------dta------#{data}"
      data['config']['regions'].each do |r|
        result[r['region']] ||= {}
        r['types'].each do |type_t|
          type_t['tiers'].each do |tier|
            result[data['region']].merge!(
              tier['name'] => tier['prices']['USD'].to_f
            )
          end
        end
      end
      result
    end
    self.new(transformed[region])
  end


  #   transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ec2/pricing-elb.min.js') do |data|
  #     result = {}
  #     data['config']['regions'].each do |r|
  #       container = {}
  #       r['types'].each do |type|
  #         type['values'].each do |value|
  #           container[value['rate']] = value['prices']['USD'].to_f
  #         end
  #       end
  #       result[r['region']] = container
  #     end
  #     result
  #   end
  #   self.new(transformed[region])
  # end

end

