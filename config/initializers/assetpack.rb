# Monkey patch that allows propagation of assets options through subclasses
module Sinatra::AssetPack
  def assets(&block)
    @@options ||= Options.new(self, &block)
    self.assets_initialize!  if block_given?
    @@options
  end
end