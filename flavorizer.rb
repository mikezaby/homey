module Flavorizer
  def self.flavorize_group(group, options = {})
    flavor = options[:flavor]
    flavorized_attributes = options[:flavorized_attributes]
    return group if flavor.nil?

    group.map do |value|
      value = value.dup
      flavorized_attributes.each { |attr| value[attr] = flavorize(value[attr], flavor) }
      value
    end
  end

  def self.flavorize(string, flavor)
    string.include?("%{flavor}") ? (string % { flavor: flavor }) : string
  end

  def self.flavorize!(string, flavor)
    string.replace(flavorize(string, flavor))
  end
end
