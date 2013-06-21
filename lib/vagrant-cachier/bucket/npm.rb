module VagrantPlugins
  module Cachier
    class Bucket
      class Npm < Bucket
        def self.capability
          :npmdir
        end

        def install
          machine = @env[:machine]
          guest   = machine.guest

          if guest.capability?(:gemdir)
            if npmdir_path = guest.capability(:npmdir)
              prefix      = npmdir_path.split('/').last
              bucket_path = "/tmp/vagrant-cache/#{@name}/#{prefix}"
              machine.communicate.tap do |comm|
                comm.execute("mkdir -p #{bucket_path}")

                npm_cache_path = "#{npmdir_path}"

                @env[:cache_dirs] << npm_cache_path

                unless comm.test("test -L #{npm_cache_path}")
                  comm.sudo("rm -rf #{npm_cache_path}")
                  comm.sudo("mkdir -p `dirname #{npm_cache_path}`")
                  comm.sudo("ln -s #{bucket_path} #{npm_cache_path}")
                end
              end
            end
          else
            # TODO: Raise a better error
            raise "You've configured a Node NPM cache for a guest machine that does not support it!"
          end
        end
      end
    end
  end
end
