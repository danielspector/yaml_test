require 'yaml'

class ShippingHash
  attr_reader :hash
  
  def initialize(hash)
    @hash = hash
  end

  def method_missing(x)
    @hash.nested_keys.include?("#{x}") ? ShippingHash.new(@hash["#{x}"]) : super
  end

  def first
    ShippingHash.new(@hash[0])
  end

end

class Hash
  def nested_keys
    keys_array = []
    keys.each do |key|
      if self[key].is_a?(Hash)
        keys_array << self[key].nested_keys
      else
        keys_array << key
      end
      keys_array.flatten
    end
  end
end

data = ShippingHash.new(YAML.load(File.open('shipping.yaml')))
puts data.product.first.sku.hash
