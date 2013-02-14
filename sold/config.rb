require 'yaml'

class Sold::Config < Hash
  class << self
    def load (name)
      Sold::Config.new YAML.load_file(self.config_path name)
    end
    def config_path (name)
      # Generate config path based on location of caller
      File.join(File.expand_path(File.dirname($0)), 'data/config/%s.yml' % name)
    end
  end
  def initialize (data)
    self.merge! data
  end
  def save
    File.open(self.class.config_path, 'w+') {|f| f.write(YAML::dump(self)) }
  end
end
