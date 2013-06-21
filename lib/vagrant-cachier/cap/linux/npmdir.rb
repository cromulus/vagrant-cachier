module VagrantPlugins
  module Cachier
    module Cap
      module Linux
        module Npmdir
          def self.npmdir(machine)
            npmdir = nil
            machine.communicate.tap do |comm|
              return unless comm.test('which npm')
              comm.execute 'npm config ls -l | grep cache | grep "cache =" | cut -c 10-100 | tr -d \"' do |buffer, output|
                npmdir = output.chomp if buffer == :stdout
              end
            end
            return npmdir
          end
        end
      end
    end
  end
end
