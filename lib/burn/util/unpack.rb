module Burn
  module Util
    class Unpack
      def unpack(src, dest)
        Zlib::GzipReader.open(src) do |gz|
          Archive::Tar::Minitar::unpack(gz, dest)
        end
      end
    end
  end
end
