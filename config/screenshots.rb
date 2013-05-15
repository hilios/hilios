require 'digest/md5'

class Screenshots
  class << self
    def path
      '/system/screenshots'.freeze
    end

    def path_for(url)
      File.join(path, name_for(url))
    end

    def name_for(url)
      "#{Digest::MD5.hexdigest(url)}.png"
    end
  end
end